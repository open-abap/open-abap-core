CLASS ltcl_json DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS writer FOR TESTING RAISING cx_static_check.
    METHODS write_empty_array FOR TESTING RAISING cx_static_check.
    METHODS write_array_str FOR TESTING RAISING cx_static_check.
    METHODS write_array_multi FOR TESTING RAISING cx_static_check.
    METHODS write_object_multi FOR TESTING RAISING cx_static_check.

    METHODS call_transformation FOR TESTING RAISING cx_static_check.
    METHODS call_empty_array_via_fs FOR TESTING RAISING cx_static_check.
    METHODS call_nested_array FOR TESTING RAISING cx_static_check.
    METHODS call_string_list FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_json IMPLEMENTATION.

  METHOD writer.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA json TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    intf ?= writer.
    intf->open_element( name = 'object' ).
    intf->open_element( name = 'str' ).
    intf->write_attribute( name  = 'name'
                           value = 'text' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->close_element( ).
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
*    WRITE '@KERNEL console.dir(json);'.
    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '{"text":"moo"}' ).
  ENDMETHOD.

  METHOD write_empty_array.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA json TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    intf ?= writer.
    intf->open_element( name = 'array' ).
    intf->close_element( ).
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '[]' ).
  ENDMETHOD.

  METHOD write_array_str.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA json TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    intf ?= writer.
    intf->open_element( name = 'array' ).
    intf->open_element( name = 'str' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->close_element( ).
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '["moo"]' ).
  ENDMETHOD.

  METHOD write_array_multi.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA json TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    intf ?= writer.
    intf->open_element( name = 'array' ).

    intf->open_element( name = 'str' ).
    intf->write_value( 'foo' ).
    intf->close_element( ).

    intf->open_element( name = 'str' ).
    intf->write_value( 'bar' ).
    intf->close_element( ).

    intf->close_element( ).
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '["foo","bar"]' ).
  ENDMETHOD.

  METHOD write_object_multi.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA json TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    intf ?= writer.
    intf->open_element( name = 'object' ).
    intf->open_element( name = 'str' ).
    intf->write_attribute( name  = 'name'
                           value = 'text' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->open_element( name = 'str' ).
    intf->write_attribute( name  = 'name'
                           value = 'next' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->close_element( ).
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '{"text":"moo","next":"moo"}' ).
  ENDMETHOD.

  METHOD call_transformation.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA json TYPE string.
    DATA: BEGIN OF source,
            foo TYPE i,
          END OF source.

    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id SOURCE data = source RESULT XML writer.
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
*    WRITE '@KERNEL console.dir(json);'.

    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '{"DATA":{"FOO":0}}' ).
  ENDMETHOD.

  METHOD call_empty_array_via_fs.
    DATA json TYPE string.
    DATA foo TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    FIELD-SYMBOLS <fs> TYPE STANDARD TABLE.
    ASSIGN foo TO <fs>.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE data = <fs> RESULT XML writer.
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '{"DATA":[]}' ).
  ENDMETHOD.

  METHOD call_nested_array.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA json TYPE string.
    TYPES: BEGIN OF source,
             foo TYPE i,
           END OF source.
    DATA source TYPE STANDARD TABLE OF source WITH DEFAULT KEY.
    APPEND INITIAL LINE TO source.
    APPEND INITIAL LINE TO source.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE data = source RESULT XML writer.
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
*    WRITE '@KERNEL console.dir(json);'.

    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '{"DATA":[{"FOO":0},{"FOO":0}]}' ).
  ENDMETHOD.

  METHOD call_string_list.
    DATA json TYPE string.
    DATA list TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    APPEND 'foo' TO list.
    APPEND 'bar' TO list.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE list = list RESULT XML writer.
    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = json
      exp = '{"LIST":["foo","bar"]}' ).
  ENDMETHOD.

