CLASS cl_abap_zip DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS add
      IMPORTING
        name TYPE string
        content TYPE xstring.

    METHODS save RETURNING VALUE(val) TYPE xstring.

    METHODS load IMPORTING zip TYPE xstring.

    METHODS get
      IMPORTING name TYPE string
      EXPORTING content TYPE xstring.

    CLASS-METHODS crc32
      IMPORTING content TYPE xstring
      RETURNING VALUE(crc) TYPE i.

    TYPES: BEGIN OF t_file,
             name TYPE string,
           END OF t_file.
    TYPES t_files TYPE STANDARD TABLE OF t_file WITH DEFAULT KEY.
    DATA files TYPE t_files.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_contents,
             name          TYPE string,
             original_size TYPE i,
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

  METHOD get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD add.
    DATA ls_contents LIKE LINE OF mt_contents.
    ls_contents-name = name.
    ls_contents-original_size = xstrlen( content ).
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
    DATA lo_stream TYPE REF TO lcl_stream.
    DATA ls_contents LIKE LINE OF mt_contents.

    CREATE OBJECT lo_stream.

    LOOP AT mt_contents INTO ls_contents.
* 0, 4, Local file header signature
      lo_stream->append( '504B0304' ).
* 4, 2, Version needed to extract (minimum)
      lo_stream->append( '1400' ).
* 6, 2, General purpose bit flag
      lo_stream->append( '0000' ).
* 8, 2, Compression method; e.g. none = 0, DEFLATE = 8 (or "\0x08\0x00")
      lo_stream->append( '0800' ).
* 10, 2, File last modification time
      lo_stream->append( '0000' ). "lo_stream->append_time( sy-uzeit ).
* 12, 2, File last modification date
      lo_stream->append( '0000' ). "lo_stream->append_date( sy-datum ).
* 14, 4, CRC-32 of uncompressed data
      lo_stream->append_crc( ls_contents-content ).
* 18, 4, Compressed size (or 0xffffffff for ZIP64)
      lo_stream->append_int4( xstrlen( ls_contents-compressed ) ).
* 22, 4, Uncompressed size (or 0xffffffff for ZIP64)
      lo_stream->append_int4( xstrlen( ls_contents-content ) ).
* 26, 2, File name length (n)
      lo_stream->append_int2( strlen( ls_contents-name ) ).
* 28, 2, Extra field length (m)
      lo_stream->append( '0000' ).
* 30, n, File name
* TODO
* 30+n, m, Extra field
* TODO
    ENDLOOP.

    val = lo_stream->get( ).
  ENDMETHOD.

ENDCLASS.