CLASS kernel_call_transformation DEFINITION PUBLIC.
* handling of ABAP statement CALL TRANSFORMATION
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_options,
             initial_components TYPE string,
             xml_header         TYPE string,
           END OF ty_options.

    CONSTANTS: BEGIN OF gc_options,
                 suppress TYPE string VALUE 'suppress',
               END OF gc_options.

    CLASS-METHODS call
      IMPORTING
        name    TYPE any
        options TYPE any.
  PRIVATE SECTION.
    CLASS-DATA mi_doc     TYPE REF TO if_ixml_document.
    CLASS-DATA ms_options TYPE ty_options.

    CLASS-METHODS parse_xml
      IMPORTING
        iv_xml TYPE string.

    CLASS-METHODS parse_options
      IMPORTING options TYPE any.
ENDCLASS.

CLASS kernel_call_transformation IMPLEMENTATION.

  METHOD call.
* first convert SOURCE to internal format stored in "MI_DOC"?
* then output to RESULT

    DATA lv_name   TYPE string.
    DATA lv_source TYPE string.
    DATA lv_result TYPE string.
    DATA result    TYPE REF TO data.
    DATA lt_rtab   TYPE abap_trans_resbind_tab.
    DATA ls_rtab   LIKE LINE OF lt_rtab.
    DATA lv_type   TYPE string.
    DATA lv_dummy  TYPE string.
    DATA li_writer TYPE REF TO if_sxml_writer.
    DATA li_doc    TYPE REF TO if_ixml_document.
    DATA lv_bom_big TYPE string.
    DATA lv_bom_little TYPE string.
    DATA lv_xstring TYPE xstring.


    CLEAR mi_doc.

    lv_xstring = cl_abap_char_utilities=>byte_order_mark_big.
    lv_bom_big = cl_abap_codepage=>convert_from(
      source   = lv_xstring
      codepage = 'UTF-16' ).

    lv_xstring = cl_abap_char_utilities=>byte_order_mark_little.
    lv_bom_little = cl_abap_codepage=>convert_from(
      source   = lv_xstring
      codepage = 'UTF-16' ).

*    WRITE '@KERNEL console.dir(INPUT);'.

* only the ID transformation is implemented
    WRITE '@KERNEL lv_name.set(INPUT.name.toUpperCase());'.
    ASSERT lv_name = 'ID'.

    parse_options( options ).

* Handle input SOURCE
    WRITE '@KERNEL if (INPUT.sourceXML?.constructor.name === "ABAPObject") this.mi_doc.set(INPUT.sourceXML);'.
    WRITE '@KERNEL if (INPUT.sourceXML?.constructor.name === "String") lv_source.set(INPUT.sourceXML);'.
    IF lv_source IS NOT INITIAL.
      IF lv_source(1) = '<'
          OR ( strlen( lv_source ) > 1 AND ( lv_source(1) = lv_bom_big OR lv_source(1) = lv_bom_little ) AND lv_source+1(1) = '<' ).
        lv_type = 'XML'.
        parse_xml( lv_source ).
      ELSEIF lv_source(1) = '{' OR lv_source(1) = '['.
        lv_type = 'JSON'.
        mi_doc = kernel_json_to_ixml=>build( lv_source ).
      ELSE.
        RAISE EXCEPTION TYPE cx_xslt_format_error.
      ENDIF.
    ENDIF.

* input = object, output = ixml_document
    WRITE '@KERNEL if (typeof INPUT.source === "object"'.
    WRITE '@KERNEL     && INPUT.resultXML?.constructor.name === "ABAPObject"'.
    WRITE '@KERNEL     && INPUT.resultXML?.qualifiedName === "IF_IXML_DOCUMENT") {'.
    WRITE '@KERNEL   li_doc.set(INPUT.resultXML);'.
    WRITE '@KERNEL   lv_dummy = INPUT.source;'.
    WRITE '@KERNEL }'.
    IF li_doc IS NOT INITIAL.
      lcl_object_to_ixml=>run(
        ii_doc = li_doc
        source = lv_dummy ).
      RETURN.
    ENDIF.

* input = object, output = sxml_writer
    WRITE '@KERNEL if (typeof INPUT.source === "object"'.
    WRITE '@KERNEL     && INPUT.resultXML?.constructor.name === "ABAPObject") {'.
    WRITE '@KERNEL   li_writer.set(INPUT.resultXML);'.
    WRITE '@KERNEL   lv_dummy = INPUT.source;'.
    WRITE '@KERNEL }'.
    IF li_writer IS NOT INITIAL.
      lcl_object_to_sxml=>run(
        ii_writer = li_writer
        source    = lv_dummy ).
      RETURN.
    ENDIF.

