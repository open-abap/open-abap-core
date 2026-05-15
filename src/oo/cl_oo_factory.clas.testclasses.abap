CLASS ltcl_read_source DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test_clas FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_read_source IMPLEMENTATION.

  METHOD test_clas.
    DATA lt_source TYPE string_table.

    DATA(lo_ref) = cl_oo_factory=>create_instance( )->create_clif_source( 'CL_OO_FACTORY' ).

    lo_ref->get_source( IMPORTING source = lt_source ).
    cl_abap_unit_assert=>assert_not_initial( lt_source ).
  ENDMETHOD.

ENDCLASS.