CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS read FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD read.

    CONSTANTS lc_expected TYPE i VALUE 42.
    DATA lv_int TYPE i.

    zcl_shma_root=>read( ).

    zcl_shma_root=>update( lc_expected ).

    lv_int = zcl_shma_root=>read( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_int
      exp = lc_expected ).

  ENDMETHOD.

ENDCLASS.