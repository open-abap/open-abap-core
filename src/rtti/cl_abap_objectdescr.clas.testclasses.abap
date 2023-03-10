CLASS ltcl_foo DEFINITION FOR TESTING FINAL.
  PUBLIC SECTION.
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
    CREATE OBJECT lo_foo.
    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_foo ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 1 ).
  ENDMETHOD.

ENDCLASS.