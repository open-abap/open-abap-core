CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

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

ENDCLASS.