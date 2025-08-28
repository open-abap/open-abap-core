CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING RAISING cx_static_check.
    METHODS absolute_name FOR TESTING RAISING cx_static_check.
    METHODS get_ref_to_data FOR TESTING RAISING cx_static_check.
    METHODS string_type FOR TESTING RAISING cx_static_check.
    METHODS generic_object_reference FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_ref_to_data.
    DATA ref TYPE REF TO cl_abap_refdescr.
    ref = cl_abap_refdescr=>get_ref_to_data( ).
    cl_abap_unit_assert=>assert_equals(
      act = ref->type_kind
      exp = cl_abap_typedescr=>typekind_dref ).
  ENDMETHOD.

  METHOD test01.

    DATA lo_type TYPE REF TO cl_abap_refdescr.
    DATA lo_referenced TYPE REF TO cl_abap_typedescr.

    lo_type ?= cl_abap_typedescr=>describe_by_data( me ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_type->type_kind
      exp = cl_abap_typedescr=>typekind_oref ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_type->kind
      exp = cl_abap_typedescr=>kind_ref ).

    lo_referenced = lo_type->get_referenced_type( ).

    cl_abap_unit_assert=>assert_not_initial( lo_referenced ).

  ENDMETHOD.

  METHOD absolute_name.
    DATA foo   TYPE REF TO i.
    DATA descr TYPE REF TO cl_abap_refdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( foo ).

    cl_abap_unit_assert=>assert_equals(
      act = descr->get_referenced_type( )->kind
      exp = cl_abap_typedescr=>kind_elem ).

    cl_abap_unit_assert=>assert_equals(
      act = descr->get_referenced_type( )->absolute_name
      exp = '\TYPE=I' ).
  ENDMETHOD.

  METHOD string_type.
    DATA foo TYPE REF TO string.
    DATA str TYPE string.
    DATA refdescr TYPE REF TO cl_abap_refdescr.
    DATA elemdescr TYPE REF TO cl_abap_elemdescr.

    str = 'Test'.
    GET REFERENCE OF str INTO foo.

    refdescr ?= cl_abap_typedescr=>describe_by_data( foo ).
    cl_abap_unit_assert=>assert_equals(
      act = refdescr->get_referenced_type( )->type_kind
      exp = cl_abap_typedescr=>typekind_string ).
  ENDMETHOD.

  METHOD generic_object_reference.
    DATA ref TYPE REF TO object.
    DATA descr TYPE REF TO cl_abap_refdescr.
    descr ?= cl_abap_typedescr=>describe_by_data( ref ).
    ASSERT descr->type_kind = cl_abap_typedescr=>typekind_oref.
    ASSERT descr->kind = cl_abap_typedescr=>kind_ref.
    ASSERT descr->absolute_name IS NOT INITIAL.
    ASSERT descr->get_relative_name( ) = ''.
  ENDMETHOD.

ENDCLASS.