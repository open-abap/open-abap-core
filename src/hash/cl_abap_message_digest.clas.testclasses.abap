CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS sha256 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD sha256.

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

ENDCLASS.