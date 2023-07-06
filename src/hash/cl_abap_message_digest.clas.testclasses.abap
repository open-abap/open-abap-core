CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS raw_sha256 FOR TESTING RAISING cx_static_check.
    METHODS char_sha256 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD raw_sha256.

    DATA lv_hash TYPE xstring.

    cl_abap_message_digest=>calculate_hash_for_raw(
      EXPORTING
        if_algorithm   = 'SHA256'
        if_data        = '1122'
      IMPORTING
        ef_hashxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
       act = lv_hash
       exp = '044E2F819A4A5992C46CBCB5D18F96236DA924E27274ECB6A46F93903E272CA6' ).

  ENDMETHOD.

  METHOD char_sha256.

    DATA lv_hash   TYPE xstring.
    DATA lv_base64 TYPE string.

    cl_abap_message_digest=>calculate_hash_for_char(
      EXPORTING
        if_algorithm     = 'SHA256'
        if_data          = 'hello world'
      IMPORTING
        ef_hashxstring   = lv_hash
        ef_hashb64string = lv_base64 ).

    cl_abap_unit_assert=>assert_equals(
       act = lv_hash
       exp = 'B94D27B9934D3E08A52E52D7DA7DABFAC484EFE37A5380EE9088F7ACE2EFCDE9' ).

    cl_abap_unit_assert=>assert_equals(
       act = lv_base64
       exp = 'uU0nuZNNPgilLlLX2n2r+sSE7+N6U4DukIj3rOLvzek=' ).

  ENDMETHOD.

ENDCLASS.