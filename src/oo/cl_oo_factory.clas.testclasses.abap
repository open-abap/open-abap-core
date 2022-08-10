CLASS ltcl_read_source DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_read_source IMPLEMENTATION.

  METHOD test1.
    DATA ref       TYPE REF TO if_oo_clif_source.
    DATA lt_source TYPE string_table.

    ref = cl_oo_factory=>create_instance( )->create_clif_source( 'CL_OO_FACTORY' ).

    ref->get_source( IMPORTING source = lt_source ).
    cl_abap_unit_assert=>assert_not_initial( lt_source ).
  ENDMETHOD.

ENDCLASS.