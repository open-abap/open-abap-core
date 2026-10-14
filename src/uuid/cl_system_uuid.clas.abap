CLASS cl_system_uuid DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_system_uuid_rfc4122_static.
    INTERFACES if_system_uuid_static.

    ALIASES convert_uuid_c22_static FOR if_system_uuid_static~convert_uuid_c22.
    ALIASES convert_uuid_c32_static FOR if_system_uuid_static~convert_uuid_c32.
    ALIASES convert_uuid_c36_static FOR if_system_uuid_static~convert_uuid_c36.
    ALIASES convert_uuid_x16_static FOR if_system_uuid_static~convert_uuid_x16.
    ALIASES create_uuid_c22_static FOR if_system_uuid_static~create_uuid_c22.
    ALIASES create_uuid_c32_static FOR if_system_uuid_static~create_uuid_c32.
    ALIASES create_uuid_c36_static FOR if_system_uuid_static~create_uuid_c36.
    ALIASES create_uuid_x16_static FOR if_system_uuid_static~create_uuid_x16.
  PRIVATE SECTION.
* the 22 character form: the 32 hex digits plus a padding "0", in 11 groups of 3 hex digits,
* each group written as two characters of this alphabet
    CONSTANTS c_c22_alphabet TYPE string VALUE '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz{}'.
    CONSTANTS c_hex_digits TYPE string VALUE '0123456789ABCDEF'.

    CLASS-METHODS random RETURNING VALUE(rv_str) TYPE string.
    CLASS-METHODS c32_to_c22
      IMPORTING iv_c32        TYPE sysuuid_c32
      RETURNING VALUE(rv_c22) TYPE sysuuid_c22.
    CLASS-METHODS c22_to_c32
      IMPORTING iv_c22        TYPE sysuuid_c22
      RETURNING VALUE(rv_c32) TYPE sysuuid_c32
      RAISING   cx_uuid_error.
    CLASS-METHODS c32_to_c36
      IMPORTING iv_c32        TYPE sysuuid_c32
      RETURNING VALUE(rv_c36) TYPE sysuuid_c36.
    CLASS-METHODS c36_to_c32
      IMPORTING iv_c36        TYPE sysuuid_c36
      RETURNING VALUE(rv_c32) TYPE sysuuid_c32
      RAISING   cx_uuid_error.
    CLASS-METHODS check_c32
      IMPORTING iv_c32        TYPE sysuuid_c32
      RETURNING VALUE(rv_c32) TYPE sysuuid_c32
      RAISING   cx_uuid_error.
ENDCLASS.

