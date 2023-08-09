CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test1.
    DATA lv_int TYPE i.

    lv_int = cl_abap_random_int=>create(
      min = 1
      max = 10 )->get_next( ).

    cl_abap_unit_assert=>assert_number_between(
      lower  = 1
      upper  = 10
      number = lv_int ).
  ENDMETHOD.

ENDCLASS.