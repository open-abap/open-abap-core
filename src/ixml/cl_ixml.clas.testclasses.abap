CLASS ltcl_xml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS render_empty_output FOR TESTING RAISING cx_static_check.
    METHODS render_element FOR TESTING RAISING cx_static_check.
    METHODS render_element_ns FOR TESTING RAISING cx_static_check.
    METHODS render_element_ns_prefix FOR TESTING RAISING cx_static_check.
    METHODS render_element_and_attribute FOR TESTING RAISING cx_static_check.
    METHODS render_element_and_two_attribute FOR TESTING RAISING cx_static_check.
    METHODS render_value FOR TESTING RAISING cx_static_check.
    METHODS render_nested FOR TESTING RAISING cx_static_check.

    METHODS parse_basic FOR TESTING RAISING cx_static_check.
    METHODS parse_namespace FOR TESTING RAISING cx_static_check.
    METHODS parse_negative FOR TESTING RAISING cx_static_check.
    METHODS moving_nodes FOR TESTING RAISING cx_static_check.
    METHODS parse_attributes FOR TESTING RAISING cx_static_check.
    METHODS parse_attributes2 FOR TESTING RAISING cx_static_check.
    METHODS parse_attributes3 FOR TESTING RAISING cx_static_check.
    METHODS create FOR TESTING RAISING cx_static_check.
    METHODS create_set_attributes FOR TESTING RAISING cx_static_check.

    DATA mi_ixml TYPE REF TO if_ixml.
    DATA mi_document TYPE REF TO if_ixml_document.
    METHODS setup.

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
    METHODS render
      RETURNING
        VALUE(rv_xml) TYPE string.
ENDCLASS.

CLASS ltcl_xml IMPLEMENTATION.

  METHOD setup.
    mi_ixml = cl_ixml=>create( ).
    mi_document = mi_ixml->create_document( ).
  ENDMETHOD.

  METHOD create_set_attributes.
    DATA lo_encoding TYPE REF TO if_ixml_encoding.
    lo_encoding = mi_ixml->create_encoding(
      byte_order    = if_ixml_encoding=>co_platform_endian
      character_set = 'utf-8' ).
    mi_document->set_encoding( lo_encoding ).
    mi_document->set_standalone( abap_true ).
  ENDMETHOD.

  METHOD render_element.
    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element(
      name   = 'moo'
      parent = mi_document ).
    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><moo/>' ).
  ENDMETHOD.

  METHOD render_element_ns.
    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element_ns(
      name   = 'moo'
      parent = mi_document ).
    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><moo/>' ).
  ENDMETHOD.

  METHOD render_element_ns_prefix.
    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element_ns(
      prefix = 'hello'
      name   = 'moo'
      parent = mi_document ).
    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><hello:moo/>' ).
  ENDMETHOD.

  METHOD render_element_and_attribute.
    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element(
      name   = 'moo'
      parent = mi_document ).
    lo_element->set_attribute_ns(
      name  = 'xmlns'
      value = 'bar' ).
    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><moo xmlns="bar"/>' ).
  ENDMETHOD.

  METHOD render_element_and_two_attribute.
    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element(
      name   = 'moo'
      parent = mi_document ).
    lo_element->set_attribute_ns(
      name  = 'xmlns'
      value = 'bar' ).
    lo_element->set_attribute_ns(
      name  = 'anoth'
      value = 'bar2' ).
    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><moo xmlns="bar" anoth="bar2"/>' ).
  ENDMETHOD.

  METHOD render_value.
    DATA lv_xml  TYPE string.
    DATA li_node TYPE REF TO if_ixml_node.

    li_node ?= mi_document->create_simple_element(
      name   = 'moo'
      parent = mi_document ).
    li_node->set_value( '2' ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><moo>2</moo>' ).
  ENDMETHOD.

  METHOD render_nested.
    DATA lv_xml  TYPE string.
    DATA li_node TYPE REF TO if_ixml_node.

    li_node ?= mi_document->create_simple_element(
      name   = 'top'
      parent = mi_document ).
    mi_document->create_simple_element(
      name   = 'sub'
      parent = li_node ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><top><sub/></top>' ).
  ENDMETHOD.

  METHOD create.
    DATA li_current TYPE REF TO if_ixml_node.
    li_current = mi_document->get_root( ).
    ASSERT li_current IS NOT INITIAL.
    ASSERT li_current->get_name( ) = '#document'.
    ASSERT li_current->get_namespace( ) IS INITIAL.
    ASSERT li_current->get_value( ) IS INITIAL.
  ENDMETHOD.

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

  METHOD render.
    DATA li_ostream  TYPE REF TO if_ixml_ostream.
    DATA li_renderer TYPE REF TO if_ixml_renderer.
    DATA li_factory  TYPE REF TO if_ixml_stream_factory.

    li_factory = mi_ixml->create_stream_factory( ).
    li_ostream = li_factory->create_ostream_cstring( rv_xml ).
    li_renderer = mi_ixml->create_renderer(
      ostream  = li_ostream
      document = mi_document ).
    li_renderer->render( ).
  ENDMETHOD.

  METHOD render_empty_output.
    DATA lv_xml TYPE string.
    lv_xml = render( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?>' ).
  ENDMETHOD.

  METHOD parse.

    DATA li_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream TYPE REF TO if_ixml_istream.
    DATA li_parser  TYPE REF TO if_ixml_parser.
    DATA lv_subrc   TYPE i.

    ri_doc = mi_document.

    li_factory = mi_ixml->create_stream_factory( ).
    li_istream = li_factory->create_istream_string( iv_xml ).
    li_parser = mi_ixml->create_parser( stream_factory = li_factory
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
    DATA li_found TYPE REF TO if_ixml_element.
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

    li_found = li_doc->find_from_name_ns(
      depth = 0
      name  = 'sub' ).
    cl_abap_unit_assert=>assert_not_initial( li_found ).

  ENDMETHOD.

  METHOD parse_attributes.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_node    TYPE REF TO if_ixml_node.
    DATA li_version TYPE REF TO if_ixml_node.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><abapGit vers="abc" foo="2"></abapGit>|.
    li_doc = parse( lv_xml ).

    li_node ?= li_doc->find_from_name_ns( depth = 0 name = 'abapGit' ).
    li_version = li_node->get_attributes( )->get_named_item_ns( 'vers' ).

    cl_abap_unit_assert=>assert_not_initial( li_version ).

    cl_abap_unit_assert=>assert_equals(
      act = li_version->get_value( )
      exp = |abc| ).

  ENDMETHOD.

  METHOD parse_attributes2.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_version TYPE REF TO if_ixml_node.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><abapGit version="v1.0.0" serializer="LCL_OBJECT_DTEL"></abapGit>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns( depth = 0 name = 'abapGit' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_attribute_ns( 'serializer' )
      exp = |LCL_OBJECT_DTEL| ).

  ENDMETHOD.

  METHOD parse_attributes3.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_version TYPE REF TO if_ixml_node.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><abapGit></abapGit>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns( depth = 0 name = 'abapGit' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

* not found, should return blank
    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_attribute_ns( 'sdfsdfsd' )
      exp = || ).

  ENDMETHOD.

  METHOD parse_negative.
    RETURN. " todo, test parser errors are thrown
  ENDMETHOD.

ENDCLASS.