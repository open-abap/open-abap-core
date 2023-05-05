CLASS cl_abap_conv_out_ce DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      create
        IMPORTING
          encoding    TYPE abap_encoding OPTIONAL
          ignore_cerr TYPE abap_bool DEFAULT abap_false
          endian      TYPE string OPTIONAL
          replacement TYPE string OPTIONAL
        RETURNING
          VALUE(ret)  TYPE REF TO cl_abap_conv_out_ce.

    CLASS-METHODS
      uccpi
        IMPORTING
          value TYPE string
        RETURNING
          VALUE(ret) TYPE i.

    TYPES hex02 TYPE x LENGTH 2.
    CLASS-METHODS uccp
      IMPORTING
        char TYPE clike
      RETURNING
        VALUE(uccp) TYPE hex02
      RAISING
        cx_sy_conversion_codepage
        cx_sy_codepage_converter_init
        cx_parameter_invalid_range.

    METHODS
      convert
        IMPORTING
          data   TYPE string
          n      TYPE i OPTIONAL
        EXPORTING
          buffer TYPE xstring.
    METHODS write
      IMPORTING
        data TYPE string.
    METHODS get_buffer
      RETURNING
        VALUE(buffer) TYPE xstring.
    METHODS reset.
  PRIVATE SECTION.
    DATA mv_js_encoding TYPE string.
    DATA mv_buffer TYPE xstring.
ENDCLASS.

CLASS cl_abap_conv_out_ce IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT ret.
    CASE encoding.
      WHEN 'UTF-8' OR ''.
        ret->mv_js_encoding = 'utf8'.
      WHEN '4103'.
        ret->mv_js_encoding = 'utf16le'.
      WHEN OTHERS.
        ASSERT 1 = 'not supported'.
    ENDCASE.
  ENDMETHOD.

  METHOD uccpi.
    DATA lo_out TYPE REF TO cl_abap_conv_out_ce.
    DATA lv_hex TYPE xstring.
    lo_out = create( encoding = '4103' ).
    lo_out->convert(
      EXPORTING
        data = value
      IMPORTING
        buffer = lv_hex ).
    ASSERT xstrlen( lv_hex ) = 2.
    ret = lv_hex(1).
    ret = ret + lv_hex+1(1) * 255.
  ENDMETHOD.

  METHOD write.
    DATA res TYPE xstring.
    convert( EXPORTING data = data
             IMPORTING buffer = res ).
    CONCATENATE mv_buffer res INTO mv_buffer IN BYTE MODE.
  ENDMETHOD.

  METHOD get_buffer.
    buffer = mv_buffer.
  ENDMETHOD.

  METHOD uccp.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD reset.
    CLEAR mv_buffer.
  ENDMETHOD.

  METHOD convert.
* todo, input parameter "N" not handled

    WRITE '@KERNEL let result = Buffer.from(data.get(), this.mv_js_encoding.get()).toString("hex");'.
    WRITE '@KERNEL buffer.set(result.toUpperCase());'.
  ENDMETHOD.
ENDCLASS.