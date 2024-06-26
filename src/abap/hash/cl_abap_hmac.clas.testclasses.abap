CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS sha1 FOR TESTING RAISING cx_static_check.
    METHODS md5 FOR TESTING RAISING cx_static_check.
    METHODS hmac_md5 FOR TESTING RAISING cx_static_check.
    METHODS sha256 FOR TESTING RAISING cx_static_check.
    METHODS char FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD sha1.

    DATA lv_key  TYPE xstring.
    DATA lv_data TYPE xstring.
    DATA lv_hash TYPE string.
    DATA lv_base TYPE string.

    lv_data = '112233'.

    cl_abap_hmac=>calculate_hmac_for_raw(
      EXPORTING
        if_key           = lv_key
        if_data          = lv_data
      IMPORTING
        ef_hmacstring    = lv_hash
        ef_hmacb64string = lv_base ).

    cl_abap_unit_assert=>assert_not_initial( lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = '228B3B718E92E54B02D6735B2A8AF3978CA225BE' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_base
      exp = 'Ios7cY6S5UsC1nNbKorzl4yiJb4=' ).

  ENDMETHOD.

  METHOD md5.

    DATA lv_empty TYPE xstring.
    DATA lv_hash  TYPE xstring.

    cl_abap_hmac=>calculate_hmac_for_raw(
      EXPORTING
        if_algorithm   = 'MD5'
        if_key         = lv_empty
        if_data        = '1122'
      IMPORTING
        ef_hmacxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
       act = lv_hash
       exp = 'C700ED4FDB1D27055AA3FAA2C2432283' ).

  ENDMETHOD.

  METHOD sha256.

    DATA lv_empty TYPE xstring.
    DATA lv_hash  TYPE xstring.

    cl_abap_hmac=>calculate_hmac_for_raw(
      EXPORTING
        if_algorithm   = 'SHA256'
        if_key         = lv_empty
        if_data        = '1122'
      IMPORTING
        ef_hmacxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
       act = lv_hash
       exp = '044E2F819A4A5992C46CBCB5D18F96236DA924E27274ECB6A46F93903E272CA6' ).

  ENDMETHOD.

  METHOD hmac_md5.

    DATA lv_key  TYPE xstring.
    DATA lv_hash TYPE xstring.
    DATA lv_data TYPE xstring.

    lv_key = '1122334455'.
    lv_data = '5544332211'.

    cl_abap_hmac=>calculate_hmac_for_raw(
      EXPORTING
        if_algorithm   = 'MD5'
        if_key         = lv_key
        if_data        = lv_data
      IMPORTING
        ef_hmacxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = '96F48F411FA2DD50FE9C75C973457C69' ).

  ENDMETHOD.

  METHOD char.

    DATA lv_hash  TYPE xstring.
    DATA lv_empty TYPE xstring.

    cl_abap_hmac=>calculate_hmac_for_char(
      EXPORTING
        if_data        = |hello world|
        if_key         = lv_empty
      IMPORTING
        ef_hmacxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = '2AAE6C35C94FCFB415DBE95F408B9CE91EE846ED' ).

  ENDMETHOD.

ENDCLASS.