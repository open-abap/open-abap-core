CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING RAISING cx_static_check.
    METHODS get_class_name FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test01.

    DATA obj  TYPE REF TO cl_abap_codepage.
    DATA type TYPE REF TO cl_abap_classdescr.
    DATA ref  TYPE REF TO cl_abap_refdescr.

    CREATE OBJECT obj.
    type ?= cl_abap_typedescr=>describe_by_object_ref( obj ).
    ref ?= cl_abap_typedescr=>describe_by_data( obj ).

    cl_abap_unit_assert=>assert_equals(
      act = type->absolute_name
      exp = ref->get_referenced_type( )->absolute_name ).

  ENDMETHOD.

  METHOD get_class_name.

    DATA obj  TYPE REF TO cl_abap_codepage.
    DATA type TYPE REF TO cl_abap_classdescr.

    CREATE OBJECT obj.

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_classdescr=>get_class_name( obj )
      exp = '\CLASS=CL_ABAP_CODEPAGE' ).

  ENDMETHOD.

ENDCLASS.