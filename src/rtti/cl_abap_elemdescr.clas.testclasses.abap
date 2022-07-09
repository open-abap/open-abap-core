CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_ddic_fixed_values FOR TESTING RAISING cx_static_check.
    METHODS get_ddic_field FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

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

ENDCLASS.