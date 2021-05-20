CLASS ltcl_gzip DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS compress FOR TESTING.
    METHODS decompress FOR TESTING.
    METHODS identity FOR TESTING.

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

ENDCLASS.