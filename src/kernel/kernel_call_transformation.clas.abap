CLASS kernel_call_transformation DEFINITION PUBLIC.
* handling of ABAP statement CALL TRANSFORMATION  
  PUBLIC SECTION.
    CLASS-METHODS call IMPORTING input TYPE any.
  PRIVATE SECTION.
    CLASS-DATA mi_doc TYPE REF TO if_ixml_document.
    CLASS-METHODS parse_xml IMPORTING iv_xml TYPE string.
    CLASS-METHODS parse_json IMPORTING iv_json TYPE string.
    CLASS-METHODS traverse IMPORTING
      iv_name TYPE string 
      iv_ref  TYPE REF TO data.
ENDCLASS.

CLASS kernel_call_transformation IMPLEMENTATION.

  METHOD call.

    DATA lv_name   TYPE string.
    DATA lv_source TYPE string.
    DATA result    TYPE REF TO data.
    DATA lt_rtab   TYPE abap_trans_resbind_tab.
    DATA ls_rtab   LIKE LINE OF lt_rtab.

    CLEAR mi_doc.

* only the ID transformation is implemented
    WRITE '@KERNEL lv_name.set(INPUT.name);'.
    ASSERT lv_name = 'id'.

    WRITE '@KERNEL if (INPUT.sourceXML.constructor.name === "ABAPObject") this.mi_doc.set(INPUT.sourceXML);'.
    WRITE '@KERNEL if (INPUT.sourceXML.constructor.name === "String") lv_source.set(INPUT.sourceXML);'.

    IF lv_source IS INITIAL AND mi_doc IS INITIAL.
      RAISE EXCEPTION TYPE cx_xslt_runtime_error.
    ENDIF.

    IF lv_source IS NOT INITIAL.
      IF lv_source(1) = '<'.
        parse_xml( lv_source ).
      ELSEIF lv_source(1) = '{' OR lv_source(1) = '['.
        parse_json( lv_source ).
      ELSE.
        RAISE EXCEPTION TYPE cx_xslt_format_error.
      ENDIF.
    ENDIF.

    WRITE '@KERNEL if (INPUT.result.constructor.name === "Table") {'.
* INPUT.result is an ABAP internal table
    WRITE '@KERNEL lt_rtab = INPUT.result;'.
    LOOP AT lt_rtab INTO ls_rtab.
      traverse(
        iv_name = ls_rtab-name
        iv_ref  = ls_rtab-value ).
    ENDLOOP.

    WRITE '@KERNEL } else {'.
* INPUT.result is a javascript structure 
    WRITE '@KERNEL for (const name in INPUT.result) {'.
    WRITE '@KERNEL lv_name.set(name);'.
    WRITE '@KERNEL result.assign(INPUT.result[name]);'.
    traverse(
      iv_name = lv_name
      iv_ref  = result ).
    WRITE '@KERNEL }'.
    WRITE '@KERNEL }'.

*    WRITE '@KERNEL console.dir(INPUT.result.data);'.

  ENDMETHOD.

  METHOD traverse.

    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA lo_struc TYPE REF TO cl_abap_structdescr.
    DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_sub TYPE REF TO if_ixml_element.
    DATA ls_compo LIKE LINE OF lt_comps.
    FIELD-SYMBOLS <structure> TYPE any.
    FIELD-SYMBOLS <field> TYPE any.

*    WRITE '@KERNEL console.dir(iv_ref.getPointer());'.
    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struc ?= lo_type.

        li_element = mi_doc->find_from_name_ns(
          depth = 0
          name  = to_upper( iv_name ) ).
*        WRITE '@KERNEL console.dir(li_element);'.
        IF li_element IS INITIAL.
          RETURN.
        ENDIF.

        lt_comps = lo_struc->get_components( ).
        ASSIGN iv_ref->* TO <structure>.
        LOOP AT lt_comps INTO ls_compo.
          li_sub = li_element->find_from_name_ns(
            name      = ls_compo-name 
            namespace = '' 
            depth     = 0 ).
*          WRITE '@KERNEL console.dir(li_sub);'.
          IF li_sub IS INITIAL.
            CONTINUE.
          ENDIF.

*          WRITE / ls_compo-name.
          ASSIGN COMPONENT ls_compo-name OF STRUCTURE <structure> TO <field>.
          <field> = li_sub->get_value( ).
        ENDLOOP.
*        WRITE / 'structure'.
    ENDCASE.
*    WRITE '@KERNEL console.dir(iv_ref.getPointer());'.
    
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

  METHOD parse_json.

    DATA li_reader TYPE REF TO if_sxml_reader.
    li_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( iv_json ) ).

    mi_doc  = cl_ixml=>create( )->create_document( ).

  ENDMETHOD.

ENDCLASS.