ENDCLASS.
CLASS ltcl_xml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS writer FOR TESTING RAISING cx_static_check.
    METHODS write_empty_array FOR TESTING RAISING cx_static_check.
    METHODS write_array_str FOR TESTING RAISING cx_static_check.
    METHODS write_array_multi FOR TESTING RAISING cx_static_check.
    METHODS write_object_multi FOR TESTING RAISING cx_static_check.
    METHODS write_escaped FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_xml IMPLEMENTATION.

  METHOD writer.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA xml TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_xml10 ).
    intf ?= writer.
    intf->open_element( name = 'object' ).
    intf->open_element( name = 'str' ).
    intf->write_attribute( name  = 'name'
                           value = 'text' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->close_element( ).
    xml = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = xml
      exp = '<object><str name="text">moo</str></object>' ).
  ENDMETHOD.

  METHOD write_empty_array.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA xml TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_xml10 ).
    intf ?= writer.
    intf->open_element( name = 'array' ).
    intf->close_element( ).
    xml = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = xml
      exp = '<array/>' ).
  ENDMETHOD.

  METHOD write_array_str.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA xml TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_xml10 ).
    intf ?= writer.
    intf->open_element( name = 'array' ).
    intf->open_element( name = 'str' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->close_element( ).
    xml = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = xml
      exp = '<array><str>moo</str></array>' ).
  ENDMETHOD.

  METHOD write_array_multi.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA xml TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_xml10 ).
    intf ?= writer.
    intf->open_element( name = 'array' ).

    intf->open_element( name = 'str' ).
    intf->write_value( 'foo' ).
    intf->close_element( ).

    intf->open_element( name = 'str' ).
    intf->write_value( 'bar' ).
    intf->close_element( ).

    intf->close_element( ).
    xml = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = xml
      exp = '<array><str>foo</str><str>bar</str></array>' ).
  ENDMETHOD.

  METHOD write_object_multi.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA xml TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_xml10 ).
    intf ?= writer.
    intf->open_element( name = 'object' ).
    intf->open_element( name = 'str' ).
    intf->write_attribute( name  = 'name'
                           value = 'text' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->open_element( name = 'str' ).
    intf->write_attribute( name  = 'name'
                           value = 'next' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->close_element( ).
    xml = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = xml
      exp = '<object><str name="text">moo</str><str name="next">moo</str></object>' ).
  ENDMETHOD.

  METHOD write_escaped.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA intf TYPE REF TO if_sxml_writer.
    DATA xml TYPE string.
    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_xml10 ).
    intf ?= writer.
    intf->open_element( name = 'str' ).
    intf->write_attribute( name  = 'name'
                           value = 'a"b' ).
    intf->write_value( 'foo & <bar>' ).
    intf->close_element( ).
    xml = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = xml
      exp = '<str name="a&quot;b">foo &amp; &lt;bar&gt;</str>' ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_xml_format DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    DATA mi_writer TYPE REF TO if_sxml_writer.
    DATA mo_writer TYPE REF TO cl_sxml_string_writer.

    METHODS setup.
    METHODS output RETURNING VALUE(rv_xml) TYPE string.

    METHODS compact FOR TESTING RAISING cx_static_check.
    METHODS linebreaks FOR TESTING RAISING cx_static_check.
    METHODS linebreaks_indent FOR TESTING RAISING cx_static_check.
    METHODS prefix_declared_once FOR TESTING RAISING cx_static_check.
    METHODS default_namespace FOR TESTING RAISING cx_static_check.
    METHODS default_namespace_reset FOR TESTING RAISING cx_static_check.
    METHODS namespace_out_of_scope FOR TESTING RAISING cx_static_check.
    METHODS attribute_namespace FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_xml_format IMPLEMENTATION.

  METHOD setup.
    mo_writer = cl_sxml_string_writer=>create( ).
    mi_writer = mo_writer.
  ENDMETHOD.

  METHOD output.
    rv_xml = cl_abap_conv_codepage=>create_in( )->convert( mo_writer->get_output( ) ).
  ENDMETHOD.

  METHOD compact.
    mi_writer->open_element( 'a' ).
    mi_writer->open_element( 'b' ).
    mi_writer->write_value( '1' ).
    mi_writer->close_element( ).
    mi_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( )
      exp = '<a><b>1</b></a>' ).
  ENDMETHOD.

  METHOD linebreaks.
    mi_writer->set_option( if_sxml_writer=>co_opt_linebreaks ).
    mi_writer->open_element( 'a' ).
    mi_writer->open_element( 'b' ).
    mi_writer->write_value( '1' ).
    mi_writer->close_element( ).
    mi_writer->open_element( 'c' ).
    mi_writer->close_element( ).
    mi_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( )
      exp = |<a>\n<b>1</b>\n<c/>\n</a>| ).
  ENDMETHOD.

  METHOD linebreaks_indent.
    mi_writer->set_option( if_sxml_writer=>co_opt_linebreaks ).
    mi_writer->set_option( if_sxml_writer=>co_opt_indent ).
    mi_writer->open_element( 'a' ).
    mi_writer->open_element( 'b' ).
    mi_writer->open_element( 'c' ).
    mi_writer->write_value( '1' ).
    mi_writer->close_element( ).
    mi_writer->close_element( ).
    mi_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( )
      exp = |<a>\n <b>\n  <c>1</c>\n </b>\n</a>| ).
  ENDMETHOD.

  METHOD prefix_declared_once.
    mi_writer->open_element( name   = 'Envelope'
                             nsuri  = 'urn:soap'
                             prefix = 's' ).
    mi_writer->open_element( name   = 'Body'
                             nsuri  = 'urn:soap'
                             prefix = 's' ).
    mi_writer->close_element( ).
    mi_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( )
      exp = '<s:Envelope xmlns:s="urn:soap"><s:Body/></s:Envelope>' ).
  ENDMETHOD.

  METHOD default_namespace.
    mi_writer->open_element( name   = 'order'
                             nsuri  = 'urn:shop'
                             prefix = if_sxml_named=>co_use_default_xmlns ).
    mi_writer->open_element( name   = 'id'
                             nsuri  = 'urn:shop'
                             prefix = if_sxml_named=>co_use_default_xmlns ).
    mi_writer->write_value( '1' ).
    mi_writer->close_element( ).
    mi_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( )
      exp = '<order xmlns="urn:shop"><id>1</id></order>' ).
  ENDMETHOD.

  METHOD default_namespace_reset.
