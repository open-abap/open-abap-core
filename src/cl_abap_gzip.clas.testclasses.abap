CLASS ltcl_gzip DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS compress FOR TESTING.
    METHODS identity FOR TESTING.

ENDCLASS.

CLASS ltcl_gzip IMPLEMENTATION.

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