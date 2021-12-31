CLASS ltcl_call_transformation DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1_xml FOR TESTING RAISING cx_static_check.
    METHODS test2_xml FOR TESTING RAISING cx_static_check.
    METHODS test1_json FOR TESTING RAISING cx_static_check.
    METHODS invalid_input FOR TESTING RAISING cx_static_check.
    METHODS empty_input FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_call_transformation IMPLEMENTATION.

  METHOD test1_json.

    DATA: BEGIN OF ls_message,
            field TYPE i,
          END OF ls_message.
    DATA lv_input TYPE string.
    lv_input = '{"DATA": {"FIELD": 321}}'.

    CALL TRANSFORMATION id SOURCE XML lv_input RESULT data = ls_message.

    " cl_abap_unit_assert=>assert_equals(
    "   act = ls_message-field
    "   exp = 321 ).

  ENDMETHOD.

  METHOD empty_input.
    DATA ls_message TYPE i.
    DATA lv_input TYPE string.
    lv_input = ''.
    TRY.
        CALL TRANSFORMATION id SOURCE XML lv_input RESULT data = ls_message.
      CATCH cx_xslt_runtime_error.
    ENDTRY.
  ENDMETHOD.

  METHOD invalid_input.
    DATA ls_message TYPE i.
    DATA lv_json TYPE string.
    lv_json = 'invalid'.
    TRY.
        CALL TRANSFORMATION id SOURCE XML lv_json RESULT data = ls_message.
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xslt_format_error.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD test1_xml.
    DATA lv_xml TYPE string.
    DATA: BEGIN OF ls_foo,
            foo TYPE i,
          END OF ls_foo.
    
    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">\n| &&
      | <asx:values>\n| &&
      |  <DATA>\n| &&
      |   <FOO>2</FOO>\n| &&
      |  </DATA>\n| &&
      | </asx:values>\n| &&
      |</asx:abap>|.
    
    CALL TRANSFORMATION id
      SOURCE XML lv_xml
      RESULT data = ls_foo.

    cl_abap_unit_assert=>assert_equals(
      act = ls_foo-foo
      exp = 2 ).
  ENDMETHOD.

  METHOD test2_xml.

    DATA li_git            TYPE REF TO if_ixml_element.
    DATA li_abap           TYPE REF TO if_ixml_node.
    DATA li_stream_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream        TYPE REF TO if_ixml_istream.
    DATA li_element        TYPE REF TO if_ixml_element.
    DATA li_version        TYPE REF TO if_ixml_node.
    DATA li_parser         TYPE REF TO if_ixml_parser.
    DATA lv_xml            TYPE string.
    DATA mi_ixml     TYPE REF TO if_ixml.
    DATA mi_xml_doc  TYPE REF TO if_ixml_document.
    DATA lt_rtab  TYPE abap_trans_resbind_tab.
    FIELD-SYMBOLS <ls_rtab> LIKE LINE OF lt_rtab.

    DATA: BEGIN OF ls_data,
            foo TYPE i,
          END OF ls_data.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<abapGit version="v1.0.0">\n| &&
      | <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">\n| &&
      |  <asx:values>\n| &&
      |   <DATA>\n| &&
      |    <FOO>2</FOO>\n| &&
      |   </DATA>\n| &&
      |  </asx:values>\n| &&
      | </asx:abap>\n| &&
      |</abapGit>|.

    mi_ixml     = cl_ixml=>create( ).
    mi_xml_doc  = mi_ixml->create_document( ).

    li_stream_factory = mi_ixml->create_stream_factory( ).
    li_istream = li_stream_factory->create_istream_string( lv_xml ).
    li_parser = mi_ixml->create_parser( stream_factory = li_stream_factory
                                        istream        = li_istream
                                        document       = mi_xml_doc ).
    li_parser->add_strip_space_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = li_parser->parse( ) 
      exp = 0 ).
    li_istream->close( ).

* fix()
    li_git ?= mi_xml_doc->find_from_name_ns( depth = 0
                                             name = 'abapGit' ).
    li_abap = li_git->get_first_child( ).
    mi_xml_doc->get_root( )->remove_child( li_git ).
    mi_xml_doc->get_root( )->append_child( li_abap ).

* CALL TRANSFORMATION    
    CALL TRANSFORMATION id
      OPTIONS value_handling = 'accept_data_loss'
      SOURCE XML mi_xml_doc
      RESULT data = ls_data.

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-foo
      exp = 2 ).

* via dynamic table    
    CLEAR ls_data.
    APPEND INITIAL LINE TO lt_rtab ASSIGNING <ls_rtab>.
    <ls_rtab>-name = 'DATA'.
    GET REFERENCE OF ls_data INTO <ls_rtab>-value.

    CALL TRANSFORMATION id
      OPTIONS value_handling = 'accept_data_loss'
      SOURCE XML mi_xml_doc
      RESULT (lt_rtab).

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-foo
      exp = 2 ).

  ENDMETHOD.

ENDCLASS.