* an element without namespace inside a default namespace
    mi_writer->open_element( name   = 'order'
                             nsuri  = 'urn:shop'
                             prefix = if_sxml_named=>co_use_default_xmlns ).
    mi_writer->open_element( 'note' ).
    mi_writer->close_element( ).
    mi_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( )
      exp = '<order xmlns="urn:shop"><note xmlns=""/></order>' ).
  ENDMETHOD.

  METHOD namespace_out_of_scope.
* a binding ends with its element, the sibling declares it again
    mi_writer->open_element( 'root' ).
    mi_writer->open_element( name   = 'a'
                             nsuri  = 'urn:x'
                             prefix = 'x' ).
    mi_writer->close_element( ).
    mi_writer->open_element( name   = 'b'
                             nsuri  = 'urn:x'
                             prefix = 'x' ).
    mi_writer->close_element( ).
    mi_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( )
      exp = '<root><x:a xmlns:x="urn:x"/><x:b xmlns:x="urn:x"/></root>' ).
  ENDMETHOD.

  METHOD attribute_namespace.
    mi_writer->open_element( 'a' ).
    mi_writer->write_attribute( name   = 'lang'
                                nsuri  = 'urn:x'
                                prefix = 'x'
                                value  = 'en' ).
    mi_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( )
      exp = '<a xmlns:x="urn:x" x:lang="en"/>' ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_xml_node_api DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS output
      IMPORTING io_writer     TYPE REF TO cl_sxml_string_writer
      RETURNING VALUE(rv_xml) TYPE string.

    METHODS same_as_convenience_api FOR TESTING RAISING cx_static_check.
    METHODS set_attribute_replaces FOR TESTING RAISING cx_static_check.
    METHODS write_value_raw FOR TESTING RAISING cx_static_check.
    METHODS write_attribute_raw FOR TESTING RAISING cx_static_check.
    METHODS value_node_set_value_raw FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_xml_node_api IMPLEMENTATION.

  METHOD output.
    rv_xml = cl_abap_conv_codepage=>create_in( )->convert( io_writer->get_output( ) ).
  ENDMETHOD.

  METHOD same_as_convenience_api.
    DATA lo_nodes TYPE REF TO cl_sxml_string_writer.
    DATA lo_calls TYPE REF TO cl_sxml_string_writer.
    DATA li_nodes TYPE REF TO if_sxml_writer.
    DATA li_calls TYPE REF TO if_sxml_writer.
    DATA li_open  TYPE REF TO if_sxml_open_element.
    DATA li_value TYPE REF TO if_sxml_value_node.

    lo_nodes = cl_sxml_string_writer=>create( ).
    li_nodes = lo_nodes.
    li_nodes->set_option( if_sxml_writer=>co_opt_linebreaks ).
    li_nodes->set_option( if_sxml_writer=>co_opt_indent ).

    li_open = cl_sxml_string_writer=>if_sxml_writer~new_open_element( 'root' ).
    li_open->set_attribute( name  = 'id'
                            value = '1' ).
    li_open->set_attribute( name   = 'lang'
                            nsuri  = 'urn:x'
                            prefix = 'x'
                            value  = 'en' ).
    li_nodes->write_node( li_open ).
    li_value = cl_sxml_string_writer=>if_sxml_writer~new_value( ).
    li_value->set_value( 'a & b' ).
    li_nodes->write_node( li_value ).
    li_open = cl_sxml_string_writer=>if_sxml_writer~new_open_element(
      name   = 'child'
      nsuri  = 'urn:y'
      prefix = 'y' ).
    li_nodes->write_node( li_open ).
    li_value = cl_sxml_string_writer=>if_sxml_writer~new_value( ).
    li_value->set_value( 'text' ).
    li_nodes->write_node( li_value ).
    li_nodes->write_node( cl_sxml_string_writer=>if_sxml_writer~new_close_element( ) ).
    li_nodes->write_node( cl_sxml_string_writer=>if_sxml_writer~new_close_element( ) ).

    lo_calls = cl_sxml_string_writer=>create( ).
    li_calls = lo_calls.
    li_calls->set_option( if_sxml_writer=>co_opt_linebreaks ).
    li_calls->set_option( if_sxml_writer=>co_opt_indent ).
    li_calls->open_element( 'root' ).
    li_calls->write_attribute( name  = 'id'
                               value = '1' ).
    li_calls->write_attribute( name   = 'lang'
                               nsuri  = 'urn:x'
                               prefix = 'x'
                               value  = 'en' ).
    li_calls->write_value( 'a & b' ).
    li_calls->open_element( name   = 'child'
                            nsuri  = 'urn:y'
                            prefix = 'y' ).
    li_calls->write_value( 'text' ).
    li_calls->close_element( ).
    li_calls->close_element( ).

    cl_abap_unit_assert=>assert_equals(
      act = output( lo_nodes )
      exp = output( lo_calls ) ).
    cl_abap_unit_assert=>assert_equals(
      act = output( lo_nodes )
      exp = |<root id="1" xmlns:x="urn:x" x:lang="en">a &amp; b\n <y:child xmlns:y="urn:y">text</y:child>\n</root>| ).
  ENDMETHOD.

  METHOD set_attribute_replaces.
    DATA lo_writer TYPE REF TO cl_sxml_string_writer.
    DATA li_writer TYPE REF TO if_sxml_writer.
    DATA li_open   TYPE REF TO if_sxml_open_element.
    DATA li_value  TYPE REF TO if_sxml_value.

    lo_writer = cl_sxml_string_writer=>create( ).
    li_writer = lo_writer.
    li_open = cl_sxml_string_writer=>if_sxml_writer~new_open_element( 'a' ).
    li_open->set_attribute( name  = 'k'
                            value = 'old' ).
    li_open->set_attribute( name  = 'm'
                            value = '2' ).
    li_open->set_attribute( name  = 'k'
                            value = 'new' ).
    li_value = li_open->get_attribute_value( 'k' ).
    cl_abap_unit_assert=>assert_equals(
      act = li_value->get_value( )
      exp = 'new' ).
    li_writer->write_node( li_open ).
    li_writer->write_node( cl_sxml_string_writer=>if_sxml_writer~new_close_element( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = output( lo_writer )
      exp = '<a k="new" m="2"/>' ).
  ENDMETHOD.

  METHOD write_value_raw.
    DATA lo_writer TYPE REF TO cl_sxml_string_writer.
    DATA li_writer TYPE REF TO if_sxml_writer.
    DATA lv_raw    TYPE xstring.

    lo_writer = cl_sxml_string_writer=>create( ).
    li_writer = lo_writer.
    lv_raw = cl_abap_codepage=>convert_to( 'x < y' ).
    li_writer->open_element( 'a' ).
    li_writer->write_value_raw( lv_raw ).
    li_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( lo_writer )
      exp = '<a>x &lt; y</a>' ).
  ENDMETHOD.

  METHOD write_attribute_raw.
    DATA lo_writer TYPE REF TO cl_sxml_string_writer.
    DATA li_writer TYPE REF TO if_sxml_writer.
    DATA lv_raw    TYPE xstring.

    lo_writer = cl_sxml_string_writer=>create( ).
    li_writer = lo_writer.
    lv_raw = cl_abap_codepage=>convert_to( 'v"1' ).
    li_writer->open_element( 'a' ).
    li_writer->write_attribute_raw( name  = 'k'
                                    value = lv_raw ).
    li_writer->close_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = output( lo_writer )
      exp = '<a k="v&quot;1"/>' ).
  ENDMETHOD.

  METHOD value_node_set_value_raw.
    DATA lo_writer TYPE REF TO cl_sxml_string_writer.
    DATA li_writer TYPE REF TO if_sxml_writer.
    DATA li_value  TYPE REF TO if_sxml_value_node.

    lo_writer = cl_sxml_string_writer=>create( ).
    li_writer = lo_writer.
    li_value = cl_sxml_string_writer=>if_sxml_writer~new_value( ).
    li_value->set_value_raw( cl_abap_codepage=>convert_to( 'raw' ) ).
    cl_abap_unit_assert=>assert_equals(
      act = li_value->get_value( )
      exp = 'raw' ).
    li_writer->write_node( cl_sxml_string_writer=>if_sxml_writer~new_open_element( 'a' ) ).
    li_writer->write_node( li_value ).
    li_writer->write_node( cl_sxml_string_writer=>if_sxml_writer~new_close_element( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = output( lo_writer )
      exp = '<a>raw</a>' ).
  ENDMETHOD.

ENDCLASS.
