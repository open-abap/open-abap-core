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
* todo, this doesnt work in browser?
    WRITE '@KERNEL const zlib = await import("zlib");'.
    WRITE '@KERNEL const buf = Buffer.from(gzip_in.get(), "hex");'.
    WRITE '@KERNEL const decompress = zlib.inflateRawSync(buf).toString("hex").toUpperCase();'.

    WRITE '@KERNEL raw_out.set(decompress);'.
    raw_out_len = xstrlen( raw_out ).
  ENDMETHOD.

  METHOD compress_binary.
* todo, this doesnt work in browser?
    WRITE '@KERNEL const zlib = await import("zlib");'.
    WRITE '@KERNEL const buf = Buffer.from(raw_in.get(), "hex");'.
    WRITE '@KERNEL const gzi = zlib.deflateRawSync(buf).toString("hex").toUpperCase();'.

    WRITE '@KERNEL gzip_out.set(gzi);'.
    gzip_out_len = xstrlen( gzip_out ).
  ENDMETHOD.
ENDCLASS.