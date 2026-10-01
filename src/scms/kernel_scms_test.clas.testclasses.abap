CLASS ltcl_scms DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    DATA mt_rows TYPE STANDARD TABLE OF w3mime WITH DEFAULT KEY.
    DATA mv_content TYPE xstring.

    METHODS setup.
    METHODS to_xstring
      IMPORTING iv_length    TYPE i
      RETURNING VALUE(rv_xs) TYPE xstring.

    METHODS exact_length FOR TESTING RAISING cx_static_check.
    METHODS shorter FOR TESTING RAISING cx_static_check.
    METHODS longer_than_rows FOR TESTING RAISING cx_static_check.
    METHODS zero_length FOR TESTING RAISING cx_static_check.
    METHODS negative_length FOR TESTING RAISING cx_static_check.
    METHODS empty_table FOR TESTING RAISING cx_static_check.
    METHODS other_row_type FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_scms IMPLEMENTATION.

  METHOD setup.
* 600 bytes 00 01 02 ... in rows of 255, the last row padded with 00
    DATA lv_byte TYPE x LENGTH 1.
    DATA lv_int  TYPE i.
    DATA ls_row  TYPE w3mime.
    DATA lv_off  TYPE i.
    DATA lv_len  TYPE i.

    CLEAR mv_content.
    DO 600 TIMES.
      lv_int = ( sy-index - 1 ) MOD 256.
      lv_byte = lv_int.
      CONCATENATE mv_content lv_byte INTO mv_content IN BYTE MODE.
    ENDDO.

    CLEAR mt_rows.
    WHILE lv_off < 600.
      lv_len = 600 - lv_off.
      IF lv_len > 255.
        lv_len = 255.
      ENDIF.
      CLEAR ls_row.
      ls_row-line = mv_content+lv_off(lv_len).
      APPEND ls_row TO mt_rows.
      lv_off = lv_off + lv_len.
    ENDWHILE.
  ENDMETHOD.

  METHOD to_xstring.
    rv_xs = 'AB'.
    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = iv_length
      IMPORTING
        buffer       = rv_xs
      TABLES
        binary_tab   = mt_rows
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD exact_length.
    cl_abap_unit_assert=>assert_equals(
      act = to_xstring( 600 )
      exp = mv_content ).
  ENDMETHOD.

  METHOD shorter.
    cl_abap_unit_assert=>assert_equals(
      act = to_xstring( 5 )
      exp = '0001020304' ).
  ENDMETHOD.

  METHOD longer_than_rows.
* more than the rows hold is all of the rows, padding included
    cl_abap_unit_assert=>assert_equals(
      act = xstrlen( to_xstring( 3 * 255 + 300 ) )
      exp = 3 * 255 ).
  ENDMETHOD.

  METHOD zero_length.
    cl_abap_unit_assert=>assert_equals(
      act = xstrlen( to_xstring( 0 ) )
      exp = 0 ).
  ENDMETHOD.

  METHOD negative_length.
    cl_abap_unit_assert=>assert_equals(
      act = xstrlen( to_xstring( -3 ) )
      exp = 0 ).
  ENDMETHOD.

  METHOD empty_table.
    CLEAR mt_rows.
    cl_abap_unit_assert=>assert_equals(
      act = xstrlen( to_xstring( 4 ) )
      exp = 0 ).
  ENDMETHOD.

  METHOD other_row_type.
    DATA lt_rows TYPE STANDARD TABLE OF x WITH DEFAULT KEY.
    DATA lv_row  TYPE x LENGTH 1.
    DATA lv_xs   TYPE xstring.

    lv_row = '0A'.
    APPEND lv_row TO lt_rows.
    lv_row = 'FF'.
    APPEND lv_row TO lt_rows.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = 2
      IMPORTING
        buffer       = lv_xs
      TABLES
        binary_tab   = lt_rows.

    cl_abap_unit_assert=>assert_equals(
      act = lv_xs
      exp = '0AFF' ).
  ENDMETHOD.

ENDCLASS.
