CLASS ltcl_numberrange_runtime DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS returned_quantity FOR TESTING RAISING cx_static_check.
    METHODS subobject_own_counter FOR TESTING RAISING cx_static_check.
    METHODS toyear_own_counter FOR TESTING RAISING cx_static_check.
    METHODS status FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_numberrange_runtime IMPLEMENTATION.

  METHOD test1.

    DATA lv_num TYPE n LENGTH 10.

* as of now, the range and object is not checked, everything returns a number, always
    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr = '01'
        object      = 'HELLO'
      IMPORTING
        number      = lv_num ).

    cl_abap_unit_assert=>assert_not_initial( lv_num ).

    cl_abap_unit_assert=>assert_equals(
      exp = '0000000001'
      act = lv_num ).

    CLEAR lv_num.

    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr = '01'
        object      = 'HELLO'
      IMPORTING
        number      = lv_num ).

    cl_abap_unit_assert=>assert_equals(
      exp = '0000000002'
      act = lv_num ).

  ENDMETHOD.

  METHOD returned_quantity.
    DATA lv_number     TYPE cl_numberrange_runtime=>nr_number.
    DATA lv_returncode TYPE cl_numberrange_runtime=>nr_returncode.
    DATA lv_quantity   TYPE cl_numberrange_runtime=>nr_returned_quantity.
    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr       = '01'
        object            = 'QUANTITY'
      IMPORTING
        number            = lv_number
        returncode        = lv_returncode
        returned_quantity = lv_quantity ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_number
      exp = 1 ).
    cl_abap_unit_assert=>assert_initial( lv_returncode ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_quantity
      exp = 1 ).
  ENDMETHOD.

  METHOD subobject_own_counter.
    DATA lv_number TYPE cl_numberrange_runtime=>nr_number.
    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr = '01'
        object      = 'SUBOBJ'
        subobject   = '1000'
      IMPORTING
        number      = lv_number ).
    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr = '01'
        object      = 'SUBOBJ'
        subobject   = '2000'
      IMPORTING
        number      = lv_number ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_number
      exp = 1 ).
  ENDMETHOD.

  METHOD toyear_own_counter.
    DATA lv_number TYPE cl_numberrange_runtime=>nr_number.
    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr = '01'
        object      = 'YEARLY'
        toyear      = '2025'
      IMPORTING
        number      = lv_number ).
    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr = '01'
        object      = 'YEARLY'
        toyear      = '2026'
      IMPORTING
        number      = lv_number ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_number
      exp = 1 ).
  ENDMETHOD.

  METHOD status.
    DATA lv_number TYPE cl_numberrange_runtime=>nr_number.
    cl_numberrange_runtime=>number_status(
      EXPORTING
        nr_range_nr = '01'
        object      = 'STATUS'
      IMPORTING
        number      = lv_number ).
    cl_abap_unit_assert=>assert_initial( lv_number ).
    DO 3 TIMES.
      cl_numberrange_runtime=>number_get(
        EXPORTING
          nr_range_nr = '01'
          object      = 'STATUS'
        IMPORTING
          number      = lv_number ).
    ENDDO.
    CLEAR lv_number.
    cl_numberrange_runtime=>number_status(
      EXPORTING
        nr_range_nr = '01'
        object      = 'STATUS'
      IMPORTING
        number      = lv_number ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_number
      exp = 3 ).
  ENDMETHOD.

ENDCLASS.
