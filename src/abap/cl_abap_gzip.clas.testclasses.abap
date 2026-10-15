CLASS ltcl_gzip DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS compress FOR TESTING RAISING cx_static_check.
    METHODS decompress FOR TESTING RAISING cx_static_check.
    METHODS decompress_flush FOR TESTING RAISING cx_static_check.
    METHODS identity FOR TESTING RAISING cx_static_check.
    METHODS decompress_header FOR TESTING RAISING cx_static_check.
    METHODS decompress_same_field FOR TESTING RAISING cx_static_check.
    METHODS header_round_trip FOR TESTING RAISING cx_static_check.
    METHODS header_signature FOR TESTING RAISING cx_static_check.
    METHODS header_level_range FOR TESTING RAISING cx_static_check.
    METHODS header_corrupt FOR TESTING RAISING cx_static_check.
    METHODS decompress_corrupt FOR TESTING RAISING cx_static_check.
    METHODS level_stored FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_gzip IMPLEMENTATION.

  METHOD decompress.

    DATA lv_data TYPE xstring.
    DATA lv_decompressed TYPE xstring.
    DATA lv_decompress_len TYPE i.

    lv_data = '6354764DEF5C7DF63D000B5403C1F28B4858581C5AD6CA5AF352D2360CD6AF741935'.

    cl_abap_gzip=>decompress_binary(
      EXPORTING
        gzip_in     = lv_data
      IMPORTING
        raw_out     = lv_decompressed
        raw_out_len = lv_decompress_len ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_decompressed
      exp = '0123456789ABCDEF' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_decompress_len
      exp = 8 ).

  ENDMETHOD.

  METHOD compress.
    DATA input TYPE xstring.
    DATA out TYPE xstring.
    DATA len TYPE i.

    input = '11223344'.

    cl_abap_gzip=>compress_binary(
      EXPORTING
        raw_in       = input
      IMPORTING
        gzip_out     = out
        gzip_out_len = len ).

    cl_abap_unit_assert=>assert_equals(
      act = out
      exp = '135432760100' ).

    cl_abap_unit_assert=>assert_equals(
      act = len
      exp = 6 ).

  ENDMETHOD.

  METHOD identity.

    DATA input TYPE xstring.
    DATA result TYPE xstring.
    DATA out TYPE xstring.
    DATA len TYPE i.

    input = '1122334411223344'.

    cl_abap_gzip=>compress_binary(
      EXPORTING
        raw_in   = input
      IMPORTING
        gzip_out = out ).

    cl_abap_gzip=>decompress_binary(
      EXPORTING
        gzip_in = out
      IMPORTING
        raw_out = result ).

    cl_abap_unit_assert=>assert_equals(
      act = input
      exp = result ).

  ENDMETHOD.

  METHOD decompress_header.
    DATA lv_xstr TYPE xstring.
    lv_xstr = '1F8B0800BE07D16300FF05804109000008C4AA184EC1C7E0C08FF5C70EA43E470B85114A0D0B000000'.
    cl_abap_gzip=>decompress_binary_with_header(
      EXPORTING
        gzip_in = lv_xstr
      IMPORTING
        raw_out = lv_xstr ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_xstr
      exp = '68656C6C6F20776F726C64' ).
  ENDMETHOD.

  METHOD decompress_flush.

    DATA lv_compressed TYPE xstring.
    DATA lv_raw        TYPE xstring.

    lv_compressed = 'CA48CDC9C907000000FFFF'.

    cl_abap_gzip=>decompress_binary(
      EXPORTING
        gzip_in = lv_compressed
      IMPORTING
        raw_out = lv_raw ).

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_codepage=>convert_from( lv_raw )
      exp = 'hello' ).

  ENDMETHOD.

  METHOD decompress_same_field.
    DATA lv_message TYPE xstring.

    lv_message = 'CA48CDC9C907000000FFFF'.

    cl_abap_gzip=>decompress_binary(
      EXPORTING
        gzip_in = lv_message
      IMPORTING
        raw_out = lv_message ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_message
      exp = '68656C6C6F' ).
  ENDMETHOD.

  METHOD header_round_trip.
    DATA lv_gzip TYPE xstring.
    DATA lv_raw  TYPE xstring.
    cl_abap_gzip=>compress_binary_with_header(
      EXPORTING
        raw_in   = '68656C6C6F68656C6C6F'
      IMPORTING
        gzip_out = lv_gzip ).
    cl_abap_gzip=>decompress_binary_with_header(
      EXPORTING
        gzip_in = lv_gzip
      IMPORTING
        raw_out = lv_raw ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_raw
      exp = '68656C6C6F68656C6C6F' ).
  ENDMETHOD.

  METHOD header_signature.
* RFC 1952: ID1 ID2 and CM = 8 for deflate
    DATA lv_gzip TYPE xstring.
    DATA lv_head TYPE x LENGTH 3.
    cl_abap_gzip=>compress_binary_with_header(
      EXPORTING
        raw_in   = '68656C6C6F'
      IMPORTING
        gzip_out = lv_gzip ).
    lv_head = lv_gzip(3).
    cl_abap_unit_assert=>assert_equals(
      act = lv_head
      exp = '1F8B08' ).
  ENDMETHOD.

  METHOD header_level_range.
    DATA lv_gzip TYPE xstring.
    TRY.
        cl_abap_gzip=>compress_binary_with_header(
          EXPORTING
            raw_in         = '68656C6C6F'
            compress_level = 10
          IMPORTING
            gzip_out       = lv_gzip ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_parameter_invalid_range.
    ENDTRY.
  ENDMETHOD.

  METHOD header_corrupt.
    DATA lv_raw TYPE xstring.
    TRY.
        cl_abap_gzip=>decompress_binary_with_header(
          EXPORTING
            gzip_in = '1F8B0800000000000003FFFF'
          IMPORTING
            raw_out = lv_raw ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_compression_error.
    ENDTRY.
  ENDMETHOD.

  METHOD decompress_corrupt.
* a deflate stream with a distance that points before its start
    DATA lv_raw TYPE xstring.
    TRY.
        cl_abap_gzip=>decompress_binary(
          EXPORTING
            gzip_in = 'FFFFFFFFFFFFFFFF'
          IMPORTING
            raw_out = lv_raw ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_compression_error.
    ENDTRY.
  ENDMETHOD.

  METHOD level_stored.
    DATA lv_gzip TYPE xstring.
    DATA lv_raw  TYPE xstring.
    DATA lv_len  TYPE i.
    cl_abap_gzip=>compress_binary(
      EXPORTING
        raw_in         = '68656C6C6F'
        compress_level = 0
      IMPORTING
        gzip_out       = lv_gzip ).
    cl_abap_gzip=>decompress_binary(
      EXPORTING
        gzip_in     = lv_gzip
      IMPORTING
        raw_out     = lv_raw
        raw_out_len = lv_len ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_raw
      exp = '68656C6C6F' ).
  ENDMETHOD.

ENDCLASS.