* input = string, output = string
    WRITE '@KERNEL if (INPUT.resultXML && INPUT.resultXML.constructor.name === "String") {'.
    WRITE '@KERNEL   if (INPUT.sourceXML && INPUT.sourceXML.constructor.name === "String") {'.
    WRITE '@KERNEL     lv_result.set("X");'.
    WRITE '@KERNEL     lv_dummy = INPUT.sourceXML;'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL }'.
    IF lv_result = abap_true.
      lv_result = lcl_string_to_string=>run(
        source  = lv_dummy
        options = ms_options ).
      WRITE '@KERNEL   INPUT.resultXML.set(lv_result);'.
      RETURN.
    ENDIF.

* input = object, output = string
    WRITE '@KERNEL if (INPUT.resultXML && INPUT.resultXML.constructor.name === "String") {'.
    WRITE '@KERNEL   lv_result.set("X");'.
    WRITE '@KERNEL   lv_dummy = INPUT.source;'.
    WRITE '@KERNEL }'.
    IF lv_result = abap_true.
      lv_result = lcl_object_to_string=>run(
        is_options = ms_options
        source     = lv_dummy ).
      WRITE '@KERNEL   INPUT.resultXML.set(lv_result);'.
      RETURN.
    ENDIF.

    IF lv_source IS INITIAL AND mi_doc IS INITIAL.
      RAISE EXCEPTION TYPE cx_xslt_runtime_error.
    ENDIF.

* output = is an ABAP internal table, dynamic result parameter
    WRITE '@KERNEL if (INPUT.result.constructor.name === "Table") {'.
    WRITE '@KERNEL lt_rtab = INPUT.result;'.
    LOOP AT lt_rtab INTO ls_rtab.
      kernel_ixml_xml_to_data=>build(
        iv_name = ls_rtab-name
        iv_ref  = ls_rtab-value
        ii_doc  = mi_doc ).
    ENDLOOP.
    WRITE '@KERNEL } else {'.
* INPUT.result is a javascript structure
    WRITE '@KERNEL for (const name in INPUT.result) {'.
    WRITE '@KERNEL   lv_name.set(name.toUpperCase());'.
    WRITE '@KERNEL   if (INPUT.result[name].constructor.name === "FieldSymbol") {'.
    WRITE '@KERNEL     result.assign(INPUT.result[name].getPointer());'.
    WRITE '@KERNEL   } else {'.
    WRITE '@KERNEL     result.assign(INPUT.result[name]);'.
    WRITE '@KERNEL   }'.
    IF lv_type = 'JSON'.
      kernel_ixml_json_to_data=>build(
        iv_name = lv_name
        iv_ref  = result
        ii_doc  = mi_doc ).
    ELSE.
      kernel_ixml_xml_to_data=>build(
        iv_name = lv_name
        iv_ref  = result
        ii_doc  = mi_doc ).
    ENDIF.
    WRITE '@KERNEL }'.
    WRITE '@KERNEL }'.

  ENDMETHOD.

  METHOD parse_options.
* https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-US/abapcall_transformation_options.htm

    DATA lv_name  TYPE string.
    DATA lv_value TYPE string.

    FIELD-SYMBOLS <lv_field> TYPE string.


    WRITE '@KERNEL for (const name in INPUT.options || {}) {'.
    WRITE '@KERNEL   lv_name.set(name);'.
    WRITE '@KERNEL   lv_value.set(INPUT.options[name]);'.
    ASSIGN COMPONENT lv_name OF STRUCTURE ms_options TO <lv_field>.
    IF sy-subrc = 0.
      <lv_field> = lv_value.
    ENDIF.
    WRITE '@KERNEL }'.

  ENDMETHOD.


  METHOD parse_xml.

    DATA li_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream TYPE REF TO if_ixml_istream.
    DATA li_parser  TYPE REF TO if_ixml_parser.
    DATA li_ixml    TYPE REF TO if_ixml.
    DATA lv_subrc   TYPE i.

    li_ixml = cl_ixml=>create( ).
    mi_doc  = li_ixml->create_document( ).

    li_factory = li_ixml->create_stream_factory( ).
    li_istream = li_factory->create_istream_string( iv_xml ).
    li_parser = li_ixml->create_parser( stream_factory = li_factory
                                        istream        = li_istream
                                        document       = mi_doc ).
    li_parser->add_strip_space_element( ).
    lv_subrc = li_parser->parse( ).
    li_istream->close( ).

    ASSERT lv_subrc = 0.

  ENDMETHOD.

ENDCLASS.