CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test01.

    " TYPES: BEGIN OF ty_structure,
    "          field TYPE i,
    "        END OF ty_structure.

    " DATA ls_data TYPE ty_structure.
    " DATA lo_struc TYPE REF TO cl_abap_structdescr.
    " DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    " DATA ls_comp LIKE LINE OF lt_comps.

    " lo_struc ?= cl_abap_structdescr=>describe_by_data( ls_data ).
    " lt_comps = lo_struc->get_components( ).

    " cl_abap_unit_assert=>assert_equals(
    "   act = lines( lt_comps )
    "   exp = 1 ).

    " READ TABLE lt_comps INDEX 1 INTO ls_comp.
    " cl_abap_unit_assert=>assert_subrc( ).

    " cl_abap_unit_assert=>assert_equals(
    "   act = ls_comp-name
    "   exp = 'FIELD' ).

    " cl_abap_unit_assert=>assert_not_initial( ls_comp-type ).

  ENDMETHOD.

ENDCLASS.