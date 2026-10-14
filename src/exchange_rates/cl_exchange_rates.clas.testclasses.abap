CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS rate_type_length FOR TESTING RAISING cx_static_check.
    METHODS currency_key_length FOR TESTING RAISING cx_static_check.
    METHODS rate_keeps_decimals FOR TESTING RAISING cx_static_check.
    METHODS exchange_rates_table FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD rate_type_length.
    DATA ls_curr TYPE cl_exchange_rates=>ty_convert_curr.
    ls_curr-kurst = 'MABC'.
    cl_abap_unit_assert=>assert_equals(
      act = ls_curr-kurst
      exp = 'MABC' ).
    ls_curr-kurst = 'MABCD'.
    cl_abap_unit_assert=>assert_equals(
      act = ls_curr-kurst
      exp = 'MABC' ).
  ENDMETHOD.

  METHOD currency_key_length.
    DATA ls_curr TYPE cl_exchange_rates=>ty_convert_curr.
    ls_curr-fcurr = 'EURXYZ'.
    ls_curr-tcurr = 'USDXYZ'.
    cl_abap_unit_assert=>assert_equals(
      act = ls_curr-fcurr
      exp = 'EURXY' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_curr-tcurr
      exp = 'USDXY' ).
  ENDMETHOD.

  METHOD rate_keeps_decimals.
    DATA ls_curr TYPE cl_exchange_rates=>ty_convert_curr.
    ls_curr-ukurs = '1.08512'.
    cl_abap_unit_assert=>assert_equals(
      act = |{ ls_curr-ukurs }|
      exp = '1.08512' ).
  ENDMETHOD.

  METHOD exchange_rates_table.
    DATA lt_rates TYPE cl_exchange_rates=>ty_exchange_rates.
    DATA ls_rate  LIKE LINE OF lt_rates.
    ls_rate-rate_type = 'M'.
    ls_rate-from_curr = 'EUR'.
    ls_rate-to_currncy = 'USD'.
    ls_rate-valid_from = '20240101'.
    ls_rate-exch_rate = '1.08512'.
    ls_rate-from_factor = 1.
    ls_rate-to_factor = 1.
    APPEND ls_rate TO lt_rates.
    READ TABLE lt_rates INDEX 1 INTO ls_rate.
    cl_abap_unit_assert=>assert_equals(
      act = |{ ls_rate-exch_rate }|
      exp = '1.08512' ).
  ENDMETHOD.

ENDCLASS.
