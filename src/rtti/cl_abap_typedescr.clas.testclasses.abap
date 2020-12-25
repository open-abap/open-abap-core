CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS typekind_int FOR TESTING.
    METHODS typekind_structure FOR TESTING.
    METHODS typekind_xstring FOR TESTING.
    METHODS typekind_string FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD typekind_int.

    DATA integer TYPE i.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( integer ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_int ).

  ENDMETHOD.

  METHOD typekind_xstring.
    DATA data TYPE xstring.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_xstring ).
  ENDMETHOD.

  METHOD typekind_string.
    DATA data TYPE string.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_string ).
  ENDMETHOD.

  METHOD typekind_structure.
    TYPES: BEGIN OF ty_struc,
             a TYPE string,
             b TYPE abap_bool,
             c TYPE i,
           END OF ty_struc.
    DATA ls_struc_act TYPE ty_struc.

    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( ls_struc_act ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_struct2 ).
  ENDMETHOD.

ENDCLASS.