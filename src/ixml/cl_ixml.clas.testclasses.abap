CLASS ltcl_xml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS render_empty_output FOR TESTING RAISING cx_static_check.
    METHODS render_element FOR TESTING RAISING cx_static_check.
    METHODS render_element_ns FOR TESTING RAISING cx_static_check.
    METHODS render_element_ns_prefix FOR TESTING RAISING cx_static_check.
    METHODS render_element_ns_prefix_value FOR TESTING RAISING cx_static_check.
    METHODS render_element_and_attribute FOR TESTING RAISING cx_static_check.
    METHODS render_element_and_two_attribu FOR TESTING RAISING cx_static_check.
    METHODS render_attribute FOR TESTING RAISING cx_static_check.
    METHODS render_attribute_multi FOR TESTING RAISING cx_static_check.
    METHODS render_value FOR TESTING RAISING cx_static_check.
    METHODS render_escape FOR TESTING RAISING cx_static_check.
    METHODS render_nested FOR TESTING RAISING cx_static_check.
    METHODS render_document_namespace_pref FOR TESTING RAISING cx_static_check.
    METHODS parse_basic FOR TESTING RAISING cx_static_check.
    METHODS root_element_after_crlf FOR TESTING RAISING cx_static_check.
    METHODS first_child_after_crlf FOR TESTING RAISING cx_static_check.
    METHODS parse_blank_only_value FOR TESTING RAISING cx_static_check.
    METHODS parse_indented_children FOR TESTING RAISING cx_static_check.
    METHODS parse_escaped_attribute FOR TESTING RAISING cx_static_check.
    METHODS render_escaped_attribute FOR TESTING RAISING cx_static_check.
    METHODS attribute_roundtrip FOR TESTING RAISING cx_static_check.
    METHODS parse_decimal_reference FOR TESTING RAISING cx_static_check.
    METHODS parse_hex_reference FOR TESTING RAISING cx_static_check.
    METHODS parse_escaped_reference FOR TESTING RAISING cx_static_check.
    METHODS parse_not_a_reference FOR TESTING RAISING cx_static_check.
    METHODS parse_reference_attribute FOR TESTING RAISING cx_static_check.
    METHODS parse_cdata FOR TESTING RAISING cx_static_check.
    METHODS parse_cdata_not_unescaped FOR TESTING RAISING cx_static_check.
    METHODS parse_cdata_newline FOR TESTING RAISING cx_static_check.
    METHODS parse_cdata_empty FOR TESTING RAISING cx_static_check.
    METHODS parse_comment FOR TESTING RAISING cx_static_check.
    METHODS parse_comment_before_root FOR TESTING RAISING cx_static_check.
    METHODS parse_comment_with_markup FOR TESTING RAISING cx_static_check.
    METHODS parse_comment_only_child FOR TESTING RAISING cx_static_check.
    METHODS parse_attribute_on_new_line FOR TESTING RAISING cx_static_check.
    METHODS parse_attributes_two_spaces FOR TESTING RAISING cx_static_check.
    METHODS parse_attribute_single_quote FOR TESTING RAISING cx_static_check.
    METHODS parse_attribute_name_dash FOR TESTING RAISING cx_static_check.
    METHODS parse_element_name_dash FOR TESTING RAISING cx_static_check.
    METHODS parse_doctype FOR TESTING RAISING cx_static_check.
    METHODS parse_doctype_subset FOR TESTING RAISING cx_static_check.
    METHODS parse_processing_instruction FOR TESTING RAISING cx_static_check.
    METHODS parse_instruction_in_element FOR TESTING RAISING cx_static_check.
    METHODS parse_text_without_markup FOR TESTING RAISING cx_static_check.
    METHODS parse_text_after_root FOR TESTING RAISING cx_static_check.
    METHODS parse_unclosed_tag FOR TESTING RAISING cx_static_check.
    METHODS element_get_attributes FOR TESTING RAISING cx_static_check.
    METHODS element_remove_attribute FOR TESTING RAISING cx_static_check.
    METHODS remove_attribute_unknown FOR TESTING RAISING cx_static_check.
    METHODS attribute_map_get_item FOR TESTING RAISING cx_static_check.
    METHODS attribute IMPORTING iv_xml TYPE string iv_name TYPE string RETURNING VALUE(rv_value) TYPE string.
    METHODS parse_value_with_newline FOR TESTING RAISING cx_static_check.
    METHODS parse_bom FOR TESTING RAISING cx_static_check.
    METHODS parse_empty FOR TESTING RAISING cx_static_check.
    METHODS parse_namespace FOR TESTING RAISING cx_static_check.
    METHODS parse_unescape FOR TESTING RAISING cx_static_check.
    METHODS moving_nodes FOR TESTING RAISING cx_static_check.
    METHODS parse_attributes FOR TESTING RAISING cx_static_check.
    METHODS parse_attributes2 FOR TESTING RAISING cx_static_check.
    METHODS parse_attributes3 FOR TESTING RAISING cx_static_check.
    METHODS parse_attributes4 FOR TESTING RAISING cx_static_check.
    METHODS parse_value_whitespace FOR TESTING RAISING cx_static_check.
    METHODS parse_value_spaces_kept FOR TESTING RAISING cx_static_check.
    METHODS parse_special FOR TESTING RAISING cx_static_check.
    METHODS parse_hash FOR TESTING RAISING cx_static_check.
    METHODS parse_attr_dash FOR TESTING RAISING cx_static_check.
    METHODS parse_tag_dot FOR TESTING RAISING cx_static_check.
    METHODS parse_href FOR TESTING RAISING cx_static_check.
    METHODS parse_percent FOR TESTING RAISING cx_static_check.
    METHODS parse_tag_space FOR TESTING RAISING cx_static_check.
    METHODS parse_attr_any_value FOR TESTING RAISING cx_static_check.
    METHODS create FOR TESTING RAISING cx_static_check.
    METHODS create_set_attributes FOR TESTING RAISING cx_static_check.
    METHODS set_attribute_twice FOR TESTING RAISING cx_static_check.
    METHODS parse_and_render FOR TESTING RAISING cx_static_check.
    METHODS parse_close_tag FOR TESTING RAISING cx_static_check.
    METHODS parse_more FOR TESTING RAISING cx_static_check.
    METHODS get_first_child FOR TESTING RAISING cx_static_check.
    METHODS create_ostream_xstring FOR TESTING RAISING cx_static_check.
    METHODS fix_children FOR TESTING RAISING cx_static_check.
    METHODS empty_root_element FOR TESTING RAISING cx_static_check.
    METHODS another_children FOR TESTING RAISING cx_static_check.
    METHODS render_standalone FOR TESTING RAISING cx_static_check.
    METHODS render_namespaced_attr FOR TESTING RAISING cx_static_check.
    METHODS pretty1 FOR TESTING RAISING cx_static_check.
    METHODS pretty2 FOR TESTING RAISING cx_static_check.
    METHODS pretty3 FOR TESTING RAISING cx_static_check.
    METHODS pretty4 FOR TESTING RAISING cx_static_check.
    METHODS pretty5 FOR TESTING RAISING cx_static_check.
    METHODS add_stuff FOR TESTING RAISING cx_static_check.
    METHODS create_attribute_ns FOR TESTING RAISING cx_static_check.
    METHODS create_text FOR TESTING RAISING cx_static_check.
    METHODS spaces FOR TESTING RAISING cx_static_check.
    METHODS spaces_inner FOR TESTING RAISING cx_static_check.
    METHODS top_attr FOR TESTING RAISING cx_static_check.
    METHODS unqualified_attr FOR TESTING RAISING cx_static_check.
    METHODS attrs_test FOR TESTING RAISING cx_static_check.
    METHODS get_elements_by_tag_name FOR TESTING RAISING cx_static_check.
    METHODS get_elements_by_tag_name_elem FOR TESTING RAISING cx_static_check.
    METHODS get_elements_by_tag_name_ns FOR TESTING RAISING cx_static_check.
    METHODS get_elements_by_tag_name_empty FOR TESTING RAISING cx_static_check.
    METHODS get_next_sibling FOR TESTING RAISING cx_static_check.
    METHODS get_next_last_sibling FOR TESTING RAISING cx_static_check.
    METHODS get_next_after_move FOR TESTING RAISING cx_static_check.
    METHODS find_from_path FOR TESTING RAISING cx_static_check.
    METHODS find_from_path_relative FOR TESTING RAISING cx_static_check.
    METHODS find_from_path_not_found FOR TESTING RAISING cx_static_check.
    METHODS find_from_name_element FOR TESTING RAISING cx_static_check.

    DATA mi_ixml     TYPE REF TO if_ixml.
    DATA mi_document TYPE REF TO if_ixml_document.

    METHODS setup.

    METHODS parse
      IMPORTING
        iv_xml        TYPE string
      RETURNING
        VALUE(ri_doc) TYPE REF TO if_ixml_document.

    METHODS dump_nodes
      IMPORTING
        ii_list        TYPE REF TO if_ixml_node_list
      RETURNING
        VALUE(rv_dump) TYPE string.

    METHODS render
      RETURNING
        VALUE(rv_xml) TYPE string.

    METHODS pretty_print
      RETURNING
        VALUE(rv_xml) TYPE string.
