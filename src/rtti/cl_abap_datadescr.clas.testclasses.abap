CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_data_type_kind FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_data_type_kind.
    DATA foo TYPE string.
    DATA kind TYPE abap_typekind.
    kind = cl_abap_datadescr=>get_data_type_kind( foo ).
    cl_abap_unit_assert=>assert_equals(
      act = kind
      exp = cl_abap_typedescr=>typekind_string ).
  ENDMETHOD.

ENDCLASS.