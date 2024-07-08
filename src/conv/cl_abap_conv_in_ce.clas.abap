CLASS cl_abap_conv_in_ce DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      create
        IMPORTING
          encoding    TYPE abap_encoding DEFAULT 'UTF-8'
          input       TYPE xstring OPTIONAL
          replacement TYPE char1 DEFAULT '#'
          ignore_cerr TYPE abap_bool DEFAULT abap_false
          endian      TYPE char1 OPTIONAL
        RETURNING
          VALUE(ret)  TYPE REF TO cl_abap_conv_in_ce.

    CLASS-METHODS
      uccpi
        IMPORTING
          value      TYPE i
        RETURNING
          VALUE(ret) TYPE string.

    TYPES ty_char2 TYPE c LENGTH 2.
    CLASS-METHODS uccp
      IMPORTING
        uccp        TYPE simple
      RETURNING
        VALUE(char) TYPE ty_char2.

    METHODS convert
      IMPORTING
        input TYPE xsequence
        n     TYPE i OPTIONAL
      EXPORTING
        data  TYPE string.

    METHODS read
      IMPORTING
        n    TYPE i OPTIONAL
      EXPORTING
        data TYPE string.
  PRIVATE SECTION.
    DATA mv_input TYPE xstring.
    DATA mv_js_encoding TYPE string.
    DATA mv_ignore_cerr TYPE abap_bool.
ENDCLASS.

CLASS cl_abap_conv_in_ce IMPLEMENTATION.
  METHOD create.
    ASSERT replacement = '#'. " todo
    ASSERT endian IS INITIAL. " todo

    CREATE OBJECT ret.

    CASE encoding.
      WHEN 'UTF-16'.
        ret->mv_js_encoding = 'utf-16le'.
      WHEN 'UTF-8'.
        ret->mv_js_encoding = 'utf8'.
      WHEN '4103'.
        ret->mv_js_encoding = 'utf-16le'.
      WHEN OTHERS.
        ASSERT 1 = 'not supported'.
    ENDCASE.

    ret->mv_input = input.
    ret->mv_ignore_cerr = ignore_cerr.
  ENDMETHOD.

  METHOD uccp.
    DATA int TYPE i.
    DATA hex TYPE x LENGTH 2.
    hex = uccp.
    int = hex.
    TRY.
        char = uccpi( int ).
      CATCH cx_sy_conversion_codepage.
* todo, hmm
    ENDTRY.
  ENDMETHOD.

  METHOD uccpi.
    DATA lv_hex TYPE x LENGTH 2.
    DATA lo_in  TYPE REF TO cl_abap_conv_in_ce.

    lv_hex = value.
    " switch to little endian
    CONCATENATE lv_hex+1(1) lv_hex(1) INTO lv_hex IN BYTE MODE.

    lo_in = create( encoding = '4103' ).

    lo_in->convert(
      EXPORTING
        input = lv_hex
      IMPORTING
        data  = ret ).
  ENDMETHOD.

  METHOD convert.
    DATA lv_error TYPE abap_bool.

    ASSERT mv_js_encoding IS NOT INITIAL.
    WRITE '@KERNEL let buf = Buffer.from(input.get(), "hex");'.

    " Try TextDecoder first, if it runs in browser,
    WRITE '@KERNEL const decoder = TextDecoder || await import("util").TextDecoder;'.
    WRITE '@KERNEL const td = new decoder(this.mv_js_encoding.get(), {fatal: this.mv_ignore_cerr.get() !== "X"});'.
    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   data.set(td.decode(buf));'.
    WRITE '@KERNEL } catch {'.
    lv_error = abap_true.
    WRITE '@KERNEL }'.

    IF lv_error = abap_true.
      RAISE EXCEPTION TYPE cx_sy_conversion_codepage.
    ENDIF.

* old    WRITE '@KERNEL let result = buf.toString(this.mv_js_encoding.get());'.
* old    WRITE '@KERNEL data.set(result);'.
  ENDMETHOD.

  METHOD read.
    convert(
      EXPORTING
        input = mv_input
        n     = n
      IMPORTING
        data  = data ).
  ENDMETHOD.

ENDCLASS.