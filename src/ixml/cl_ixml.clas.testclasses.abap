CLASS ltcl_xml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS render_empty_output FOR TESTING RAISING cx_static_check.
    METHODS parse_basic FOR TESTING RAISING cx_static_check.
    METHODS parse_namespace FOR TESTING RAISING cx_static_check.
    METHODS parse_negative FOR TESTING RAISING cx_static_check.
    METHODS moving_nodes FOR TESTING RAISING cx_static_check.
          
    METHODS parse
      IMPORTING 
        iv_xml TYPE string 
      RETURNING 
        VALUE(ri_doc) TYPE REF TO if_ixml_document.
    METHODS dump
      IMPORTING
        ii_list        TYPE REF TO if_ixml_node_list
      RETURNING
        VALUE(rv_dump) TYPE string.

ENDCLASS.

CLASS ltcl_xml IMPLEMENTATION.

  METHOD dump.

    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node TYPE REF TO if_ixml_node.

    li_iterator = ii_list->create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        EXIT. " current loop
      ENDIF.

      rv_dump = |{ rv_dump }NAME:{
        li_node->get_name( ) }|.
      rv_dump = |{ rv_dump },DEPTH:{
        li_node->get_depth( ) },VALUE:{ 
        li_node->get_value( ) }|.
      IF li_node->get_namespace( ) IS NOT INITIAL.
        rv_dump = |{ rv_dump },NS:{ li_node->get_namespace( ) }|.
      ENDIF.
      IF li_node->is_leaf( ) = abap_true.
        rv_dump = |{ rv_dump },LEAF:{ li_node->is_leaf( ) }|.
      ENDIF.
      rv_dump = |{ rv_dump }\n|.

      rv_dump = rv_dump && dump( li_node->get_children( ) ).
    ENDDO.

  ENDMETHOD.

  METHOD render_empty_output.

    DATA li_doc      TYPE REF TO if_ixml_document.
    DATA li_ostream  TYPE REF TO if_ixml_ostream.
    DATA li_renderer TYPE REF TO if_ixml_renderer.
    DATA lv_xml      TYPE string.
    DATA li_factory  TYPE REF TO if_ixml_stream_factory.
    DATA li_ixml     TYPE REF TO if_ixml.

    li_ixml = cl_ixml=>create( ).
    li_doc = li_ixml->create_document( ).
    li_factory = li_ixml->create_stream_factory( ).
    li_ostream = li_factory->create_ostream_cstring( lv_xml ).
    li_renderer = li_ixml->create_renderer(
      ostream  = li_ostream
      document = li_doc ).
    li_renderer->render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?>' ).

  ENDMETHOD.

  METHOD parse.

    DATA li_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream TYPE REF TO if_ixml_istream.
    DATA li_parser  TYPE REF TO if_ixml_parser.
    DATA li_ixml    TYPE REF TO if_ixml.
    DATA lv_subrc   TYPE i.

  
    li_ixml = cl_ixml=>create( ).
    ri_doc  = li_ixml->create_document( ).
 
    li_factory = li_ixml->create_stream_factory( ).
    li_istream = li_factory->create_istream_string( iv_xml ).
    li_parser = li_ixml->create_parser( stream_factory = li_factory
                                        istream        = li_istream
                                        document       = ri_doc ).
    li_parser->add_strip_space_element( ).
    lv_subrc = li_parser->parse( ).
    li_istream->close( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_subrc
      exp = 0 ).

  ENDMETHOD.

  METHOD parse_basic.
    
    DATA lv_xml     TYPE string.
    DATA lv_dump    TYPE string.
    DATA lv_expected TYPE string.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<abapGit version="v1.0.0">\n| &&
      | <foo>blah</foo>\n| &&
      | <bar>moo</bar>\n| &&
      |</abapGit>|.
    
    lv_expected =
      |NAME:abapGit,DEPTH:2,VALUE:blahmoo\n| &&
      |NAME:foo,DEPTH:1,VALUE:blah\n| &&
      |NAME:#text,DEPTH:0,VALUE:blah,LEAF:X\n| &&
      |NAME:bar,DEPTH:1,VALUE:moo\n| &&
      |NAME:#text,DEPTH:0,VALUE:moo,LEAF:X\n|.

    lv_dump = dump( parse( lv_xml )->if_ixml_node~get_children( ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_dump
      exp = lv_expected ).

  ENDMETHOD.

  METHOD parse_namespace.

    DATA lv_xml     TYPE string.
    DATA lv_dump    TYPE string.
    DATA lv_expected TYPE string.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<abapGit version="v1.0.0">\n| &&
      | <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">\n| &&
      |  <asx:values>\n| &&
      |   <DATA>\n| &&
      |    <FOO>val</FOO>\n| &&
      |   </DATA>\n| &&
      |  </asx:values>\n| &&
      | </asx:abap>\n| &&
      |</abapGit>|.
    
    lv_expected =
      |NAME:abapGit,DEPTH:5,VALUE:val\n| &&
      |NAME:abap,DEPTH:4,VALUE:val,NS:asx\n| &&
      |NAME:values,DEPTH:3,VALUE:val,NS:asx\n| &&
      |NAME:DATA,DEPTH:2,VALUE:val\n| &&
      |NAME:FOO,DEPTH:1,VALUE:val\n| &&
      |NAME:#text,DEPTH:0,VALUE:val,LEAF:X\n|.

    lv_dump = dump( parse( lv_xml )->if_ixml_node~get_children( ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_dump
      exp = lv_expected ).

  ENDMETHOD.

  METHOD moving_nodes.

    DATA lv_xml  TYPE string.
    DATA li_git  TYPE REF TO if_ixml_node.
    DATA li_sub  TYPE REF TO if_ixml_node.
    DATA li_doc  TYPE REF TO if_ixml_document.
    DATA lv_dump TYPE string.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?><abapGit><sub></sub></abapGit>|.

    li_doc = parse( lv_xml ).
    lv_dump = dump( li_doc->if_ixml_node~get_children( ) ).
    
    li_git ?= li_doc->find_from_name_ns( depth = 0
                                         name = 'abapGit' ).
    li_sub = li_git->get_first_child( ).
    cl_abap_unit_assert=>assert_not_initial( li_sub ).

    li_doc->get_root( )->remove_child( li_git ).
    li_doc->get_root( )->append_child( li_sub ).

    lv_dump = dump( li_doc->if_ixml_node~get_children( ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_dump
      exp = |NAME:sub,DEPTH:0,VALUE:,LEAF:X\n| ).

  ENDMETHOD.

  METHOD parse_negative.
    RETURN. " todo, test parser errors are thrown
  ENDMETHOD.

ENDCLASS.