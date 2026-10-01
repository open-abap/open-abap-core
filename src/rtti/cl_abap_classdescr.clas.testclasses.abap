CLASS lcl_structdescr DEFINITION.
  PUBLIC SECTION.
    DATA property_instances TYPE STANDARD TABLE OF REF TO lcl_structdescr WITH DEFAULT KEY.
ENDCLASS.
CLASS lcl_structdescr IMPLEMENTATION.
ENDCLASS.

CLASS lcl_intfattr DEFINITION.
  PUBLIC SECTION.
    DATA attr TYPE REF TO if_message.
ENDCLASS.
CLASS lcl_intfattr IMPLEMENTATION.
ENDCLASS.

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS absolute_name FOR TESTING RAISING cx_static_check.
    METHODS get_class_name FOR TESTING RAISING cx_static_check.
    METHODS get_interface_type FOR TESTING RAISING cx_static_check.
    METHODS describe_by_object_ref1 FOR TESTING RAISING cx_static_check.
    METHODS describe_by_object_ref2 FOR TESTING RAISING cx_static_check.
    METHODS describe_by_object_ref3 FOR TESTING RAISING cx_static_check.
    METHODS test_get_super_class_type FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD absolute_name.

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

    CREATE OBJECT obj.

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_classdescr=>get_class_name( obj )
      exp = '\CLASS=CL_ABAP_CODEPAGE' ).

  ENDMETHOD.

  METHOD get_interface_type.

    DATA ref       TYPE REF TO cx_sy_dyn_call_illegal_class.
    DATA objdescr  TYPE REF TO cl_abap_objectdescr.
    DATA intfdescr TYPE REF TO cl_abap_intfdescr.

    CREATE OBJECT ref.
    objdescr ?= cl_abap_objectdescr=>describe_by_object_ref( ref ).
    intfdescr ?= objdescr->get_interface_type( 'IF_MESSAGE' ).

  ENDMETHOD.

  METHOD describe_by_object_ref1.

    DATA ref TYPE REF TO cl_abap_typedescr.

* just check there is no infinite recursion
    ref = cl_abap_typedescr=>describe_by_data( 1 ).
    ref = cl_abap_objectdescr=>describe_by_object_ref( ref ).
* describe the described description
    cl_abap_objectdescr=>describe_by_object_ref( ref ).

  ENDMETHOD.

  METHOD describe_by_object_ref2.

    DATA ref TYPE REF TO lcl_structdescr.

* just check there is no infinite recursion
    CREATE OBJECT ref.
    cl_abap_objectdescr=>describe_by_object_ref( ref ).

  ENDMETHOD.

  METHOD describe_by_object_ref3.

    DATA ref TYPE REF TO lcl_intfattr.

* just check it doesnt crash
    CREATE OBJECT ref.
    cl_abap_objectdescr=>describe_by_object_ref( ref ).

  ENDMETHOD.

  METHOD test_get_super_class_type.

    DATA ref      TYPE REF TO cx_sy_dyn_call_illegal_class.
    DATA obj_root TYPE REF TO cl_abap_codepage.
    DATA type     TYPE REF TO cl_abap_classdescr.
    DATA lo_super TYPE REF TO cl_abap_classdescr.

    CREATE OBJECT ref.
    type ?= cl_abap_typedescr=>describe_by_object_ref( ref ).
    lo_super = type->get_super_class_type( ).
    cl_abap_unit_assert=>assert_bound( lo_super ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_super->get_relative_name( )
      exp = 'CX_SY_DYN_CALL_ERROR' ).

    CREATE OBJECT obj_root.
    type ?= cl_abap_typedescr=>describe_by_object_ref( obj_root ).
    type->get_super_class_type(
      EXCEPTIONS
        super_class_not_found = 1
        OTHERS                = 2 ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-subrc
      exp = 1 ).

  ENDMETHOD.

ENDCLASS.