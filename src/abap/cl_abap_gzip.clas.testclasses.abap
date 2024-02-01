CLASS ltcl_gzip DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS compress FOR TESTING RAISING cx_static_check.
    METHODS decompress FOR TESTING RAISING cx_static_check.
    METHODS decompress_flush FOR TESTING RAISING cx_static_check.
    METHODS identity FOR TESTING RAISING cx_static_check.
    METHODS decompress_header FOR TESTING RAISING cx_static_check.

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
        raw_in       = input
      IMPORTING
        gzip_out     = out ).

    cl_abap_gzip=>decompress_binary(
      EXPORTING
        gzip_in      = out
      IMPORTING
        raw_out     = result ).

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

ENDCLASS.