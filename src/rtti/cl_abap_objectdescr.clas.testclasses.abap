CLASS ltcl_foo DEFINITION FOR TESTING FINAL.
  PUBLIC SECTION.
    DATA zzz TYPE i.
    DATA bar TYPE i.
ENDCLASS.

CLASS ltcl_foo IMPLEMENTATION.
ENDCLASS.

CLASS ltcl_visibility DEFINITION FOR TESTING FINAL.
  PROTECTED SECTION.
    DATA bar TYPE i.
ENDCLASS.

CLASS ltcl_visibility IMPLEMENTATION.
ENDCLASS.

INTERFACE lif_intf.
  DATA field TYPE i.
ENDINTERFACE.

CLASS lcl_impl DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_intf.
ENDCLASS.
CLASS lcl_impl IMPLEMENTATION.
ENDCLASS.

************************************************************************************

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS basic_attributes FOR TESTING RAISING cx_static_check.
    METHODS visibility_protected FOR TESTING RAISING cx_static_check.
    METHODS attr_from_intf FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD basic_attributes.
    DATA lo_foo   TYPE REF TO ltcl_foo.
    DATA lo_obj   TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr  TYPE abap_attrdescr.
    DATA lo_descr TYPE REF TO cl_abap_datadescr.

    CREATE OBJECT lo_foo.
    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_foo ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 2 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_not_initial( ls_attr-type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-name
      exp = 'BAR' ).

    lo_descr = lo_obj->get_attribute_type( ls_attr-name ).
    cl_abap_unit_assert=>assert_bound( lo_descr ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->type_kind
      exp = cl_abap_typedescr=>typekind_int ).
  ENDMETHOD.

  METHOD visibility_protected.
    DATA lo_ref  TYPE REF TO ltcl_visibility.
    DATA lo_obj  TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr TYPE abap_attrdescr.

    CREATE OBJECT lo_ref.
    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_ref ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 1 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-visibility
      exp = cl_abap_objectdescr=>protected ).
  ENDMETHOD.

  METHOD attr_from_intf.

    DATA lo_foo TYPE REF TO lcl_impl.
    DATA lo_obj TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr TYPE abap_attrdescr.

    CREATE OBJECT lo_foo.

    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_foo ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 1 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-name
      exp = 'LIF_INTF~FIELD' ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-visibility
      exp = 'U' ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-is_interface
      exp = abap_true ).

  ENDMETHOD.

ENDCLASS.