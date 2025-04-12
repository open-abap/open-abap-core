CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS guid FOR TESTING RAISING cx_static_check.
    METHODS alpha_input FOR TESTING RAISING cx_static_check.
    METHODS alpha_input_aa FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD guid.
    DATA hex16 TYPE x LENGTH 16.
    CALL 'RFCControl'
      ID 'CODE' FIELD 'U'
      ID 'UUID' FIELD hex16.
    cl_abap_unit_assert=>assert_not_initial( hex16 ).
  ENDMETHOD.

  METHOD alpha_input.

    DATA lv_input TYPE c LENGTH 10.
    DATA lv_output TYPE c LENGTH 10.

    lv_input = '1234567890'.

    CALL 'CONVERSION_EXIT_ALPHA_INPUT'
      ID 'INPUT'  FIELD lv_input
      ID 'OUTPUT' FIELD lv_output.

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = '1234567890' ).

  ENDMETHOD.

  METHOD alpha_input_aa.

    DATA lv_input TYPE c LENGTH 4.
    DATA lv_output TYPE c LENGTH 4.

    lv_input = 'AA'.

    CALL 'CONVERSION_EXIT_ALPHA_INPUT'
      ID 'INPUT'  FIELD lv_input
      ID 'OUTPUT' FIELD lv_output.

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = 'AA' ).

  ENDMETHOD.

ENDCLASS.