CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_ddic_fixed_values FOR TESTING RAISING cx_static_check.
    METHODS get_ddic_field FOR TESTING RAISING cx_static_check.
    METHODS get_ddic_field2 FOR TESTING RAISING cx_static_check.
    METHODS create_data_type_handle FOR TESTING RAISING cx_static_check.
    METHODS basic_output_length FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD basic_output_length.
    DATA flag TYPE abap_bool.
    DATA descr TYPE REF TO cl_abap_elemdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( flag ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->output_length
      exp = 1 ).
  ENDMETHOD.

  METHOD create_data_type_handle.
    DATA lo_element TYPE REF TO cl_abap_elemdescr.
    DATA lo_value_new TYPE REF TO data.
    FIELD-SYMBOLS <fs_value> TYPE simple.

    lo_element = cl_abap_elemdescr=>get_i( ).
    CREATE DATA lo_value_new TYPE HANDLE lo_element.
    ASSIGN lo_value_new->* TO <fs_value>.
    CLEAR <fs_value>.
    <fs_value> = 2.
  ENDMETHOD.

  METHOD get_ddic_fixed_values.

    DATA lo_element TYPE REF TO cl_abap_elemdescr.
    DATA li_values  TYPE cl_abap_elemdescr=>fixvalues.
    lo_element ?= cl_abap_elemdescr=>describe_by_name( 'ABAP_BOOLEAN' ).
    li_values = lo_element->get_ddic_fixed_values( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( li_values )
      exp = 2 ).

  ENDMETHOD.

  METHOD get_ddic_field.
    DATA lo_element TYPE REF TO cl_abap_elemdescr.
    DATA ls_dfies   TYPE dfies.
    lo_element ?= cl_abap_elemdescr=>describe_by_name( 'ABAP_BOOLEAN' ).
    ls_dfies = lo_element->get_ddic_field( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_dfies-inttype
      exp = 'C' ).
  ENDMETHOD.

  METHOD get_ddic_field2.
    DATA lo_addit TYPE REF TO cl_abap_elemdescr.
    DATA ls_dfies TYPE dfies.
    DATA ip_value TYPE d.
    lo_addit ?= cl_abap_typedescr=>describe_by_data( ip_value ).
    lo_addit->get_ddic_field(
      RECEIVING
        p_flddescr   = ls_dfies
      EXCEPTIONS
        not_found    = 1
        no_ddic_type = 2
        OTHERS       = 3 ).
    " cl_abap_unit_assert=>assert_equals(
    "   act = sy-subrc
    "   exp = 2 ).
  ENDMETHOD.

ENDCLASS.