ENDCLASS.

CLASS ltcl_xml IMPLEMENTATION.

  METHOD setup.
    mi_ixml = cl_ixml=>create( ).
    mi_document = mi_ixml->create_document( ).
  ENDMETHOD.

  METHOD set_attribute_twice.

    DATA li_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    li_element = mi_document->create_simple_element( name   = `tag`
                                                     parent = mi_document ).
    li_element->set_attribute( name  = `count`
                               value = `1` ).
    li_element->set_attribute( name  = `count`
                               value = `2` ).

    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_attribute( `count` )
      exp = `2` ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = |<?xml version="1.0" encoding="utf-16"?><tag count="2"/>| ).

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

  METHOD render_element_ns_prefix_value.
    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element_ns(
      prefix = 'hello'
      name   = 'moo'
      parent = mi_document ).
    lo_element->set_value( 'asdf' ).
    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><hello:moo>asdf</hello:moo>' ).
  ENDMETHOD.

  METHOD render_attribute.
    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element_ns(
      prefix = 'hello'
      name   = 'moo'
      parent = mi_document ).
    lo_element->set_attribute(
      name  = 'name'
      value = 'value' ).
    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><hello:moo name="value"/>' ).
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

  METHOD render_attribute_multi.
    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element_ns(
      prefix = 'hello'
      name   = 'moo'
      parent = mi_document ).
    lo_element->set_attribute(
      name  = 't'
      value = 'value' ).
    lo_element->set_attribute(
      name  = 'si'
      value = 'value' ).
    lo_element->set_attribute(
      name  = 'ref'
      value = 'value' ).
    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><hello:moo t="value" si="value" ref="value"/>' ).
  ENDMETHOD.

  METHOD render_element_and_two_attribu.
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

  METHOD render_escape.
    DATA lv_xml  TYPE string.
    DATA li_node TYPE REF TO if_ixml_node.

    li_node ?= mi_document->create_simple_element(
      name   = 'moo'
      parent = mi_document ).
    li_node->set_value( |&<>"'| ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><moo>&amp;&lt;&gt;&quot;&apos;</moo>' ).
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

  METHOD render_document_namespace_pref.
    DATA lv_xml  TYPE string.
    DATA li_node TYPE REF TO if_ixml_node.

    mi_document->set_namespace_prefix( prefix = 'a' ).
    li_node ?= mi_document->create_simple_element(
      name   = 'top'
      parent = mi_document ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><top/>' ).
  ENDMETHOD.

  METHOD create.
    DATA li_current TYPE REF TO if_ixml_node.
    li_current = mi_document->get_root( ).
    ASSERT li_current IS NOT INITIAL.
    ASSERT li_current->get_name( ) = '#document'.
    ASSERT li_current->get_namespace( ) IS INITIAL.
    ASSERT li_current->get_value( ) IS INITIAL.
  ENDMETHOD.

  METHOD dump_nodes.
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

      rv_dump = rv_dump && dump_nodes( li_node->get_children( ) ).
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

  METHOD root_element_after_crlf.

    DATA lv_xml  TYPE string.
    DATA li_root TYPE REF TO if_ixml_element.

    " CRLF after the prolog: parse( ) removes newlines but the carriage
    " return remains and becomes a #text node before the root element
    lv_xml = |<?xml version="1.0"?>\r\n<root><item>A</item></root>|.


    li_root = parse( lv_xml )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_name( )
      exp = `root` ).

  ENDMETHOD.

  METHOD first_child_after_crlf.

    DATA lv_xml   TYPE string.
    DATA li_child TYPE REF TO if_ixml_node.

    lv_xml = |<?xml version="1.0"?>\r\n<root><item>A</item></root>|.

    li_child = parse( lv_xml )->get_first_child( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_child->get_name( )
      exp = `root` ).

  ENDMETHOD.

  METHOD parse_value_with_newline.

    DATA lv_xml  TYPE string.
    DATA li_root TYPE REF TO if_ixml_element.

    lv_xml = |<root><item>a\nb</item></root>|.

    li_root = parse( lv_xml )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = |a\nb| ).

  ENDMETHOD.

  METHOD parse_blank_only_value.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><item> </item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = ` ` ).

  ENDMETHOD.

  METHOD parse_indented_children.

    DATA li_root TYPE REF TO if_ixml_element.
    DATA li_item TYPE REF TO if_ixml_node.

    " whitespace between two tags stays formatting, the first child of root
    " is the element and not a #text node
    li_root = parse( |<root>\n  <item>A</item>\n</root>| )->get_root_element( ).

    li_item = li_root->get_first_child( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_item->get_name( )
      exp = `item` ).

  ENDMETHOD.

  METHOD parse_escaped_attribute.

    DATA li_root TYPE REF TO if_ixml_element.
    DATA li_item TYPE REF TO if_ixml_node.

    li_root = parse( |<root><item foo="a&lt;b&amp;c"/></root>| )->get_root_element( ).
    li_item = li_root->get_first_child( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_item->get_attributes( )->get_named_item( `foo` )->get_value( )
      exp = `a<b&c` ).

  ENDMETHOD.

  METHOD render_escaped_attribute.

    DATA lo_element TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    lo_element = mi_document->create_simple_element(
      name   = 'moo'
      parent = mi_document ).
    lo_element->set_attribute(
      name  = 'name'
      value = |&<>"| ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><moo name="&amp;&lt;&gt;&quot;"/>' ).

  ENDMETHOD.

  METHOD attribute_roundtrip.

    DATA lv_xml TYPE string.

    " the parser unescapes, the renderer escapes again - the document that
    " went in is the document that comes out
    parse( |<root foo="a&lt;b&amp;c&quot;d"/>| ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?><root foo="a&lt;b&amp;c&quot;d"/>' ).

  ENDMETHOD.

  METHOD parse_decimal_reference.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><item>a&#10;b</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = |a{ cl_abap_char_utilities=>newline }b| ).

  ENDMETHOD.

  METHOD parse_hex_reference.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><item>&#x41;&#66;</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `AB` ).

  ENDMETHOD.

  METHOD parse_escaped_reference.

    DATA li_root TYPE REF TO if_ixml_element.

    " a value that literally contains "&#10;" is written as "&amp;#10;" and
    " must not be resolved a second time
    li_root = parse( |<root><item>a&amp;#10;b</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `a&#10;b` ).

  ENDMETHOD.

  METHOD parse_not_a_reference.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><item>&#zz; &#; a&#1</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `&#zz; &#; a&#1` ).

  ENDMETHOD.

  METHOD parse_reference_attribute.

    DATA li_root TYPE REF TO if_ixml_element.
    DATA li_item TYPE REF TO if_ixml_node.

    " an attribute value goes through unescape_value since #1228, so a
    " reference in one resolves as well
    li_root = parse( |<root><item foo="a&#10;b"/></root>| )->get_root_element( ).
    li_item = li_root->get_first_child( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_item->get_attributes( )->get_named_item( `foo` )->get_value( )
      exp = |a{ cl_abap_char_utilities=>newline }b| ).

  ENDMETHOD.

  METHOD parse_cdata.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><item><![CDATA[a<b&c]]></item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `a<b&c` ).

  ENDMETHOD.

  METHOD parse_cdata_not_unescaped.

    DATA li_root TYPE REF TO if_ixml_element.

    " inside a section an entity is text, it is not resolved
    li_root = parse( |<root><item><![CDATA[a&lt;b]]></item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `a&lt;b` ).

  ENDMETHOD.

  METHOD parse_cdata_newline.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><item><![CDATA[a\nb]]></item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = |a{ cl_abap_char_utilities=>newline }b| ).

  ENDMETHOD.

  METHOD parse_cdata_empty.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><item><![CDATA[]]></item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `` ).

  ENDMETHOD.

  METHOD parse_comment.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><!-- c --><item>A</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_name( )
      exp = `item` ).

  ENDMETHOD.

  METHOD parse_comment_before_root.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<?xml version="1.0"?><!-- c --><root><item>A</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_name( )
      exp = `root` ).

  ENDMETHOD.

  METHOD parse_comment_with_markup.

    DATA li_root TYPE REF TO if_ixml_element.

    " what stands inside a comment is text, the tags in it are not read
    li_root = parse( |<root><!-- <item>A</item> --><item>B</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `B` ).

  ENDMETHOD.

  METHOD parse_comment_only_child.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><!-- c --></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_children( )->get_length( )
      exp = 0 ).

  ENDMETHOD.

  METHOD attribute.

    DATA li_root TYPE REF TO if_ixml_element.
    DATA li_item TYPE REF TO if_ixml_node.

    li_root = parse( iv_xml )->get_root_element( ).
    li_item = li_root->get_first_child( ).
    rv_value = li_item->get_attributes( )->get_named_item( iv_name )->get_value( ).

  ENDMETHOD.

  METHOD parse_attribute_on_new_line.

    " a start tag may be broken over lines, every pretty printer does it
    cl_abap_unit_assert=>assert_equals(
      act = attribute( iv_xml  = |<root><item\n  foo="bar">A</item></root>|
                       iv_name = `foo` )
      exp = `bar` ).

  ENDMETHOD.

  METHOD parse_attributes_two_spaces.

    cl_abap_unit_assert=>assert_equals(
      act = attribute( iv_xml  = |<root><item  foo="1"  bar="2">A</item></root>|
                       iv_name = `bar` )
      exp = `2` ).

  ENDMETHOD.

  METHOD parse_attribute_single_quote.

    cl_abap_unit_assert=>assert_equals(
      act = attribute( iv_xml  = |<root><item foo='bar'>A</item></root>|
                       iv_name = `foo` )
      exp = `bar` ).

  ENDMETHOD.

  METHOD parse_attribute_name_dash.

    cl_abap_unit_assert=>assert_equals(
      act = attribute( iv_xml  = |<root><item xml-lang="en">A</item></root>|
                       iv_name = `xml-lang` )
      exp = `en` ).

  ENDMETHOD.

  METHOD parse_element_name_dash.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><my-item>A</my-item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_name( )
      exp = `my-item` ).

  ENDMETHOD.

  METHOD parse_doctype.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<!DOCTYPE note SYSTEM "note.dtd"><root><item>A</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `A` ).

  ENDMETHOD.

  METHOD parse_doctype_subset.

    DATA li_root TYPE REF TO if_ixml_element.

    " the ">" of the internal subset does not end the declaration
    li_root = parse( |<!DOCTYPE note [<!ELEMENT note (#PCDATA)>]><root><item>A</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `A` ).

  ENDMETHOD.

  METHOD parse_processing_instruction.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<?xml-stylesheet type="text/xsl" href="a.xsl"?><root><item>A</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `A` ).

  ENDMETHOD.

  METHOD parse_instruction_in_element.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><?target data?><item>A</item></root>| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_name( )
      exp = `item` ).

  ENDMETHOD.

  METHOD parse_text_without_markup.

    DATA li_doc TYPE REF TO if_ixml_document.

    " a document that is character data only - the loop must end
    li_doc = parse( `hello` ).

    cl_abap_unit_assert=>assert_equals(
      act = li_doc->get_root( )->get_first_child( )->get_value( )
      exp = `hello` ).

  ENDMETHOD.

  METHOD parse_text_after_root.

    DATA li_root TYPE REF TO if_ixml_element.

    li_root = parse( |<root><item>A</item></root>tail| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_name( )
      exp = `root` ).

  ENDMETHOD.

  METHOD parse_unclosed_tag.

    DATA li_root TYPE REF TO if_ixml_element.

    " the document is cut off, what was read stays readable
    li_root = parse( |<root><item>A| )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_first_child( )->get_value( )
      exp = `A` ).

  ENDMETHOD.

  METHOD element_get_attributes.

    DATA li_item TYPE REF TO if_ixml_element.

    li_item = parse( |<root><item foo="1" bar="2">A</item></root>| )->find_from_name( `item` ).

    cl_abap_unit_assert=>assert_equals(
      act = li_item->get_attributes( )->get_length( )
      exp = 2 ).

  ENDMETHOD.

  METHOD element_remove_attribute.

    DATA li_item TYPE REF TO if_ixml_element.

    li_item = parse( |<root><item foo="1" bar="2">A</item></root>| )->find_from_name( `item` ).

    li_item->remove_attribute( `foo` ).

    cl_abap_unit_assert=>assert_equals(
      act = li_item->get_attributes( )->get_length( )
      exp = 1 ).

    cl_abap_unit_assert=>assert_initial( act = li_item->get_attribute( `foo` ) ).

    cl_abap_unit_assert=>assert_equals(
      act = li_item->get_attribute( `bar` )
      exp = `2` ).

  ENDMETHOD.

  METHOD remove_attribute_unknown.

    DATA li_item TYPE REF TO if_ixml_element.

    " a name the element does not carry leaves the map as it is
    li_item = parse( |<root><item foo="1">A</item></root>| )->find_from_name( `item` ).

    li_item->remove_attribute( `nope` ).

    cl_abap_unit_assert=>assert_equals(
      act = li_item->get_attributes( )->get_length( )
      exp = 1 ).

  ENDMETHOD.

  METHOD attribute_map_get_item.

    DATA li_item TYPE REF TO if_ixml_element.

    li_item = parse( |<root><item foo="1" bar="2">A</item></root>| )->find_from_name( `item` ).

    cl_abap_unit_assert=>assert_equals(
      act = li_item->get_attributes( )->get_item( 2 )->get_name( )
      exp = `bar` ).

  ENDMETHOD.

  METHOD parse_bom.

    DATA lv_bom  TYPE c LENGTH 1.
    DATA lv_xml  TYPE string.
    DATA li_root TYPE REF TO if_ixml_element.

    " U+FEFF byte order mark, found at the start of many real-world files
    lv_bom = cl_abap_conv_in_ce=>uccpi( 65279 ).
    CONCATENATE lv_bom `<?xml version="1.0"?><root><item>A</item></root>` INTO lv_xml.

    li_root = parse( lv_xml )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_name( )
      exp = `root` ).

  ENDMETHOD.

  METHOD parse_basic.

    DATA lv_xml      TYPE string.
    DATA lv_dump     TYPE string.
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

    lv_dump = dump_nodes( parse( lv_xml )->if_ixml_node~get_children( ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_dump
      exp = lv_expected ).

  ENDMETHOD.

  METHOD parse_empty.

    DATA lv_xml      TYPE string.
    DATA lv_dump     TYPE string.
    DATA lv_expected TYPE string.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<abapGit version="v1.0.0">\n| &&
      | <foo></foo>\n| &&
      |</abapGit>|.

    lv_expected =
      |NAME:abapGit,DEPTH:1,VALUE:\n| &&
      |NAME:foo,DEPTH:0,VALUE:,LEAF:X\n|.

    lv_dump = dump_nodes( parse( lv_xml )->if_ixml_node~get_children( ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_dump
      exp = lv_expected ).

  ENDMETHOD.

  METHOD parse_namespace.

    DATA lv_xml      TYPE string.
    DATA lv_dump     TYPE string.
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

    lv_dump = dump_nodes( parse( lv_xml )->if_ixml_node~get_children( ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_dump
      exp = lv_expected ).

  ENDMETHOD.

  METHOD moving_nodes.

    DATA lv_xml   TYPE string.
    DATA li_git   TYPE REF TO if_ixml_node.
    DATA li_sub   TYPE REF TO if_ixml_node.
    DATA li_doc   TYPE REF TO if_ixml_document.
    DATA li_found TYPE REF TO if_ixml_element.
    DATA lv_dump  TYPE string.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?><abapGit><sub></sub></abapGit>|.

    li_doc = parse( lv_xml ).
    lv_dump = dump_nodes( li_doc->if_ixml_node~get_children( ) ).

    li_git ?= li_doc->find_from_name_ns( depth = 0
                                         name  = 'abapGit' ).
    li_sub = li_git->get_first_child( ).
    cl_abap_unit_assert=>assert_not_initial( li_sub ).

    li_doc->get_root( )->remove_child( li_git ).
    li_doc->get_root( )->append_child( li_sub ).

    lv_dump = dump_nodes( li_doc->if_ixml_node~get_children( ) ).

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

    li_node ?= li_doc->find_from_name_ns( depth = 0
                                          name  = 'abapGit' ).
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

    li_element ?= li_doc->find_from_name_ns( depth = 0
                                             name  = 'abapGit' ).
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

    li_element ?= li_doc->find_from_name_ns( depth = 0
                                             name  = 'abapGit' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

* not found, should return blank
    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_attribute_ns( 'sdfsdfsd' )
      exp = || ).

  ENDMETHOD.

  METHOD parse_attributes4.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_version TYPE REF TO if_ixml_node.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><DATA href="#o1"/>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns( depth = 0
                                             name  = 'DATA' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

* not found, should return blank
    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_attribute_ns( 'href' )
      exp = |#o1| ).

  ENDMETHOD.

  METHOD parse_unescape.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><moo>&amp;&lt;&gt;&quot;&apos;</moo>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns( depth = 0
                                             name  = 'moo' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

    li_element ?= mi_document->find_from_name_ns( depth = 0
                                                  name  = 'moo' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_value( )
      exp = |&<>"'| ).

  ENDMETHOD.

  METHOD parse_value_spaces_kept.

    DATA lv_xml  TYPE string.
    DATA li_root TYPE REF TO if_ixml_element.

    " spaces inside a value are data, also leading ones
    lv_xml = |<t xml:space="preserve"> A  B</t>|.

    li_root = parse( lv_xml )->get_root_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_value( )
      exp = | A  B| ).

  ENDMETHOD.

  METHOD parse_value_whitespace.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><moo> A </moo>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns( depth = 0
                                             name  = 'moo' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

    li_element ?= mi_document->find_from_name_ns( depth = 0
                                                  name  = 'moo' ).

    " todo
    " cl_abap_unit_assert=>assert_equals(
    "   act = li_element->get_value( )
    "   exp = | A | ).

  ENDMETHOD.

  METHOD parse_special.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><BTN_ICON>sap-icon://validate</BTN_ICON>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns(
      depth = 0
      name  = 'BTN_ICON' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_value( )
      exp = |sap-icon://validate| ).

  ENDMETHOD.

  METHOD parse_hash.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><O_APP href="#o1"/>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns(
      depth = 0
      name  = 'O_APP' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

  ENDMETHOD.

  METHOD parse_attr_dash.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><O_APP href="foo-bar"/>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns(
      depth = 0
      name  = 'O_APP' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

  ENDMETHOD.

  METHOD parse_tag_dot.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><foo.bar.moo></foo.bar.moo>|.
    li_doc = parse( lv_xml ).

  ENDMETHOD.

  METHOD parse_href.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><a href="https://www.foo.com" style="color:green; font-weight:600;">link to foo.com</a>|.
    li_doc = parse( lv_xml ).

  ENDMETHOD.

  METHOD parse_percent.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><div height="100%">sdf</div>|.
    li_doc = parse( lv_xml ).

  ENDMETHOD.

  METHOD parse_tag_space.

    DATA lv_xml     TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><Shell ></Shell>|.
    li_doc = parse( lv_xml ).

  ENDMETHOD.

  METHOD parse_attr_any_value.

    DATA lv_xml     TYPE string.
    DATA lv_sheet   TYPE string.
    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_node    TYPE REF TO if_ixml_node.

* all three come from files Excel writes: a folder path in workbook.xml,
* empty typefaces in theme1.xml and a sheet name with non-English letters
    lv_sheet = cl_abap_conv_in_ce=>uccpi( 233 ) && cl_abap_conv_in_ce=>uccpi( 351 )
      && cl_abap_conv_in_ce=>uccpi( 1179 ) && '1'.
    lv_xml = |<wb><absPath url="C:\\Users\\me\\"/><ea typeface=""/><sheet name="{ lv_sheet }"/></wb>|.
    li_doc = parse( lv_xml ).

    li_element = li_doc->find_from_name_ns( name = 'absPath' ).
    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_attribute( 'url' )
      exp = `C:\Users\me\` ).

    li_node = li_doc->find_from_name_ns( name = 'ea' ).
    cl_abap_unit_assert=>assert_equals(
      act = li_node->get_attributes( )->get_length( )
      exp = 1 ).

    li_element = li_doc->find_from_name_ns( name = 'sheet' ).
    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_attribute( 'name' )
      exp = lv_sheet ).

  ENDMETHOD.

  METHOD parse_and_render.

    DATA lv_xml      TYPE string.
    DATA lv_rendered TYPE string.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?><foo>bar</foo>|.

    parse( lv_xml ).

    lv_rendered = render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_rendered
      exp = lv_xml ).

  ENDMETHOD.

  METHOD parse_more.

    DATA lv_xml TYPE string.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?><Page title="sdf (sdf)" showNavButton="true" navButtonPress="onEvent( \{ &apos;EVENT&apos; : &apos;BACK&apos; \} )" id="id_page" ></Page>|.

    parse( lv_xml ).

  ENDMETHOD.

  METHOD parse_close_tag.

    DATA lv_xml      TYPE string.
    DATA lv_name     TYPE string.
    DATA li_doc      TYPE REF TO if_ixml_document.
    DATA li_element  TYPE REF TO if_ixml_element.
    DATA li_child    TYPE REF TO if_ixml_node.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><DATA><FOO1>2</FOO1><FOO2/><FOO3/></DATA>|.
    li_doc = parse( lv_xml ).

    li_element ?= li_doc->find_from_name_ns(
      depth = 0
      name  = 'DATA' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).

    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_children( )->get_length( )
      exp = 3 ).

    li_iterator = li_element->get_children( )->create_iterator( ).
    DO.
      li_child = li_iterator->get_next( ).
      IF li_child IS INITIAL.
        EXIT. " current loop
      ENDIF.
      lv_name = li_child->get_name( ).
      IF lv_name <> 'FOO1' AND lv_name <> 'FOO2' AND lv_name <> 'FOO3'.
        cl_abap_unit_assert=>fail( ).
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD get_first_child.

    DATA lv_xml  TYPE string.
    DATA li_doc  TYPE REF TO if_ixml_document.
    DATA li_node TYPE REF TO if_ixml_node.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><DATA><FOO1>2</FOO1><FOO2/><FOO3/></DATA>|.
    li_doc = parse( lv_xml ).
    li_node = li_doc->get_first_child( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_node->get_name( )
      exp = 'DATA' ).

  ENDMETHOD.

  METHOD create_ostream_xstring.
    DATA li_ostream  TYPE REF TO if_ixml_ostream.
    DATA li_renderer TYPE REF TO if_ixml_renderer.
    DATA lv_xml      TYPE string.
    DATA lv_xstr     TYPE xstring.
    DATA li_doc      TYPE REF TO if_ixml_document.


    lv_xml = |<?xml version="1.0" encoding="utf-16"?><DATA><FOO1>2</FOO1></DATA>|.
    li_doc = parse( lv_xml ).

    li_ostream = mi_ixml->create_stream_factory( )->create_ostream_xstring( lv_xstr ).
    li_renderer = mi_ixml->create_renderer(
      ostream  = li_ostream
      document = li_doc ).
    li_renderer->render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xstr
      exp = '3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574662D38223F3E3C444154413E3C464F4F313E323C2F464F4F313E3C2F444154413E' ).
  ENDMETHOD.

  METHOD fix_children.

    DATA lo_document      TYPE REF TO if_ixml_document.
    DATA lo_element       TYPE REF TO if_ixml_element.
    DATA lo_encoding      TYPE REF TO if_ixml_encoding.
    DATA lo_ixml          TYPE REF TO if_ixml.
    DATA lo_ostream       TYPE REF TO if_ixml_ostream.
    DATA lo_renderer      TYPE REF TO if_ixml_renderer.
    DATA lo_root          TYPE REF TO if_ixml_element.
    DATA lo_streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA lv_string        TYPE string.

    lo_ixml = cl_ixml=>create( ).

    lo_encoding = lo_ixml->create_encoding(
      byte_order    = if_ixml_encoding=>co_platform_endian
      character_set = 'utf-8' ).
    lo_document = lo_ixml->create_document( ).
    lo_document->set_encoding( lo_encoding ).
    lo_document->set_standalone( abap_true ).

    lo_root = lo_document->create_simple_element(
      name   = 'TopName'
      parent = lo_document ).
    lo_root->set_attribute_ns(
      name  = 'xmlns'
      value = 'Namespace' ).

    lo_element = lo_document->create_simple_element(
      name   = 'Hello'
      parent = lo_document ).
    lo_element->set_attribute_ns(
      name  = 'Namespace'
      value = 'World' ).
    lo_root->append_child( lo_element ).

    lo_streamfactory = lo_ixml->create_stream_factory( ).
    lo_ostream = lo_streamfactory->create_ostream_cstring( lv_string ).
    lo_renderer = lo_ixml->create_renderer(
      ostream  = lo_ostream
      document = lo_document ).
    lo_renderer->render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_string
      exp = '*<TopName xmlns="Namespace"><Hello Namespace="World"/></TopName>' ).

  ENDMETHOD.

  METHOD empty_root_element.

    DATA lo_document TYPE REF TO if_ixml_document.
    DATA lo_element  TYPE REF TO if_ixml_element.
    DATA lo_node     TYPE REF TO if_ixml_node.
    DATA lo_ixml     TYPE REF TO if_ixml.

    lo_ixml = cl_ixml=>create( ).

    lo_document = lo_ixml->create_document( ).

    lo_node ?= lo_document->get_root( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_node->get_name( )
      exp = '#document' ).

    lo_element ?= lo_document->get_root_element( ).
    cl_abap_unit_assert=>assert_initial( lo_element ).

  ENDMETHOD.

  METHOD another_children.
    DATA lo_document      TYPE REF TO if_ixml_document.
    DATA lo_element       TYPE REF TO if_ixml_element.
    DATA lo_encoding      TYPE REF TO if_ixml_encoding.
    DATA lo_ixml          TYPE REF TO if_ixml.
    DATA lo_ostream       TYPE REF TO if_ixml_ostream.
    DATA lo_renderer      TYPE REF TO if_ixml_renderer.
    DATA lo_root          TYPE REF TO if_ixml_element.
    DATA lo_streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA lo_top           TYPE REF TO if_ixml_element.
    DATA lv_string        TYPE string.

    lo_ixml = cl_ixml=>create( ).

    lo_encoding = lo_ixml->create_encoding(
      byte_order    = if_ixml_encoding=>co_platform_endian
      character_set = 'utf-8' ).
    lo_document = lo_ixml->create_document( ).
    lo_document->set_encoding( lo_encoding ).
    lo_document->set_standalone( abap_true ).

    lo_root = lo_document->create_simple_element(
      name   = 'TopName'
      parent = lo_document ).
    lo_root->set_attribute_ns(
      name  = 'xmlns'
      value = 'Namespace' ).

    lo_top ?= lo_document->get_root_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_top->get_name( )
      exp = 'TopName' ).

    lo_document->create_simple_element_ns(
      name   = 'ThemeElements'
      parent = lo_top ).

    lo_streamfactory = lo_ixml->create_stream_factory( ).
    lo_ostream = lo_streamfactory->create_ostream_cstring( lv_string ).
    lo_renderer = lo_ixml->create_renderer(
      ostream  = lo_ostream
      document = lo_document ).
    lo_renderer->render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_string
      exp = '*<TopName xmlns="Namespace"><ThemeElements/></TopName>' ).
  ENDMETHOD.

  METHOD render_standalone.

    DATA lo_document      TYPE REF TO if_ixml_document.
    DATA lo_ixml          TYPE REF TO if_ixml.
    DATA lo_ostream       TYPE REF TO if_ixml_ostream.
    DATA lo_renderer      TYPE REF TO if_ixml_renderer.
    DATA lo_streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA lv_string        TYPE string.

    lo_ixml = cl_ixml=>create( ).

    lo_document = lo_ixml->create_document( ).
    lo_document->set_standalone( abap_true ).

    lo_streamfactory = lo_ixml->create_stream_factory( ).
    lo_ostream = lo_streamfactory->create_ostream_cstring( lv_string ).
    lo_renderer = lo_ixml->create_renderer(
      ostream  = lo_ostream
      document = lo_document ).
    lo_renderer->render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_string
      exp = '* standalone="yes"*' ).

  ENDMETHOD.

  METHOD render_namespaced_attr.

    DATA lo_document      TYPE REF TO if_ixml_document.
    DATA lo_ixml          TYPE REF TO if_ixml.
    DATA lo_ostream       TYPE REF TO if_ixml_ostream.
    DATA lo_renderer      TYPE REF TO if_ixml_renderer.
    DATA lo_streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA lo_root          TYPE REF TO if_ixml_element.
    DATA lv_string        TYPE string.

    lo_ixml = cl_ixml=>create( ).

    lo_document = lo_ixml->create_document( ).
    lo_document->set_standalone( abap_true ).

    lo_root = lo_document->create_simple_element(
      name   = 'TopName'
      parent = lo_document ).
    lo_root->set_attribute_ns(
      name   = 'name'
      prefix = 'prefix'
      value  = 'Namespace' ).

    lo_streamfactory = lo_ixml->create_stream_factory( ).
    lo_ostream = lo_streamfactory->create_ostream_cstring( lv_string ).
    lo_renderer = lo_ixml->create_renderer(
      ostream  = lo_ostream
      document = lo_document ).
    lo_renderer->render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_string
      exp = '*prefix:name="Namespace"*' ).

  ENDMETHOD.

  METHOD pretty_print.

    DATA: li_stream_factory TYPE REF TO if_ixml_stream_factory,
          lv_xstring        TYPE xstring,
          li_encoding       TYPE REF TO if_ixml_encoding,
          li_ostream        TYPE REF TO if_ixml_ostream,
          li_renderer       TYPE REF TO if_ixml_renderer.

    li_stream_factory = mi_ixml->create_stream_factory( ).
    li_ostream  = li_stream_factory->create_ostream_xstring( lv_xstring ).
    li_encoding = mi_ixml->create_encoding(
      character_set = 'utf-8'
      byte_order    = if_ixml_encoding=>co_big_endian ).
    mi_document->set_encoding( li_encoding ).
    li_renderer = mi_ixml->create_renderer(
      ostream  = li_ostream
      document = mi_document ).
    li_renderer->set_normalizing( abap_true ).
    li_renderer->render( ).

    rv_xml = cl_abap_codepage=>convert_from( lv_xstring ).

  ENDMETHOD.

  METHOD pretty1.

    DATA: lv_xstring  TYPE xstring,
          lv_actual   TYPE string,
          lv_expected TYPE string.

    parse( |<foo><bar>2</bar></foo>| ).

    lv_actual = pretty_print( ).
    lv_expected = |<?xml version="1.0" encoding="utf-8"?>\n<foo>\n <bar>2</bar>\n</foo>\n|.

    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).

  ENDMETHOD.

  METHOD pretty2.

    DATA: lv_xstring  TYPE xstring,
          lv_actual   TYPE string,
          lv_expected TYPE string.


    parse( |<foo><bar>2</bar><moo><bar>2</bar></moo></foo>| ).

    lv_actual = pretty_print( ).
    lv_expected = |<?xml version="1.0" encoding="utf-8"?>\n<foo>\n <bar>2</bar>\n <moo>\n  <bar>2</bar>\n </moo>\n</foo>\n|.

    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).

  ENDMETHOD.

  METHOD pretty3.

    DATA: lv_xstring  TYPE xstring,
          lv_actual   TYPE string,
          lv_expected TYPE string.


    parse( |<foo><bar></bar></foo>| ).

    lv_actual = pretty_print( ).
    lv_expected = |<?xml version="1.0" encoding="utf-8"?>\n<foo>\n <bar/>\n</foo>\n|.

    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).

  ENDMETHOD.

  METHOD pretty4.

    DATA: lv_xstring  TYPE xstring,
          lv_actual   TYPE string,
          lv_expected TYPE string.


    parse( |<foo><bar></bar><moo></moo></foo>| ).

    lv_actual = pretty_print( ).
    lv_expected = |<?xml version="1.0" encoding="utf-8"?>\n<foo>\n <bar/>\n <moo/>\n</foo>\n|.

    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).

  ENDMETHOD.

  METHOD pretty5.

    DATA: lv_xstring  TYPE xstring,
          lv_actual   TYPE string,
          lv_expected TYPE string.


    parse( |<top><foo><bar></bar><moo></moo></foo></top>| ).

    lv_actual = pretty_print( ).
    lv_expected = |<?xml version="1.0" encoding="utf-8"?>\n<top>\n <foo>\n  <bar/>\n  <moo/>\n </foo>\n</top>\n|.

    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).

  ENDMETHOD.

  METHOD add_stuff.

    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_top     TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.

    li_top = mi_document->create_element_ns(
      prefix = 'asx'
      name   = 'abap' ).
    mi_document->append_child( li_top ).

    li_element = mi_document->create_element( 'HELLO' ).
    li_top->append_child( li_element ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*<asx:abap><HELLO*' ).

  ENDMETHOD.

  METHOD create_attribute_ns.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_top     TYPE REF TO if_ixml_element.
    DATA lv_xml     TYPE string.
    DATA li_attr    TYPE REF TO if_ixml_attribute.

    li_top = mi_document->create_element_ns(
      prefix = 'asx'
      name   = 'abap' ).
    mi_document->append_child( li_top ).

    li_element = mi_document->create_element( 'HELLO' ).

    li_attr = mi_document->create_attribute_ns( 'version' ).
    li_attr->if_ixml_node~set_value( '1.0' ).
    li_element->set_attribute_node_ns( li_attr ).

    li_attr = mi_document->create_attribute_ns(
      name   = 'asx'
      prefix = 'xmlns' ).
    li_attr->if_ixml_node~set_value( 'http://abapgit.org' ).
    li_element->set_attribute_node_ns( li_attr ).

    li_top->append_child( li_element ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*<HELLO version="1.0" xmlns:asx="http://abapgit.org"/>*' ).
  ENDMETHOD.

  METHOD create_text.
    DATA li_root TYPE REF TO if_ixml_element.
    DATA li_text TYPE REF TO if_ixml_text.
    DATA lv_xml  TYPE string.

    li_root = mi_document->create_simple_element(
      name   = 'root'
      parent = mi_document ).
    li_text = mi_document->create_text( 'hello' ).
    li_root->append_child( li_text ).

    lv_xml = render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*<root>hello</root>' ).
  ENDMETHOD.

  METHOD spaces.

    " Reproduces: when a leaf element's value is set via set_value(),
    " pretty-printing injects indentation spaces BEFORE the closing tag
    " because has_direct_text() returns false for values stored in mv_value
    " (no #text child node is created).
    " Expected: <FOO>hello</FOO>
    " Actual:   <FOO>hello    </FOO>   <- indent spaces before closing tag

    DATA li_ixml     TYPE REF TO if_ixml.
    DATA li_doc      TYPE REF TO if_ixml_document.
    DATA li_elem     TYPE REF TO if_ixml_element.
    DATA li_renderer TYPE REF TO if_ixml_renderer.
    DATA li_ostream  TYPE REF TO if_ixml_ostream.
    DATA li_factory  TYPE REF TO if_ixml_stream_factory.
    DATA lv_xml      TYPE string.

    li_ixml     = cl_ixml=>create( ).
    li_doc      = li_ixml->create_document( ).
    li_factory  = li_ixml->create_stream_factory( ).
    li_ostream  = li_factory->create_ostream_cstring( string = lv_xml ).
    li_renderer = li_ixml->create_renderer(
      ostream  = li_ostream
      document = li_doc ).
    li_renderer->set_normalizing( abap_true ).

    li_elem = li_doc->create_element( 'FOO' ).
    li_elem->set_value( 'hello' ).
    li_doc->append_child( li_elem ).

    li_renderer->render( ).

    " Value must appear without indentation spaces before closing tag
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*<FOO>hello</FOO>*'
      msg = 'Leaf element value must not have indent spaces before closing tag' ).

  ENDMETHOD.

  METHOD spaces_inner.

    " Reproduces: pretty-printing injects indent spaces before the closing tag
    " of a leaf element whose value was set via set_value() (not via a #text
    " child node). has_direct_text() returns false in this case, so the
    " renderer writes repeat(' ', indent) before </INNER>.
    "
    " At indent level 1 (INNER is inside OUTER), 1 space is injected:
    "   actual:   <INNER>hello </INNER>
    "   expected: <INNER>hello</INNER>

    DATA li_ixml     TYPE REF TO if_ixml.
    DATA li_doc      TYPE REF TO if_ixml_document.
    DATA li_root     TYPE REF TO if_ixml_node.
    DATA li_outer    TYPE REF TO if_ixml_element.
    DATA li_inner    TYPE REF TO if_ixml_element.
    DATA li_factory  TYPE REF TO if_ixml_stream_factory.
    DATA li_ostream  TYPE REF TO if_ixml_ostream.
    DATA li_renderer TYPE REF TO if_ixml_renderer.
    DATA lv_xml      TYPE string.

    li_ixml   = cl_ixml=>create( ).
    li_doc    = li_ixml->create_document( ).

    " Build: <OUTER><INNER>hello</INNER></OUTER>
    li_outer = li_doc->create_element( 'OUTER' ).
    li_inner = li_doc->create_element( 'INNER' ).
    li_inner->set_value( 'hello' ).          " value in #mv_value, no #text child
    li_outer->append_child( li_inner ).

    li_root = li_doc->get_root( ).
    li_root->append_child( li_outer ).       " OUTER is at indent=0, INNER at indent=1

    li_factory  = li_ixml->create_stream_factory( ).
    li_ostream  = li_factory->create_ostream_cstring( string = lv_xml ).
    li_renderer = li_ixml->create_renderer(
      ostream  = li_ostream
      document = li_doc ).
    li_renderer->set_normalizing( abap_true ).  " enables pretty_print
    li_renderer->render( ).

    " Fails because actual is: <INNER>hello </INNER>  (1 spurious space)
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*<INNER>hello</INNER>*'
      msg = 'set_value() leaf must not get indent spaces before closing tag' ).

  ENDMETHOD.

  METHOD top_attr.

    DATA li_ixml      TYPE REF TO if_ixml.
    DATA li_doc       TYPE REF TO if_ixml_document.
    DATA li_root      TYPE REF TO if_ixml_element.
    DATA li_abap      TYPE REF TO if_ixml_element.
    DATA li_renderer  TYPE REF TO if_ixml_renderer.
    DATA li_sf        TYPE REF TO if_ixml_stream_factory.
    DATA li_ostream   TYPE REF TO if_ixml_ostream.
    DATA lv_xxml      TYPE xstring.
    DATA lv_xml       TYPE string.

    li_ixml = cl_ixml=>create( ).
    li_doc  = li_ixml->create_document( ).

    li_root = li_doc->create_element( 'abapGit' ).
    li_root->set_attribute( name  = 'version'
                            value = 'v1.0.0' ).
    li_root->set_attribute( name  = 'serializer'
                            value = 'LCL_OBJECT_DOMA' ).
    li_root->set_attribute( name  = 'serializer_version'
                            value = 'v1.0.0' ).

    li_abap = li_doc->create_element_ns( name   = 'abap'
                                         prefix = 'asx' ).
    li_abap->set_attribute_ns( name  = 'version'
                               value = '1.0' ).
    li_abap->set_attribute_ns( name  = 'xmlns:asx'
                               value = 'http://www.sap.com/abapxml' ).

    li_root->append_child( li_abap ).
    li_doc->append_child( li_root ).

    li_sf      = li_ixml->create_stream_factory( ).
    li_ostream = li_sf->create_ostream_xstring( lv_xxml ).
    li_renderer = li_ixml->create_renderer( document = li_doc
                                            ostream  = li_ostream ).
    li_renderer->render( ).

    lv_xml = cl_abap_conv_codepage=>create_in( )->convert( lv_xxml ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*<abapGit version="v1.0.0" serializer="LCL_OBJECT_DOMA" serializer_version="v1.0.0"*' ).

  ENDMETHOD.

  METHOD unqualified_attr.

    DATA li_ixml TYPE REF TO if_ixml.
    DATA li_doc TYPE REF TO if_ixml_document.
    DATA li_sf TYPE REF TO if_ixml_stream_factory.
    DATA li_is TYPE REF TO if_ixml_istream.
    DATA li_parser TYPE REF TO if_ixml_parser.
    DATA li_root TYPE REF TO if_ixml_element.
    DATA lv_xml TYPE string.

    lv_xml =
      |<?xml version="1.0" encoding="utf-8"?>| &&
      |<abapGit version="v1.0.0" serializer="LCL_OBJECT_DOMA" serializer_version="v1.0.0">| &&
      |<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0"><asx:values/></asx:abap>| &&
      |</abapGit>|.

    li_ixml = cl_ixml=>create( ).
    li_doc = li_ixml->create_document( ).
    li_sf = li_ixml->create_stream_factory( ).
    li_is = li_sf->create_istream_string( lv_xml ).
    li_parser = li_ixml->create_parser(
      stream_factory = li_sf
      istream        = li_is
      document       = li_doc ).
    li_parser->parse( ).

    li_root ?= li_doc->find_from_name_ns(
      depth = 0
      name  = 'abapGit' ).

    " Control: this should work
    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_attribute( 'serializer' )
      exp = 'LCL_OBJECT_DOMA' ).

    " Reproducer: open-abap may fail here
    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_attribute_ns( 'serializer' )
      exp = 'LCL_OBJECT_DOMA' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_root->get_attribute_ns( 'serializer_version' )
      exp = 'v1.0.0' ).

  ENDMETHOD.

  METHOD attrs_test.

    DATA: li_ixml      TYPE REF TO if_ixml,
          li_doc       TYPE REF TO if_ixml_document,
          li_element   TYPE REF TO if_ixml_element,
          li_streamfac TYPE REF TO if_ixml_stream_factory,
          li_ostream   TYPE REF TO if_ixml_ostream,
          li_renderer  TYPE REF TO if_ixml_renderer,
          lv_xml       TYPE string.

    li_ixml = cl_ixml=>create( ).
    li_doc  = li_ixml->create_document( ).

    li_element = li_doc->create_element( 'abapGit' ).
    li_element->set_attribute( name  = 'version'
                               value = 'v1.0.0' ).
    li_element->set_attribute( name  = 'serializer'
                               value = 'LCL_OBJECT_DOMA' ).
    li_element->set_attribute( name  = 'serializer_version'
                               value = 'v1.0.0' ).
    li_doc->append_child( li_element ).

    li_streamfac = li_ixml->create_stream_factory( ).
    li_ostream   = li_streamfac->create_ostream_cstring( lv_xml ).
    li_renderer  = li_ixml->create_renderer(
      ostream  = li_ostream
      document = li_doc ).
    li_renderer->render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*serializer="LCL_OBJECT_DOMA"*' ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*serializer_version="v1.0.0"*' ).

  ENDMETHOD.

  METHOD get_elements_by_tag_name.

    DATA li_doc        TYPE REF TO if_ixml_document.
    DATA li_collection TYPE REF TO if_ixml_node_collection.

    li_doc = parse( |<root><item>1</item><other><item>2</item></other></root>| ).
    li_collection = li_doc->get_elements_by_tag_name( name = 'item' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_length( )
      exp = 2 ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_item( 1 )->get_value( )
      exp = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_item( 2 )->get_value( )
      exp = '2' ).

  ENDMETHOD.

  METHOD get_elements_by_tag_name_elem.

    DATA li_doc        TYPE REF TO if_ixml_document.
    DATA li_root       TYPE REF TO if_ixml_element.
    DATA li_collection TYPE REF TO if_ixml_node_collection.

    li_doc = parse( |<item><item>1</item><other><item>2</item></other></item>| ).
    li_root = li_doc->get_root_element( ).
    li_collection = li_root->get_elements_by_tag_name( name = 'item' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_length( )
      exp = 2 ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_item( 1 )->get_value( )
      exp = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_item( 2 )->get_value( )
      exp = '2' ).

  ENDMETHOD.

  METHOD get_elements_by_tag_name_ns.

    DATA li_doc        TYPE REF TO if_ixml_document.
    DATA li_collection TYPE REF TO if_ixml_node_collection.

    li_doc = parse( |<root><asx:item>1</asx:item><item>2</item><asx:item>3</asx:item></root>| ).
    li_collection = li_doc->get_elements_by_tag_name_ns(
      name = 'item'
      uri  = 'asx' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_length( )
      exp = 2 ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_item( 1 )->get_value( )
      exp = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_item( 2 )->get_value( )
      exp = '3' ).

  ENDMETHOD.

  METHOD get_elements_by_tag_name_empty.

    DATA li_doc        TYPE REF TO if_ixml_document.
    DATA li_collection TYPE REF TO if_ixml_node_collection.

    li_doc = parse( |<root><item>1</item></root>| ).
    li_collection = li_doc->get_elements_by_tag_name( name = 'missing' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_collection->get_length( )
      exp = 0 ).

    cl_abap_unit_assert=>assert_initial( li_collection->get_item( 1 ) ).

  ENDMETHOD.

  METHOD get_next_sibling.

    DATA li_doc  TYPE REF TO if_ixml_document.
    DATA li_root TYPE REF TO if_ixml_node.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA li_next TYPE REF TO if_ixml_node.

    li_doc = parse( |<root><first/><second/><third/></root>| ).
    li_root ?= li_doc->get_root_element( ).
    li_node = li_root->get_first_child( ).
    li_next = li_node->get_next( ).

    cl_abap_unit_assert=>assert_not_initial( li_next ).

    cl_abap_unit_assert=>assert_equals(
      act = li_next->get_name( )
      exp = 'second' ).

    li_next = li_next->get_next( ).

    cl_abap_unit_assert=>assert_not_initial( li_next ).

    cl_abap_unit_assert=>assert_equals(
      act = li_next->get_name( )
      exp = 'third' ).

  ENDMETHOD.

  METHOD get_next_last_sibling.

    DATA li_doc  TYPE REF TO if_ixml_document.
    DATA li_root TYPE REF TO if_ixml_node.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA li_next TYPE REF TO if_ixml_node.

    li_doc = parse( |<root><first/><second/></root>| ).
    li_root ?= li_doc->get_root_element( ).
    li_node = li_root->get_first_child( )->get_next( ).
    li_next = li_node->get_next( ).

    cl_abap_unit_assert=>assert_initial( li_next ).

  ENDMETHOD.

  METHOD get_next_after_move.

    DATA li_doc    TYPE REF TO if_ixml_document.
    DATA li_root   TYPE REF TO if_ixml_element.
    DATA li_first  TYPE REF TO if_ixml_node.
    DATA li_second TYPE REF TO if_ixml_node.
    DATA li_third  TYPE REF TO if_ixml_node.

    li_doc = parse( |<root><first/><second/><third/></root>| ).
    li_root = li_doc->get_root_element( ).
    li_first = li_root->get_first_child( ).
    li_second = li_first->get_next( ).
    li_third = li_second->get_next( ).

    li_root->append_child( li_second ).

    cl_abap_unit_assert=>assert_equals(
      act = li_first->get_next( )->get_name( )
      exp = 'third' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_third->get_next( )->get_name( )
      exp = 'second' ).

    cl_abap_unit_assert=>assert_initial( li_second->get_next( ) ).

  ENDMETHOD.

  METHOD find_from_path.

    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.

    li_doc = parse( |<root><first><sub>hello</sub></first><second/></root>| ).

    li_element = li_doc->find_from_path( '/root/first/sub' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).
    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_value( )
      exp = 'hello' ).

    li_element = li_doc->find_from_path( '/root' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).
    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_name( )
      exp = 'root' ).

  ENDMETHOD.

  METHOD find_from_path_relative.

    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.

    li_doc = parse( |<root><first><sub>hello</sub></first></root>| ).

    li_element = li_doc->find_from_path( 'root/first' ).
    cl_abap_unit_assert=>assert_not_initial( li_element ).
    cl_abap_unit_assert=>assert_equals(
      act = li_element->get_name( )
      exp = 'first' ).

  ENDMETHOD.

  METHOD find_from_path_not_found.

    DATA li_doc     TYPE REF TO if_ixml_document.
    DATA li_element TYPE REF TO if_ixml_element.

    li_doc = parse( |<root><first/></root>| ).

    li_element = li_doc->find_from_path( '/root/second' ).
    cl_abap_unit_assert=>assert_initial( li_element ).

    li_element = li_doc->find_from_path( '/' ).
    cl_abap_unit_assert=>assert_initial( li_element ).

  ENDMETHOD.

  METHOD find_from_name_element.

    DATA li_doc  TYPE REF TO if_ixml_document.
    DATA li_row  TYPE REF TO if_ixml_element.
    DATA li_cell TYPE REF TO if_ixml_element.

    li_doc = parse( |<sheetData><row r="1"><c r="A1"/></row><row r="2"><c r="A2"/></row></sheetData>| ).

    li_row ?= li_doc->find_from_name( 'row' )->get_next( ).
    li_cell = li_row->find_from_name( 'c' ).

* searches below the element, not from the top of the document
    cl_abap_unit_assert=>assert_equals(
      act = li_cell->get_attribute( 'r' )
      exp = 'A2' ).

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_ixml_set_value DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.
  PRIVATE SECTION.
    METHODS get_value_after_set_value FOR TESTING.
    METHODS render_after_set_value FOR TESTING.
    METHODS parse
      RETURNING
        VALUE(ri_doc) TYPE REF TO if_ixml_document.
ENDCLASS.

CLASS ltcl_ixml_set_value IMPLEMENTATION.
  METHOD parse.
    DATA li_ixml    TYPE REF TO if_ixml.
    DATA li_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream TYPE REF TO if_ixml_istream.
    DATA li_parser  TYPE REF TO if_ixml_parser.
    DATA lv_xml     TYPE string.

    lv_xml = '<ROOT><A>old</A></ROOT>'.

    li_ixml = cl_ixml=>create( ).
    ri_doc = li_ixml->create_document( ).
    li_factory = li_ixml->create_stream_factory( ).
    li_istream = li_factory->create_istream_string( lv_xml ).
    li_parser = li_ixml->create_parser(
      stream_factory = li_factory
      istream        = li_istream
      document       = ri_doc ).

    cl_abap_unit_assert=>assert_equals(
      act = li_parser->parse( )
      exp = 0 ).
    li_istream->close( ).
  ENDMETHOD.

  METHOD get_value_after_set_value.
    DATA li_doc      TYPE REF TO if_ixml_document.
    DATA li_nodes    TYPE REF TO if_ixml_node_collection.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node     TYPE REF TO if_ixml_node.

    li_doc = parse( ).
    li_nodes = li_doc->get_elements_by_tag_name_ns( 'A' ).
    li_iterator = li_nodes->create_iterator( ).
    li_node = li_iterator->get_next( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_node->get_value( )
      exp = 'old' ).

    li_node->set_value( 'new' ).

    cl_abap_unit_assert=>assert_equals(
      act = li_node->get_value( )
      exp = 'new' ).
  ENDMETHOD.

  METHOD render_after_set_value.
    DATA li_ixml     TYPE REF TO if_ixml.
    DATA li_factory  TYPE REF TO if_ixml_stream_factory.
    DATA li_ostream  TYPE REF TO if_ixml_ostream.
    DATA li_renderer TYPE REF TO if_ixml_renderer.
    DATA li_doc      TYPE REF TO if_ixml_document.
    DATA li_nodes    TYPE REF TO if_ixml_node_collection.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA lv_rendered TYPE string.

    li_doc = parse( ).
    li_nodes = li_doc->get_elements_by_tag_name_ns( 'A' ).
    li_iterator = li_nodes->create_iterator( ).
    li_node = li_iterator->get_next( ).
    li_node->set_value( 'new' ).

    li_ixml = cl_ixml=>create( ).
    li_factory = li_ixml->create_stream_factory( ).
    li_ostream = li_factory->create_ostream_cstring( lv_rendered ).
    li_renderer = li_ixml->create_renderer(
      ostream  = li_ostream
      document = li_doc ).
    li_renderer->render( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_rendered
      exp = '*<A>new</A>*' ).
  ENDMETHOD.
ENDCLASS.
