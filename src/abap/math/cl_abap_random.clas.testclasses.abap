CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS seed FOR TESTING RAISING cx_static_check.
    METHODS intinrange FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test1.
    cl_abap_unit_assert=>assert_not_initial( cl_abap_random=>create( )->int( ) ).
  ENDMETHOD.

  METHOD seed.
    cl_abap_unit_assert=>assert_not_initial( cl_abap_random=>seed( ) ).
  ENDMETHOD.

  METHOD intinrange.
    DATA lo_random TYPE REF TO cl_abap_random.
    DATA lv_int TYPE i.
    lo_random = cl_abap_random=>create( ).
    DO 10 TIMES.
      lv_int = lo_random->intinrange(
        low  = 10
        high = 20 ).
      cl_abap_unit_assert=>assert_number_between(
        lower  = 10
        upper  = 20
        number = lv_int ).
    ENDDO.
  ENDMETHOD.

ENDCLASS.