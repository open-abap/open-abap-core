CLASS ltcl_call_transformation DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS test2 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_call_transformation IMPLEMENTATION.

  METHOD test1.
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

  METHOD test2.

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

  ENDMETHOD.

ENDCLASS.