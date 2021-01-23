CLASS cl_abap_gzip DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS:
      decompress_binary
        IMPORTING
          gzip_in TYPE xstring
        EXPORTING
          raw_out TYPE xstring
          raw_out_len TYPE i.
    CLASS-METHODS:
      compress_binary
        IMPORTING
          raw_in TYPE xstring
        EXPORTING
          gzip_out TYPE xstring
          gzip_out_len TYPE i.
ENDCLASS.

CLASS cl_abap_gzip IMPLEMENTATION.
  METHOD decompress_binary.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD compress_binary.
    ASSERT 2 = 'todo'.
  ENDMETHOD.
ENDCLASS.