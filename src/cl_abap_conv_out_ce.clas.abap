CLASS cl_abap_conv_out_ce DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      create
        IMPORTING
          encoding    TYPE abap_encoding
          ignore_cerr TYPE abap_bool DEFAULT abap_false
        RETURNING
          VALUE(ret)  TYPE REF TO cl_abap_conv_out_ce.
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
  PRIVATE SECTION.
    DATA mv_js_encoding TYPE string.
ENDCLASS.

CLASS cl_abap_conv_out_ce IMPLEMENTATION.
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
  ENDMETHOD.

  METHOD write.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_buffer.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD convert.
* todo, input parameter "N" not handled

    WRITE '@KERNEL let result = Buffer.from(data.get(), this.mv_js_encoding.get()).toString("hex");'.
    WRITE '@KERNEL buffer.set(result.toUpperCase());'.
  ENDMETHOD.
ENDCLASS.