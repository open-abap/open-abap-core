CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test1.

    DATA foo TYPE i.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( foo ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_int ).

  ENDMETHOD.

ENDCLASS.