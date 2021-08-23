CLASS kernel_call_transformation DEFINITION PUBLIC.
* handling of ABAP statement CALL TRANSFORMATION  
  PUBLIC SECTION.
    CLASS-METHODS call IMPORTING input TYPE any.
  PRIVATE SECTION.
    CLASS-DATA mi_doc TYPE REF TO if_ixml_document.
    CLASS-METHODS parse_xml IMPORTING iv_xml TYPE string.
    CLASS-METHODS traverse IMPORTING
      iv_name TYPE string 
      iv_ref  TYPE REF TO any.
ENDCLASS.

CLASS kernel_call_transformation IMPLEMENTATION.

  METHOD call.

    DATA lv_name TYPE string.
    DATA source_xml TYPE string.
    DATA result TYPE REF TO any.
    
* INPUT is magic...
*    WRITE '@KERNEL console.dir(INPUT);'.
    WRITE '@KERNEL lv_name.set(INPUT.name);'.
    WRITE '@KERNEL if (INPUT.sourceXML) source_xml.set(INPUT.sourceXML);'.
*    WRITE '@KERNEL if (INPUT.result) result.assign(INPUT.result);'.
*    WRITE '@KERNEL console.dir(result);'.

* only the ID transformation is implemented
    ASSERT lv_name = 'id'.

    IF source_xml IS NOT INITIAL.
      parse_xml( source_xml ).
    ENDIF.

    WRITE '@KERNEL for (const name in INPUT.result) {'.
    WRITE '@KERNEL lv_name.set(name);'.
    WRITE '@KERNEL result.assign(INPUT.result[name]);'.
    traverse(
      iv_name = lv_name
      iv_ref  = result ).
    WRITE '@KERNEL }'.

  ENDMETHOD.

  METHOD traverse.

    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA lo_struc TYPE REF TO cl_abap_structdescr.
    DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    DATA ls_compo LIKE LINE OF lt_comps.

*    WRITE '@KERNEL console.dir(iv_ref->*);'.
*    WRITE '@KERNEL console.dir(iv_ref.getPointer());'.
    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struc ?= lo_type.
        lt_comps = lo_struc->get_components( ).
        LOOP AT lt_comps INTO ls_compo.
          WRITE / ls_compo-name.
        ENDLOOP.
        WRITE / 'structure'.
    ENDCASE.
    
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