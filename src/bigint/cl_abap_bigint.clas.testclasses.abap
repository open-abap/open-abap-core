CLASS ltcl_bigint DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test_factory_from_int4 FOR TESTING RAISING cx_static_check.
    METHODS test_add_int4_chain FOR TESTING RAISING cx_static_check.
    METHODS test_add_int4_multiple FOR TESTING RAISING cx_static_check.

    METHODS test_sub FOR TESTING RAISING cx_static_check.
    METHODS test_mul FOR TESTING RAISING cx_static_check.
    METHODS test_mod FOR TESTING RAISING cx_static_check.
    METHODS test_clone FOR TESTING RAISING cx_static_check.

    METHODS test_sqrt_floor FOR TESTING RAISING cx_static_check.
    METHODS test_sqrt_negative_raises FOR TESTING RAISING cx_static_check.

    METHODS test_is_equal FOR TESTING RAISING cx_static_check.
    METHODS test_is_larger FOR TESTING RAISING cx_static_check.
    METHODS test_ref_is_initial_raises FOR TESTING RAISING cx_static_check.

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

  METHOD test_sub.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 10 )->sub( cl_abap_bigint=>factory_from_int4( 3 ) )->to_string( )
      exp = '7' ).
  ENDMETHOD.

  METHOD test_mul.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 6 )->mul( cl_abap_bigint=>factory_from_int4( 7 ) )->to_string( )
      exp = '42' ).
  ENDMETHOD.

  METHOD test_mod.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 22 )->mod( cl_abap_bigint=>factory_from_int4( 5 ) )->to_string( )
      exp = '2' ).
  ENDMETHOD.

  METHOD test_clone.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 9 )->clone( )->to_string( )
      exp = '9' ).
  ENDMETHOD.

  METHOD test_sqrt_floor.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 81 )->sqrt( )->to_string( )
      exp = '9' ).

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_bigint=>factory_from_int4( 80 )->sqrt( )->to_string( )
      exp = '8' ).
  ENDMETHOD.

  METHOD test_sqrt_negative_raises.
    TRY.
        cl_abap_bigint=>factory_from_int4( -1 )->sqrt( ).
        cl_abap_unit_assert=>fail( |expected cx_sy_arg_out_of_domain| ).
      CATCH cx_sy_arg_out_of_domain.
    ENDTRY.
  ENDMETHOD.

  METHOD test_is_equal.
    cl_abap_unit_assert=>assert_true(
      cl_abap_bigint=>factory_from_int4( 5 )->is_equal( cl_abap_bigint=>factory_from_int4( 5 ) ) ).

    cl_abap_unit_assert=>assert_false(
      cl_abap_bigint=>factory_from_int4( 5 )->is_equal( cl_abap_bigint=>factory_from_int4( 6 ) ) ).
  ENDMETHOD.

  METHOD test_is_larger.
    cl_abap_unit_assert=>assert_true(
      cl_abap_bigint=>factory_from_int4( 6 )->is_larger( cl_abap_bigint=>factory_from_int4( 5 ) ) ).

    cl_abap_unit_assert=>assert_false(
      cl_abap_bigint=>factory_from_int4( 5 )->is_larger( cl_abap_bigint=>factory_from_int4( 6 ) ) ).
  ENDMETHOD.

  METHOD test_ref_is_initial_raises.
    DATA lo_initial TYPE REF TO cl_abap_bigint.

    TRY.
        cl_abap_bigint=>factory_from_int4( 1 )->sub( lo_initial ).
        cl_abap_unit_assert=>fail( |expected cx_sy_ref_is_initial| ).
      CATCH cx_sy_ref_is_initial.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
