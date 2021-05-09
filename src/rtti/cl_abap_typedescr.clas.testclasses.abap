CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS typekind_int FOR TESTING.
    METHODS typekind_char FOR TESTING.
    METHODS typekind_structure FOR TESTING.
    METHODS typekind_xstring FOR TESTING.
    METHODS typekind_string FOR TESTING.
    METHODS kind_elem FOR TESTING.
    METHODS field_symbol FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD kind_elem.

    DATA lv_int TYPE i.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( lv_int ).

    cl_abap_unit_assert=>assert_equals(
      act = type->kind
      exp = cl_abap_typedescr=>kind_elem ).

  ENDMETHOD.

  METHOD typekind_char.

    DATA bool TYPE abap_bool.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( bool ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_char ).

  ENDMETHOD.

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

  METHOD field_symbol.

    DATA integer TYPE i.
    DATA type TYPE REF TO cl_abap_typedescr.
    FIELD-SYMBOLS <fs> TYPE i.
    ASSIGN integer TO <fs>.

    type = cl_abap_typedescr=>describe_by_data( <fs> ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_int ).

  ENDMETHOD.

ENDCLASS.