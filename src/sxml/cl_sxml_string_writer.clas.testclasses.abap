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
