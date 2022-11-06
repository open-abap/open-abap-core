CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_ddic_fixed_values FOR TESTING RAISING cx_static_check.
    METHODS get_ddic_field FOR TESTING RAISING cx_static_check.
    METHODS get_ddic_field2 FOR TESTING RAISING cx_static_check.
    METHODS output_length_basic FOR TESTING RAISING cx_static_check.
    METHODS output_length_date FOR TESTING RAISING cx_static_check.
    METHODS output_length_time FOR TESTING RAISING cx_static_check.
    METHODS output_length_hex FOR TESTING RAISING cx_static_check.
    METHODS output_length_numc FOR TESTING RAISING cx_static_check.
    METHODS output_length_int FOR TESTING RAISING cx_static_check.
    METHODS sylangu_mask FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD sylangu_mask.
    DATA typedescr TYPE REF TO cl_abap_typedescr.
    DATA elemdescr TYPE REF TO cl_abap_elemdescr.
    DATA langu TYPE sy-langu.
    typedescr = cl_abap_typedescr=>describe_by_data( langu ).
    elemdescr ?= typedescr.
    cl_abap_unit_assert=>assert_equals(
      act = elemdescr->edit_mask
      exp = '==ISOLA' ).
  ENDMETHOD.

  METHOD output_length_basic.
    DATA flag TYPE abap_bool.
    DATA descr TYPE REF TO cl_abap_elemdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( flag ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->output_length
      exp = 1 ).
  ENDMETHOD.

  METHOD output_length_date.
    DATA data TYPE d.
    DATA descr TYPE REF TO cl_abap_elemdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->output_length
      exp = 8 ).
  ENDMETHOD.

  METHOD output_length_time.
    DATA data TYPE t.
    DATA descr TYPE REF TO cl_abap_elemdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->output_length
      exp = 6 ).
  ENDMETHOD.

  METHOD output_length_hex.
    DATA data TYPE x LENGTH 2.
    DATA descr TYPE REF TO cl_abap_elemdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->output_length
      exp = 4 ).
  ENDMETHOD.

  METHOD output_length_numc.
    DATA data TYPE n LENGTH 2.
    DATA descr TYPE REF TO cl_abap_elemdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->output_length
      exp = 2 ).
  ENDMETHOD.

  METHOD output_length_int.
    DATA data TYPE i.
    DATA descr TYPE REF TO cl_abap_elemdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->output_length
      exp = 11 ).
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