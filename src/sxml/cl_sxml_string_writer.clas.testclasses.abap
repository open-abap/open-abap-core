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
    intf->write_attribute( name = 'name' value = 'text' ).
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
    intf->write_attribute( name = 'name' value = 'text' ).
    intf->write_value( 'moo' ).
    intf->close_element( ).
    intf->open_element( name = 'str' ).
    intf->write_attribute( name = 'name' value = 'next' ).
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