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

    TYPES ty_char2 TYPE c LENGTH 2.

    CLASS-METHODS uccpi
      IMPORTING
        uccp        TYPE i
      RETURNING
        VALUE(char) TYPE ty_char2.

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

    lv_hex = uccp.
    " switch to little endian
    CONCATENATE lv_hex+1(1) lv_hex(1) INTO lv_hex IN BYTE MODE.

    lo_in = create( encoding = '4103' ).

    lo_in->convert(
      EXPORTING
        input = lv_hex
      IMPORTING
        data  = char ).
  ENDMETHOD.

  METHOD convert.
    DATA lv_error TYPE abap_bool.
    DATA encoding LIKE mv_js_encoding.
    DATA ignore_cerr LIKE mv_ignore_cerr.

    ASSERT mv_js_encoding IS NOT INITIAL.
    WRITE '@KERNEL let buf = Buffer.from(input.get(), "hex");'.

    " workaround # js private
    encoding = mv_js_encoding.
    ignore_cerr = mv_ignore_cerr.

    " Try TextDecoder first, if it runs in browser,
    WRITE '@KERNEL const decoder = TextDecoder || await import("util").TextDecoder;'.
* https://stackoverflow.com/questions/62334608/textdecoder-prototype-ignorebom-not-working-as-expected
    WRITE '@KERNEL const td = new decoder(encoding.get(), {fatal: ignore_cerr.get() !== "X", ignoreBOM: true});'.
    WRITE '@KERNEL try {'.
    " WRITE '@KERNEL   console.dir(buf);'.
    WRITE '@KERNEL   data.set(td.decode(buf));'.
    " WRITE '@KERNEL   console.dir(td.decode(buf).charCodeAt( 0 ));'.
    WRITE '@KERNEL } catch (e) {'.
*    WRITE '@KERNEL   console.dir(e);'.
*    WRITE '@KERNEL   console.dir(this.mv_js_encoding.get());'.
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