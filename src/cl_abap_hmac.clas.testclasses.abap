CLASS ltcl_sha1 DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_sha1 IMPLEMENTATION.

  METHOD test1.

    DATA lv_key TYPE xstring.
    DATA lv_data TYPE xstring.
    DATA lv_hash TYPE string.

    lv_data = '112233'.

    cl_abap_hmac=>calculate_hmac_for_raw(
      EXPORTING
        if_key        = lv_key
        if_data       = lv_data
      IMPORTING
        ef_hmacstring = lv_hash ).

    cl_abap_unit_assert=>assert_not_initial( lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = '228B3B718E92E54B02D6735B2A8AF3978CA225BE' ).

  ENDMETHOD.

ENDCLASS.