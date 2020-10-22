CLASS cl_abap_conv_out_ce DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      create
        IMPORTING encoding TYPE string
        RETURNING VALUE(ret) TYPE REF TO cl_abap_conv_out_ce.
    METHODS
      convert
        IMPORTING data TYPE string
        EXPORTING buffer TYPE xstring.
ENDCLASS.

CLASS cl_abap_conv_out_ce IMPLEMENTATION.
  METHOD create.
    ASSERT encoding = 'UTF-8'.
    CREATE OBJECT ret.
  ENDMETHOD.

  METHOD convert.
    WRITE '@KERNEL let arr = new TextEncoder("utf-8").encode(data.get());'.
    WRITE '@KERNEL let result = arr.reduce(function(acc, i) { return acc + ("0" + i.toString(16)).slice(-2); }, "");'.
    WRITE '@KERNEL buffer.set(result);'.
  ENDMETHOD.
ENDCLASS.