CLASS cl_abap_conv_in_ce DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      create
        IMPORTING
          encoding TYPE string DEFAULT 'UTF-8'
          input TYPE xstring OPTIONAL
        RETURNING
          VALUE(ret) TYPE REF TO cl_abap_conv_in_ce.
    METHODS
      convert
        IMPORTING
          input TYPE xstring
          n     TYPE i
        EXPORTING
          data  TYPE string.
    METHODS
      read
        IMPORTING
          n     TYPE i
        EXPORTING
          data  TYPE string.
  PRIVATE SECTION.
    DATA mv_input TYPE xstring.
ENDCLASS.

CLASS cl_abap_conv_in_ce IMPLEMENTATION.
  METHOD create.
    ASSERT encoding = 'UTF-8'.
    CREATE OBJECT ret.
    ret->mv_input = input.
  ENDMETHOD.

  METHOD convert.
    IF input IS INITIAL.
      RETURN.
    ENDIF.
    WRITE '@KERNEL let arr = new Uint8Array(input.get().match(/.{1,2}/g).map(byte => parseInt(byte, 16)));'.
    WRITE '@KERNEL let res = new TextDecoder("utf-8").decode(arr);'.
    WRITE '@KERNEL data.set(res);'.
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