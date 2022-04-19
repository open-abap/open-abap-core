CLASS cl_abap_conv_in_ce DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      create
        IMPORTING
          encoding TYPE abap_encoding DEFAULT 'UTF-8'
          input TYPE xstring OPTIONAL
        RETURNING
          VALUE(ret) TYPE REF TO cl_abap_conv_in_ce.
    CLASS-METHODS
      uccpi
        IMPORTING
          value TYPE i
        RETURNING
          VALUE(ret) TYPE string.
    METHODS
      convert
        IMPORTING
          input TYPE xstring
          n     TYPE i OPTIONAL
        EXPORTING
          data  TYPE string.
    METHODS
      read
        IMPORTING
          n     TYPE i OPTIONAL
        EXPORTING
          data  TYPE string.
  PRIVATE SECTION.
    DATA mv_input TYPE xstring.
    DATA mv_js_encoding TYPE string.
ENDCLASS.

CLASS cl_abap_conv_in_ce IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT ret.

    CASE encoding.
      WHEN 'UTF-8'.
        ret->mv_js_encoding = 'utf8'.
      WHEN '4103'.
        ret->mv_js_encoding = 'utf16le'.
      WHEN OTHERS.
        ASSERT 1 = 'not supported'.
    ENDCASE.

    ret->mv_input = input.
  ENDMETHOD.

  METHOD uccpi.
    DATA lv_hex TYPE x LENGTH 2.
    DATA lo_in TYPE REF TO cl_abap_conv_in_ce.

    lv_hex(1) = value MOD 255.
    lv_hex+1(1) = value DIV 255.

    lo_in = create( encoding = '4103' ).

    lo_in->convert(
      EXPORTING
        input = lv_hex
      IMPORTING
        data  = ret ).
  ENDMETHOD.

  METHOD convert.
    IF input IS INITIAL.
      RETURN.
    ENDIF.
    ASSERT mv_js_encoding IS NOT INITIAL.
    WRITE '@KERNEL let result = Buffer.from(input.get(), "hex").toString(this.mv_js_encoding.get());'.
    WRITE '@KERNEL data.set(result);'.
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