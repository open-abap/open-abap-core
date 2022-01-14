CLASS ltcl_json DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS writer FOR TESTING RAISING cx_static_check.
    METHODS call_transformation FOR TESTING RAISING cx_static_check.

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

  METHOD call_transformation.
    DATA writer TYPE REF TO cl_sxml_string_writer.
    DATA json TYPE string.
    DATA: BEGIN OF source,
            foo TYPE i,
          END OF source.

    writer = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    
* todo    CALL TRANSFORMATION id SOURCE data = source RESULT XML writer.
* todo    json = cl_abap_conv_codepage=>create_in( )->convert( writer->get_output( ) ).

* todo    cl_abap_unit_assert=>assert_equals(
* todo      act = json
* todo      exp = '{"DATA":{"FOO":0}}' ).
  ENDMETHOD.

ENDCLASS.