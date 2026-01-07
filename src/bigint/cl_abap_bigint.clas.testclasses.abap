CLASS ltcl_bigint DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS factory_from_int4 FOR TESTING RAISING cx_static_check.
    METHODS add_int4_chain FOR TESTING RAISING cx_static_check.
    METHODS add_int4_returns_me FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_bigint IMPLEMENTATION.

  METHOD factory_from_int4.
    DATA lo_bigint TYPE REF TO cl_abap_bigint.

    lo_bigint = cl_abap_bigint=>factory_from_int4( 123 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_bigint->to_string( )
      exp = '123' ).
  ENDMETHOD.

  METHOD add_int4_chain.
    DATA lo_bigint TYPE REF TO cl_abap_bigint.

    lo_bigint = cl_abap_bigint=>factory_from_int4( 10 ).
    lo_bigint->add_int4( 5 )->add_int4( 7 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_bigint->to_string( )
      exp = '22' ).
  ENDMETHOD.

  METHOD add_int4_returns_me.
    DATA lo_bigint TYPE REF TO cl_abap_bigint.
    DATA lo_after TYPE REF TO cl_abap_bigint.

    lo_bigint = cl_abap_bigint=>factory_from_int4( 1 ).
    lo_after = lo_bigint->add_int4( 0 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_after
      exp = lo_bigint ).
  ENDMETHOD.

ENDCLASS.