CLASS cl_system_uuid IMPLEMENTATION.

  METHOD random.
    " browser and node
    WRITE '@KERNEL if (cl_system_uuid.CRYPTO === undefined) cl_system_uuid.CRYPTO = await import("crypto");'.
    WRITE '@KERNEL if (cl_system_uuid.CRYPTO.randomUUID) {'.
    WRITE '@KERNEL   rv_str.set(cl_system_uuid.CRYPTO.randomUUID());'.
    WRITE '@KERNEL } else {'.
    WRITE '@KERNEL   rv_str = window.crypto.randomUUID();'.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_x16.
    DATA lv_str TYPE string.
    lv_str = random( ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_str WITH ''.
    TRANSLATE lv_str TO UPPER CASE.
    uuid = lv_str(32).
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_c32.
    DATA lv_str TYPE string.
    lv_str = random( ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_str WITH ''.
    uuid = lv_str(32).
    TRANSLATE uuid TO UPPER CASE.
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_c36.
    DATA lv_str TYPE string.
    lv_str = random( ).
    TRANSLATE lv_str TO UPPER CASE.
    uuid = lv_str.
  ENDMETHOD.

  METHOD if_system_uuid_rfc4122_static~create_uuid_c36_by_version.
    ASSERT version = 4.
    uuid = random( ).
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_c22.
    DATA lv_str TYPE string.
    lv_str = random( ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_str WITH ''.
    uuid = lv_str(22).
  ENDMETHOD.

  METHOD if_system_uuid_static~convert_uuid_x16.
    DATA lv_c32 TYPE sysuuid_c32.
    lv_c32 = uuid.
    uuid_c32 = lv_c32.
    uuid_c22 = c32_to_c22( lv_c32 ).
    uuid_c36 = c32_to_c36( lv_c32 ).
  ENDMETHOD.

  METHOD if_system_uuid_static~convert_uuid_c22.
    DATA lv_c32 TYPE sysuuid_c32.
    lv_c32 = c22_to_c32( uuid ).
    uuid_x16 = lv_c32.
    uuid_c32 = lv_c32.
    uuid_c36 = c32_to_c36( lv_c32 ).
  ENDMETHOD.

  METHOD if_system_uuid_static~convert_uuid_c32.
    DATA lv_c32 TYPE sysuuid_c32.
    lv_c32 = check_c32( uuid ).
    uuid_x16 = lv_c32.
    uuid_c22 = c32_to_c22( lv_c32 ).
    uuid_c36 = c32_to_c36( lv_c32 ).
  ENDMETHOD.

  METHOD if_system_uuid_static~convert_uuid_c36.
    DATA lv_c32 TYPE sysuuid_c32.
    lv_c32 = c36_to_c32( uuid ).
    uuid_x16 = lv_c32.
    uuid_c22 = c32_to_c22( lv_c32 ).
    uuid_c32 = lv_c32.
  ENDMETHOD.

  METHOD check_c32.
    rv_c32 = iv_c32.
    TRANSLATE rv_c32 TO UPPER CASE.
    IF strlen( rv_c32 ) <> 32 OR rv_c32 CN c_hex_digits.
      RAISE EXCEPTION TYPE cx_uuid_error.
    ENDIF.
  ENDMETHOD.

  METHOD c32_to_c36.
    rv_c36 = |{ iv_c32(8) }-{ iv_c32+8(4) }-{ iv_c32+12(4) }-{ iv_c32+16(4) }-{ iv_c32+20(12) }|.
  ENDMETHOD.

  METHOD c36_to_c32.
    IF strlen( iv_c36 ) <> 36
        OR iv_c36+8(1) <> '-' OR iv_c36+13(1) <> '-' OR iv_c36+18(1) <> '-' OR iv_c36+23(1) <> '-'.
      RAISE EXCEPTION TYPE cx_uuid_error.
    ENDIF.
    rv_c32 = check_c32( |{ iv_c36(8) }{ iv_c36+9(4) }{ iv_c36+14(4) }{ iv_c36+19(4) }{ iv_c36+24(12) }| ).
  ENDMETHOD.

  METHOD c32_to_c22.
    DATA lv_hex   TYPE string.
    DATA lv_group TYPE i.
    DATA lv_value TYPE i.
    DATA lv_digit TYPE i.
    DATA lv_index TYPE i.
    DATA lv_high  TYPE i.
    DATA lv_low   TYPE i.

    lv_hex = iv_c32 && '0'.
    DO 11 TIMES.
      lv_group = ( sy-index - 1 ) * 3.
      lv_value = 0.
      DO 3 TIMES.
        lv_index = lv_group + sy-index - 1.
        FIND lv_hex+lv_index(1) IN c_hex_digits MATCH OFFSET lv_digit.
        lv_value = lv_value * 16 + lv_digit.
      ENDDO.
      lv_high = lv_value DIV 64.
      lv_low = lv_value MOD 64.
      rv_c22 = rv_c22 && c_c22_alphabet+lv_high(1) && c_c22_alphabet+lv_low(1).
    ENDDO.
  ENDMETHOD.

  METHOD c22_to_c32.
    DATA lv_hex   TYPE string.
    DATA lv_value TYPE i.
    DATA lv_high  TYPE i.
    DATA lv_low   TYPE i.
    DATA lv_index TYPE i.
    DATA lv_digit TYPE i.

    IF strlen( iv_c22 ) <> 22.
      RAISE EXCEPTION TYPE cx_uuid_error.
    ENDIF.

    DO 11 TIMES.
      lv_index = ( sy-index - 1 ) * 2.
      FIND iv_c22+lv_index(1) IN c_c22_alphabet MATCH OFFSET lv_high RESPECTING CASE.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE cx_uuid_error.
      ENDIF.
      lv_index = lv_index + 1.
      FIND iv_c22+lv_index(1) IN c_c22_alphabet MATCH OFFSET lv_low RESPECTING CASE.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE cx_uuid_error.
      ENDIF.
      lv_value = lv_high * 64 + lv_low.
      DO 3 TIMES.
        lv_digit = lv_value DIV 256.
        lv_hex = lv_hex && c_hex_digits+lv_digit(1).
        lv_value = ( lv_value MOD 256 ) * 16.
      ENDDO.
    ENDDO.

* the 33rd hex digit is padding and must be zero
    IF lv_hex+32(1) <> '0'.
      RAISE EXCEPTION TYPE cx_uuid_error.
    ENDIF.
    rv_c32 = lv_hex(32).
  ENDMETHOD.

ENDCLASS.
