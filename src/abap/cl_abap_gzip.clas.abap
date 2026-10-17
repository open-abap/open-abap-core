CLASS cl_abap_gzip DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS decompress_binary
      IMPORTING
        gzip_in     TYPE xstring
      EXPORTING
        raw_out     TYPE xstring
        raw_out_len TYPE i
      RAISING
        cx_sy_compression_error.

    CLASS-METHODS compress_binary
      IMPORTING
        compress_level TYPE i OPTIONAL
        raw_in         TYPE xstring
      EXPORTING
        gzip_out       TYPE xstring
        gzip_out_len   TYPE i.

    CLASS-METHODS decompress_text
      IMPORTING
        gzip_in      TYPE xsequence
        gzip_in_len  TYPE i DEFAULT -1
        conversion   TYPE abap_encod DEFAULT 'DEFAULT'
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
        text_in        TYPE csequence
        text_in_len    TYPE i DEFAULT -1
        compress_level TYPE i DEFAULT 6
        conversion     TYPE abap_encod DEFAULT 'DEFAULT'
      EXPORTING
        gzip_out       TYPE xsequence
        gzip_out_len   TYPE i
      RAISING
        cx_parameter_invalid_range
        cx_sy_buffer_overflow
        cx_sy_conversion_codepage
        cx_sy_compression_error.

    CLASS-METHODS compress_binary_with_header
      IMPORTING
        raw_in         TYPE xstring
        compress_level TYPE i DEFAULT 6
      EXPORTING
        gzip_out       TYPE xstring
      RAISING
        cx_parameter_invalid_range
        cx_sy_buffer_overflow
        cx_sy_compression_error.

    CLASS-METHODS decompress_binary_with_header
      IMPORTING
        gzip_in TYPE xstring
      EXPORTING
        raw_out TYPE xstring
      RAISING
        cx_parameter_invalid
        cx_sy_buffer_overflow
        cx_sy_compression_error.
ENDCLASS.

CLASS cl_abap_gzip IMPLEMENTATION.
  METHOD decompress_binary_with_header.
* with gzip RFC 1952 header
    DATA lv_failed TYPE abap_bool.
    WRITE '@KERNEL const zlib = await import("zlib");'.
    WRITE '@KERNEL const buf = Buffer.from(gzip_in.get(), "hex");'.
    WRITE '@KERNEL let decompress = "";'.
    WRITE '@KERNEL try { decompress = zlib.gunzipSync(buf).toString("hex").toUpperCase(); } catch (e) { lv_failed.set("X"); }'.
    IF lv_failed = abap_true.
      RAISE EXCEPTION TYPE cx_sy_compression_error.
    ENDIF.

    WRITE '@KERNEL raw_out.set(decompress);'.
  ENDMETHOD.

  METHOD compress_binary_with_header.
* with gzip RFC 1952 header
    IF compress_level < 0 OR compress_level > 9.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range.
    ENDIF.
    WRITE '@KERNEL const zlib = await import("zlib");'.
    WRITE '@KERNEL const buf = Buffer.from(raw_in.get(), "hex");'.
    WRITE '@KERNEL const gzi = zlib.gzipSync(buf, {level: compress_level.get()}).toString("hex").toUpperCase();'.

    CLEAR gzip_out.
    WRITE '@KERNEL gzip_out.set(gzi);'.
  ENDMETHOD.

  METHOD decompress_text.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD compress_text.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD decompress_binary.
    DATA lv_failed TYPE abap_bool.
    WRITE '@KERNEL const zlib = await import("zlib");'.
    WRITE '@KERNEL const buf = Buffer.from(gzip_in.get(), "hex");'.
    WRITE '@KERNEL let decompress = "";'.
    WRITE '@KERNEL try { decompress = zlib.inflateRawSync(buf, {finishFlush: zlib.constants.Z_SYNC_FLUSH}).toString("hex").toUpperCase(); } catch (e) { lv_failed.set("X"); }'.
    IF lv_failed = abap_true.
      RAISE EXCEPTION TYPE cx_sy_compression_error.
    ENDIF.

    CLEAR raw_out.
    WRITE '@KERNEL raw_out.set(decompress);'.
    raw_out_len = xstrlen( raw_out ).
  ENDMETHOD.

  METHOD compress_binary.
* COMPRESS_LEVEL is the zlib level, 0 stores, 9 compresses best, initial is the default 6
    DATA lv_level TYPE i.
    lv_level = compress_level.
    IF compress_level IS NOT SUPPLIED.
      lv_level = 6.
    ENDIF.
    WRITE '@KERNEL const zlib = await import("zlib");'.
    WRITE '@KERNEL const buf = Buffer.from(raw_in.get(), "hex");'.
    WRITE '@KERNEL const gzi = zlib.deflateRawSync(buf, {level: lv_level.get()}).toString("hex").toUpperCase();'.

    CLEAR gzip_out.
    WRITE '@KERNEL gzip_out.set(gzi);'.
    gzip_out_len = xstrlen( gzip_out ).
  ENDMETHOD.
ENDCLASS.
