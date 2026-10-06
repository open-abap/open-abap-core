CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_data_type_kind FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_data_type_kind.
    DATA foo TYPE string.
    DATA kind TYPE abap_typekind.
    kind = cl_abap_datadescr=>get_data_type_kind( foo ).
    cl_abap_unit_assert=>assert_equals(
      act = kind
      exp = cl_abap_typedescr=>typekind_string ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_applies_to_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_person,
        name TYPE c LENGTH 10,
        age  TYPE i,
      END OF ty_person,
      BEGIN OF ty_other_names,
        label TYPE c LENGTH 10,
        count TYPE i,
      END OF ty_other_names,
      BEGIN OF ty_shorter,
        name TYPE c LENGTH 5,
        age  TYPE i,
      END OF ty_shorter,
      BEGIN OF ty_with_include.
        INCLUDE TYPE ty_person.
    TYPES:
        city TYPE c LENGTH 3,
      END OF ty_with_include,
      BEGIN OF ty_flat,
        name TYPE c LENGTH 10,
        age  TYPE i,
        city TYPE c LENGTH 3,
      END OF ty_flat,
      BEGIN OF ty_nested,
        person TYPE ty_person,
      END OF ty_nested.

    METHODS elementary FOR TESTING RAISING cx_static_check.
    METHODS packed FOR TESTING RAISING cx_static_check.
    METHODS structure_names_do_not_matter FOR TESTING RAISING cx_static_check.
    METHODS structure_component_types FOR TESTING RAISING cx_static_check.
    METHODS structure_include FOR TESTING RAISING cx_static_check.
    METHODS structure_nested FOR TESTING RAISING cx_static_check.
    METHODS table_kind_and_line FOR TESTING RAISING cx_static_check.
    METHODS reference FOR TESTING RAISING cx_static_check.
    METHODS data_ref FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_applies_to_data IMPLEMENTATION.

  METHOD elementary.
    DATA lv_c10    TYPE c LENGTH 10.
    DATA lv_c5     TYPE c LENGTH 5.
    DATA lv_string TYPE string.
    DATA lo_descr  TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( lv_c10 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lv_c10 )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lv_c5 )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lv_string )
      exp = abap_false ).
  ENDMETHOD.

  METHOD packed.
    DATA lv_p2    TYPE p LENGTH 8 DECIMALS 2.
    DATA lv_p3    TYPE p LENGTH 8 DECIMALS 3.
    DATA lo_descr TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( lv_p2 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lv_p2 )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lv_p3 )
      exp = abap_false ).
  ENDMETHOD.

  METHOD structure_names_do_not_matter.
    DATA ls_person TYPE ty_person.
    DATA ls_other  TYPE ty_other_names.
    DATA lo_descr  TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( ls_person ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( ls_person )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( ls_other )
      exp = abap_true ).
  ENDMETHOD.

  METHOD structure_component_types.
    DATA ls_person  TYPE ty_person.
    DATA ls_shorter TYPE ty_shorter.
    DATA lv_c10     TYPE c LENGTH 10.
    DATA lo_descr   TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( ls_person ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( ls_shorter )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lv_c10 )
      exp = abap_false ).
  ENDMETHOD.

  METHOD structure_include.
    DATA ls_flat    TYPE ty_flat.
    DATA ls_person  TYPE ty_person.
    DATA ls_include TYPE ty_with_include.
    DATA lo_descr   TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( ls_include ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( ls_flat )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( ls_person )
      exp = abap_false ).
  ENDMETHOD.

  METHOD structure_nested.
    DATA ls_person TYPE ty_person.
    DATA ls_nested TYPE ty_nested.
    DATA lo_descr  TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( ls_nested ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( ls_nested )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( ls_person )
      exp = abap_false ).
  ENDMETHOD.

  METHOD table_kind_and_line.
    DATA lt_standard TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA lt_same     TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA lt_sorted   TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.
    DATA lt_strings  TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lo_descr    TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( lt_standard ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lt_same )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lt_sorted )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lt_strings )
      exp = abap_false ).
  ENDMETHOD.

  METHOD reference.
    DATA lr_int    TYPE REF TO i.
    DATA lr_int2   TYPE REF TO i.
    DATA lr_string TYPE REF TO string.
    DATA lo_descr  TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( lr_int ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lr_int2 )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data( lr_string )
      exp = abap_false ).
  ENDMETHOD.

  METHOD data_ref.
    DATA lv_int   TYPE i.
    DATA lr_data  TYPE REF TO data.
    DATA lo_descr TYPE REF TO cl_abap_datadescr.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( lv_int ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data_ref( lr_data )
      exp = abap_false ).
    GET REFERENCE OF lv_int INTO lr_data.
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->applies_to_data_ref( lr_data )
      exp = abap_true ).
  ENDMETHOD.

ENDCLASS.
