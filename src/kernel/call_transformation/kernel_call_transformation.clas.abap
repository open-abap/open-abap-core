CLASS kernel_call_transformation DEFINITION PUBLIC.
* handling of ABAP statement CALL TRANSFORMATION
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_options,
             initial_components TYPE string,
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
    CLASS-DATA mi_writer  TYPE REF TO if_sxml_writer.
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
    DATA lo_writer TYPE REF TO cl_sxml_string_writer.
    DATA ls_rtab   LIKE LINE OF lt_rtab.
    DATA lv_type   TYPE string.
    DATA lo_data_to_xml TYPE REF TO lcl_data_to_xml.
    DATA lv_dummy  TYPE string.

    CLEAR mi_doc.
    CLEAR mi_writer.

*    WRITE '@KERNEL console.dir(INPUT);'.

* only the ID transformation is implemented
    WRITE '@KERNEL lv_name.set(INPUT.name.toUpperCase());'.
    ASSERT lv_name = 'ID'.

    parse_options( options ).

* Handle input SOURCE
    WRITE '@KERNEL if (INPUT.sourceXML?.constructor.name === "ABAPObject") this.mi_doc.set(INPUT.sourceXML);'.
    WRITE '@KERNEL if (INPUT.sourceXML?.constructor.name === "String") lv_source.set(INPUT.sourceXML);'.
    IF lv_source IS NOT INITIAL.
      IF lv_source(1) = '<'.
        lv_type = 'XML'.
        parse_xml( lv_source ).
      ELSEIF lv_source(1) = '{' OR lv_source(1) = '['.
        lv_type = 'JSON'.
        mi_doc = kernel_json_to_ixml=>build( lv_source ).
      ELSE.
        RAISE EXCEPTION TYPE cx_xslt_format_error.
      ENDIF.
    ENDIF.

* input = object, output = sxml_writer
    WRITE '@KERNEL if (typeof INPUT.source === "object" && INPUT.resultXML?.constructor.name === "ABAPObject") {'.
    WRITE '@KERNEL   this.mi_writer.set(INPUT.resultXML);'.
    WRITE '@KERNEL   lv_dummy = INPUT.source;'.
    WRITE '@KERNEL }'.
    IF mi_writer IS NOT INITIAL.
      lcl_object_to_sxml=>run(
        ii_writer = mi_writer
        source    = lv_dummy ).
      RETURN.
    ENDIF.

    WRITE '@KERNEL if (INPUT.resultXML && INPUT.resultXML.constructor.name === "String") {'.
    WRITE '@KERNEL   lv_result.set("X");'.
    WRITE '@KERNEL }'.
    IF lv_result = abap_true.
      lv_result = '<?xml version="1.0" encoding="utf-16"?><asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0"><asx:values>'.
      CREATE OBJECT lo_data_to_xml
        EXPORTING
          is_options = ms_options.
      WRITE '@KERNEL if (INPUT.source.constructor.name === "Object") {'.
      WRITE '@KERNEL   for (const name in INPUT.source) {'.
      WRITE '@KERNEL     lv_name.set(name);'.
      WRITE '@KERNEL     if (INPUT.source[name].constructor.name === "FieldSymbol") {'.
      WRITE '@KERNEL       result.assign(INPUT.source[name].getPointer());'.
      WRITE '@KERNEL     } else {'.
      WRITE '@KERNEL       result.assign(INPUT.source[name]);'.
      WRITE '@KERNEL     }'.
      lv_result = lv_result && lo_data_to_xml->run(
        iv_name = to_upper( lv_name )
        iv_ref  = result ).
      WRITE '@KERNEL   }'.
      WRITE '@KERNEL } else if (INPUT.source.constructor.name === "Table") {'.
* dynamic input via ABAP_TRANS_SRCBIND_TAB
      WRITE '@KERNEL   for (const row of INPUT.source.array()) {'.
*      WRITE '@KERNEL     console.dir(row);'.
      WRITE '@KERNEL     lv_name.set(row.get().name.get());'.
      WRITE '@KERNEL     result.assign(row.get().value.dereference());'.
      lv_result = lv_result && lo_data_to_xml->run(
        iv_name = to_upper( lv_name )
        iv_ref  = result ).
      WRITE '@KERNEL   }'.
      WRITE '@KERNEL } else {'.
      ASSERT 1 = 'invalid input'.
      WRITE '@KERNEL }'.

      lv_result = lv_result &&
        |</asx:values>{ lo_data_to_xml->serialize_heap( ) }</asx:abap>|.
      WRITE '@KERNEL   INPUT.resultXML.set(lv_result);'.
      RETURN.
    ENDIF.

    IF lv_source IS INITIAL AND mi_doc IS INITIAL.
      RAISE EXCEPTION TYPE cx_xslt_runtime_error.
    ENDIF.

    WRITE '@KERNEL if (INPUT.result.constructor.name === "Table") {'.
* INPUT.result is an ABAP internal table, dynamic result parameter
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

*    WRITE '@KERNEL console.dir(INPUT.result.data);'.

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