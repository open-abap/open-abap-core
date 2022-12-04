CLASS cl_abap_gzip DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS decompress_binary
      IMPORTING
        gzip_in     TYPE xstring
      EXPORTING
        raw_out     TYPE xstring
        raw_out_len TYPE i.

    CLASS-METHODS compress_binary
      IMPORTING
        compress_level TYPE i OPTIONAL
        raw_in         TYPE xstring
      EXPORTING
        gzip_out       TYPE xstring
        gzip_out_len   TYPE i.

    CLASS-METHODS decompress_text
      IMPORTING
        gzip_in     TYPE xsequence
        gzip_in_len TYPE i DEFAULT -1
        conversion  TYPE abap_encod DEFAULT 'DEFAULT'
      EXPORTING
        text_out     TYPE csequence
        text_out_len TYPE i
      RAISING
        cx_parameter_invalid_range
        cx_sy_buffer_overflow
        cx_sy_conversion_codepage
        cx_sy_compression_error.

    CLASS-METHODS compress_text
      IMPORTING
        text_in TYPE csequence
        text_in_len TYPE i DEFAULT -1
        compress_level TYPE i DEFAULT 6
        conversion TYPE abap_encod DEFAULT 'DEFAULT'
      EXPORTING
        gzip_out TYPE xsequence
        gzip_out_len TYPE i
      RAISING
        cx_parameter_invalid_range
        cx_sy_buffer_overflow
        cx_sy_conversion_codepage
        cx_sy_compression_error.
ENDCLASS.

CLASS cl_abap_gzip IMPLEMENTATION.
  METHOD decompress_text.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD compress_text.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD decompress_binary.
    WRITE '@KERNEL const zlib = await import("zlib");'.
    WRITE '@KERNEL const buf = Buffer.from(gzip_in.get(), "hex");'.
    WRITE '@KERNEL const decompress = zlib.inflateRawSync(buf).toString("hex").toUpperCase();'.

    WRITE '@KERNEL raw_out.set(decompress);'.
    raw_out_len = xstrlen( raw_out ).
  ENDMETHOD.

  METHOD compress_binary.
* todo, input parameter COMPRESS_LEVEL corresponds to "level" in "options" for Node?
    WRITE '@KERNEL const zlib = await import("zlib");'.
    WRITE '@KERNEL const buf = Buffer.from(raw_in.get(), "hex");'.
    WRITE '@KERNEL const gzi = zlib.deflateRawSync(buf).toString("hex").toUpperCase();'.

    WRITE '@KERNEL gzip_out.set(gzi);'.
    gzip_out_len = xstrlen( gzip_out ).
  ENDMETHOD.
ENDCLASS.