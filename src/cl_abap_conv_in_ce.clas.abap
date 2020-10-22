CLASS cl_abap_conv_in_ce DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      create
        IMPORTING
          encoding TYPE string
        RETURNING
          VALUE(ret) TYPE REF TO cl_abap_conv_in_ce.
    METHODS
      convert
        IMPORTING
          input TYPE string
          n     TYPE i
        EXPORTING
          data  TYPE xstring.
ENDCLASS.

CLASS cl_abap_conv_in_ce IMPLEMENTATION.
  METHOD create.
    ASSERT encoding = 'UTF-8'.
    CREATE OBJECT ret.
  ENDMETHOD.

  METHOD convert.
    WRITE '@KERNEL let arr = new Uint8Array(input.get().match(/.{1,2}/g).map(byte => parseInt(byte, 16)));'.
    WRITE '@KERNEL let res = new TextDecoder("utf-8").decode(arr);'.
    WRITE '@KERNEL data.set(res);'.
  ENDMETHOD.
ENDCLASS.