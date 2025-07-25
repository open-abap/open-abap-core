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
          char       TYPE clike
        RETURNING
          VALUE(ret) TYPE i.

    TYPES hex02 TYPE x LENGTH 2.
    CLASS-METHODS uccp
      IMPORTING
        char        TYPE clike
      RETURNING
        VALUE(uccp) TYPE hex02
      RAISING
        cx_sy_conversion_codepage
        cx_sy_codepage_converter_init
        cx_parameter_invalid_range.

    METHODS
      convert
        IMPORTING
          data   TYPE simple
          n      TYPE i OPTIONAL
        EXPORTING
          buffer TYPE xstring.

    METHODS write
      IMPORTING
        data TYPE any.

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
        data   = char
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
    DATA lv_char TYPE c LENGTH 1.
    DATA lo_obj  TYPE REF TO cl_abap_conv_out_ce.

    lv_char = char(1).
    lo_obj = create( encoding = '4103' ).

    lo_obj->convert( EXPORTING data = lv_char
                     IMPORTING buffer = uccp ).

    SHIFT uccp LEFT CIRCULAR IN BYTE MODE.
  ENDMETHOD.

  METHOD reset.
    CLEAR mv_buffer.
  ENDMETHOD.

  METHOD convert.
    DATA lv_str   TYPE string.
    DATA encoding LIKE mv_js_encoding.

    " workaround private # fields in js
    encoding = mv_js_encoding.

    WRITE '@KERNEL let result = "";'.
*    WRITE '@KERNEL console.dir(n);'.
    IF n IS SUPPLIED.
      lv_str = data.
      lv_str = lv_str(n).
      WRITE '@KERNEL result = Buffer.from(lv_str.get(), encoding.get()).toString("hex");'.
    ELSE.
      WRITE '@KERNEL result = Buffer.from(data.get(), encoding.get()).toString("hex");'.
    ENDIF.

    WRITE '@KERNEL buffer.set(result.toUpperCase());'.
  ENDMETHOD.
ENDCLASS.