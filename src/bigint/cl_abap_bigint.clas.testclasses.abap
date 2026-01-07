CLASS ltcl_bigint DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test_factory_from_int4 FOR TESTING RAISING cx_static_check.
    METHODS test_add_int4_chain FOR TESTING RAISING cx_static_check.
    METHODS test_add_int4_multiple FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_bigint IMPLEMENTATION.

  METHOD test_factory_from_int4.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 123 )->to_string( )
      exp = '123' ).
  ENDMETHOD.

  METHOD test_add_int4_chain.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 10 )->add_int4( 5 )->add_int4( 7 )->to_string( )
      exp = '22' ).
  ENDMETHOD.

  METHOD test_add_int4_multiple.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 1 )->add_int4( 0 )->add_int4( 1 )->to_string( )
      exp = '2' ).
  ENDMETHOD.

ENDCLASS.
