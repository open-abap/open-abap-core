CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS raw_sha256 FOR TESTING RAISING cx_static_check.
    METHODS raw_sha256_all_exports FOR TESTING RAISING cx_static_check.
    METHODS raw_sha512 FOR TESTING RAISING cx_static_check.
    METHODS raw_md5_empty FOR TESTING RAISING cx_static_check.
    METHODS raw_dashed_name FOR TESTING RAISING cx_static_check.
    METHODS raw_length_prefix FOR TESTING RAISING cx_static_check.
    METHODS char_sha256 FOR TESTING RAISING cx_static_check.
    METHODS string FOR TESTING RAISING cx_static_check.
    METHODS string_to_xstring_utf8 FOR TESTING RAISING cx_static_check.
    METHODS unknown_algorithm_raises FOR TESTING RAISING cx_static_check.
    METHODS instance_update_digest FOR TESTING RAISING cx_static_check.
    METHODS instance_digest_length FOR TESTING RAISING cx_static_check.
    METHODS instance_reset FOR TESTING RAISING cx_static_check.
    METHODS is_equal FOR TESTING RAISING cx_static_check.

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

  METHOD raw_sha256_all_exports.

    DATA lv_hash   TYPE xstring.
    DATA lv_hex    TYPE string.
    DATA lv_base64 TYPE string.
    DATA lv_x      TYPE x LENGTH 32.

    cl_abap_message_digest=>calculate_hash_for_raw(
      EXPORTING
        if_algorithm     = 'SHA256'
        if_data          = '616263'
      IMPORTING
        ef_hashxstring   = lv_hash
        ef_hashstring    = lv_hex
        ef_hashb64string = lv_base64
        ef_hashx         = lv_x ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_base64
      exp = 'ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0=' ).
    cl_abap_unit_assert=>assert_equals(
      act = CONV xstring( lv_x )
      exp = lv_hash ).

  ENDMETHOD.

  METHOD raw_sha512.

    DATA lv_hash TYPE xstring.

    cl_abap_message_digest=>calculate_hash_for_raw(
      EXPORTING
        if_algorithm   = 'SHA512'
        if_data        = '616263'
      IMPORTING
        ef_hashxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = xstrlen( lv_hash )
      exp = 64 ).
    DATA(lv_prefix) = lv_hash(24).
    cl_abap_unit_assert=>assert_equals(
      act = lv_prefix
      exp = 'DDAF35A193617ABACC417349AE20413112E6FA4E89A97EA2' ).

  ENDMETHOD.

  METHOD raw_md5_empty.

    DATA lv_hash  TYPE xstring.
    DATA lv_empty TYPE xstring.

    cl_abap_message_digest=>calculate_hash_for_raw(
      EXPORTING
        if_algorithm   = 'MD5'
        if_data        = lv_empty
      IMPORTING
        ef_hashxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = 'D41D8CD98F00B204E9800998ECF8427E' ).

  ENDMETHOD.

  METHOD raw_dashed_name.

    DATA lv_hash TYPE xstring.

    cl_abap_message_digest=>calculate_hash_for_raw(
      EXPORTING
        if_algorithm   = 'sha-256'
        if_data        = '1122'
      IMPORTING
        ef_hashxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
       act = lv_hash
       exp = '044E2F819A4A5992C46CBCB5D18F96236DA924E27274ECB6A46F93903E272CA6' ).

  ENDMETHOD.

  METHOD raw_length_prefix.

    DATA lv_hash TYPE xstring.

    cl_abap_message_digest=>calculate_hash_for_raw(
      EXPORTING
        if_algorithm   = 'SHA256'
        if_data        = '1122FFFF'
        if_length      = 2
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

  METHOD string.

    DATA lv_hash TYPE string.

    cl_abap_message_digest=>calculate_hash_for_char(
      EXPORTING
        if_algorithm  = 'SHA256'
        if_data       = 'hello world'
      IMPORTING
        ef_hashstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = 'B94D27B9934D3E08A52E52D7DA7DABFAC484EFE37A5380EE9088F7ACE2EFCDE9' ).

  ENDMETHOD.

  METHOD string_to_xstring_utf8.

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_message_digest=>string_to_xstring( 'abc' )
      exp = '616263' ).

  ENDMETHOD.

  METHOD unknown_algorithm_raises.

    TRY.
        cl_abap_message_digest=>get_instance( 'ROT13' ).
        cl_abap_unit_assert=>fail( 'unknown algorithm must raise' ).
      CATCH cx_abap_message_digest INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->algorithm
          exp = 'ROT13' ).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->if_t100_message~t100key-msgno
          exp = cx_abap_message_digest=>unknown_algorithm-msgno ).
    ENDTRY.

  ENDMETHOD.

  METHOD instance_update_digest.

    DATA lv_hash TYPE xstring.

    DATA(lo_digest) = cl_abap_message_digest=>get_instance( 'SHA256' ).
    lo_digest->update( '61' ).
    lo_digest->update( '6263' ).
    lo_digest->digest( IMPORTING ef_hashxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_digest->get_digest( )
      exp = lv_hash ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_digest->to_base64( )
      exp = 'ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0=' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_digest->get_algorithm( )
      exp = 'SHA256' ).

  ENDMETHOD.

  METHOD instance_digest_length.

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_message_digest=>get_instance( 'SHA1' )->get_digest_length( )
      exp = 20 ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_message_digest=>get_instance( 'SHA384' )->get_digest_length( )
      exp = 48 ).

  ENDMETHOD.

  METHOD instance_reset.

    DATA lv_hash TYPE xstring.

    DATA(lo_digest) = cl_abap_message_digest=>get_instance( 'MD5' ).
    lo_digest->update( 'FFFF' ).
    lo_digest->reset( ).
    lo_digest->digest( IMPORTING ef_hashxstring = lv_hash ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = 'D41D8CD98F00B204E9800998ECF8427E' ).

  ENDMETHOD.

  METHOD is_equal.

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_message_digest=>is_equal( if_digesta = '1122' if_digestb = '1122' )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_message_digest=>is_equal( if_digesta = '1122' if_digestb = '1123' )
      exp = abap_false ).

  ENDMETHOD.

ENDCLASS.
