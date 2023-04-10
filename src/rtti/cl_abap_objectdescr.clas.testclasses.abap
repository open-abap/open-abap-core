CLASS ltcl_foo DEFINITION FOR TESTING FINAL.
  PUBLIC SECTION.
    DATA zzz TYPE i.
    DATA bar TYPE i.
ENDCLASS.

CLASS ltcl_foo IMPLEMENTATION.
ENDCLASS.

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS basic_attributes FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD basic_attributes.
    DATA lo_foo TYPE REF TO ltcl_foo.
    DATA lo_obj TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr TYPE abap_attrdescr.
    DATA lo_descr TYPE REF TO cl_abap_datadescr.

    CREATE OBJECT lo_foo.
    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_foo ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 2 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-name
      exp = 'BAR' ).

    lo_descr = lo_obj->get_attribute_type( ls_attr-name ).
    cl_abap_unit_assert=>assert_bound( lo_descr ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->type_kind
      exp = cl_abap_typedescr=>typekind_int ).
  ENDMETHOD.

ENDCLASS.