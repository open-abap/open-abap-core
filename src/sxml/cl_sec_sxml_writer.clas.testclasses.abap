CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS crypt_aes_ctr128 FOR TESTING RAISING cx_static_check.
    METHODS crypt_aes_ctr256 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD crypt_aes_ctr128.

    DATA lv_emptyiv TYPE xstring VALUE '00000000000000000000000000000000'.
    DATA lv_hash    TYPE xstring.
    DATA lv_key     TYPE xstring.

    lv_key = '00112233445566778899112233445566'.

    cl_sec_sxml_writer=>crypt_aes_ctr(
      EXPORTING
        input     = lv_emptyiv
        key       = lv_key
        iv        = lv_emptyiv
        algorithm = cl_sec_sxml_writer=>co_aes128_algorithm
      IMPORTING
        result    = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = '7223C1833065A1AFB8C900B221EDE011' ).

  ENDMETHOD.

  METHOD crypt_aes_ctr256.

    DATA lv_emptyiv TYPE xstring VALUE '00000000000000000000000000000000'.
    DATA lv_hash    TYPE xstring.
    DATA lv_key     TYPE xstring.

    lv_key = '0011223344556677889911223344556600112233445566778899112233445566'.

    cl_sec_sxml_writer=>crypt_aes_ctr(
      EXPORTING
        input     = lv_emptyiv
        key       = lv_key
        iv        = lv_emptyiv
        algorithm = cl_sec_sxml_writer=>co_aes256_algorithm
      IMPORTING
        result    = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = '130B0E50BC6E47E9888947C891C9FB9F' ).

  ENDMETHOD.

ENDCLASS.