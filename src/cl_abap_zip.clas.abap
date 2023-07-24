CLASS cl_abap_zip DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS add
      IMPORTING
        name TYPE string
        content TYPE xstring.

    METHODS save
      RETURNING
        VALUE(val) TYPE xstring.

    METHODS load
      IMPORTING
        zip TYPE xstring.

    METHODS get
      IMPORTING
        name TYPE string
      EXPORTING
        content TYPE xstring.

    METHODS delete
      IMPORTING
        name  TYPE string OPTIONAL
        index TYPE i DEFAULT 0
      EXCEPTIONS
        zip_index_error.

    CLASS-METHODS crc32
      IMPORTING content TYPE xstring
      RETURNING VALUE(crc) TYPE i.

    TYPES: BEGIN OF t_file,
             name TYPE string,
             size TYPE i,
           END OF t_file.
    TYPES t_files TYPE STANDARD TABLE OF t_file WITH DEFAULT KEY.
    DATA files TYPE t_files.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_contents,
             name          TYPE string,
* todo, optimize memory usage, dont store both compressed and original,
             content       TYPE xstring,
             compressed    TYPE xstring,
           END OF ty_contents.
    DATA mt_contents TYPE STANDARD TABLE OF ty_contents WITH DEFAULT KEY.

ENDCLASS.

CLASS cl_abap_zip IMPLEMENTATION.

  METHOD crc32.
    DATA lo_stream TYPE REF TO lcl_stream.
    CREATE OBJECT lo_stream.
    crc = lo_stream->append_crc( content ).
  ENDMETHOD.

  METHOD delete.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get.
    DATA ls_length   TYPE i.
    DATA ls_contents LIKE LINE OF mt_contents.

    READ TABLE mt_contents WITH KEY name = name INTO ls_contents.
    cl_abap_gzip=>decompress_binary(
      EXPORTING
        gzip_in = ls_contents-compressed
      IMPORTING
        raw_out = content
        raw_out_len = ls_length ).
  ENDMETHOD.

  METHOD add.
    DATA ls_contents LIKE LINE OF mt_contents.

    ls_contents-name = name.
    ls_contents-content = content.
    cl_abap_gzip=>compress_binary(
      EXPORTING
        raw_in   = content
      IMPORTING
        gzip_out = ls_contents-compressed ).
    INSERT ls_contents INTO TABLE mt_contents.
  ENDMETHOD.

  METHOD load.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD save.
* https://en.wikipedia.org/wiki/ZIP_(file_format)
* https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT

    DATA lo_total    TYPE REF TO lcl_stream.
    DATA lo_file     TYPE REF TO lcl_stream.
    DATA lo_central  TYPE REF TO lcl_stream.
    DATA ls_contents LIKE LINE OF mt_contents.
    DATA lv_buffer   TYPE xstring.
    DATA lv_tmp      TYPE xstring.
    DATA lv_start    TYPE i.
    DATA lo_conv     TYPE REF TO cl_abap_conv_out_ce.

    CREATE OBJECT lo_central.
    CREATE OBJECT lo_total.
    lo_conv = cl_abap_conv_out_ce=>create( ).

    LOOP AT mt_contents INTO ls_contents.
      lo_conv->convert( EXPORTING data = ls_contents-name
                        IMPORTING buffer = lv_buffer ).

****************************************
* LOCAL FILE RECORD
      CREATE OBJECT lo_file.
* 0, 4, Local file header signature
      lo_file->append( '504B0304' ).
* 4, 2, Version needed to extract (minimum)
      lo_file->append( '1400' ).
* 6, 2, General purpose bit flag
      lo_file->append( '0000' ).
* 8, 2, Compression method; e.g. none = 0, DEFLATE = 8 (or "0x08 0x00")
      lo_file->append( '0800' ).
* 10, 2, File last modification time
      lo_file->append( '0699' ). "lo_stream->append_time( sy-uzeit ).
* 12, 2, File last modification date
      lo_file->append( 'F856' ). "lo_stream->append_date( sy-datum ).
* 14, 4, CRC-32 of uncompressed data
      lo_file->append_crc( ls_contents-content ).
* 18, 4, Compressed size (or 0xffffffff for ZIP64)
      lo_file->append_int4( xstrlen( ls_contents-compressed ) ).
* 22, 4, Uncompressed size (or 0xffffffff for ZIP64)
      lo_file->append_int4( xstrlen( ls_contents-content ) ).
* 26, 2, File name length (n)
      lo_file->append_int2( xstrlen( lv_buffer ) ).
* 28, 2, Extra field length (m)
      lo_file->append( '0000' ).
* 30, n, File name
      lo_file->append( lv_buffer ).
* 30+n, m, Extra field
* empty
* compressed data,
      lo_file->append( ls_contents-compressed ).

****************************************
* CENTRAL DIRECTORY FILE RECORD
* 0, 4, Central directory file header signature = 0x02014b50
      lo_central->append( '504B0102' ).
* 4, 2, Version made by
      lo_central->append( '1400' ).

* 6, 2, Version needed to extract (minimum)
* 8, 2, General purpose bit flag
* 10, 2, Compression method
* 12, 2, File last modification time
* 14, 2, File last modification date
* 16, 4, CRC-32 of uncompressed data
* 20, 4, Compressed size (or 0xffffffff for ZIP64)
* 24, 4, Uncompressed size (or 0xffffffff for ZIP64)
* 28, 2, File name length (n)
* 30, 2, Extra field length (m)
      lv_tmp = lo_file->get( ).
      lo_central->append( lv_tmp+4(26) ).

* 32, 2, File comment length (k)
      lo_central->append_int2( 0 ).
* 34, 2, Disk number where file starts (or 0xffff for ZIP64)
      lo_central->append_int2( 0 ).
* 36, 2, Internal file attributes
      lo_central->append_int2( 0 ).
* 38, 4, External file attributes
      lo_central->append_int4( 0 ).
* 42, 4, Relative offset of local file header (or 0xffffffff for ZIP64). This is the number of bytes between the start of the first disk on which the file occurs, and the start of the local file header. This allows software reading the central directory to locate the position of the file inside the ZIP file.
      lo_central->append_int4( xstrlen( lo_total->get( ) ) ).
* 46, n, File name
      lo_central->append( lv_buffer ).

      lo_total->append( lo_file->get( ) ).
    ENDLOOP.

    lv_start = xstrlen( lo_total->get( ) ).
    lo_total->append( lo_central->get( ) ).

****************************************
* END OF CENTRAL DIRECTORY
* 0, 4, End of central directory signature = 0x06054b50
    lo_total->append( '504B0506' ).
* 4, 2, Number of this disk (or 0xffff for ZIP64)
    lo_total->append_int2( 0 ).
* 6, 2, Disk where central directory starts (or 0xffff for ZIP64)
    lo_total->append_int2( 0 ).
* 8, 2, Number of central directory records on this disk (or 0xffff for ZIP64)
    lo_total->append_int2( lines( mt_contents ) ).
* 10, 2, Total number of central directory records (or 0xffff for ZIP64)
    lo_total->append_int2( lines( mt_contents ) ).
* 12, 4, Size of central directory (bytes) (or 0xffffffff for ZIP64)
    lo_total->append_int4( xstrlen( lo_central->get( ) ) ).
* 16, 4, Offset of start of central directory, relative to start of archive (or 0xffffffff for ZIP64)
    lo_total->append_int4( lv_start ).
* 20, 2, Comment length (n)
    lo_total->append_int2( 0 ).
* 22, n, Comment
* empty

    val = lo_total->get( ).
  ENDMETHOD.

ENDCLASS.