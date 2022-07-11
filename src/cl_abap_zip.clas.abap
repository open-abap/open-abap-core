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
* todo
    RETURN.
  ENDMETHOD.

  METHOD load.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD save.
    DATA lo_stream TYPE REF TO lcl_stream.
    CREATE OBJECT lo_stream.

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
* todo
* 18, 4, Compressed size (or 0xffffffff for ZIP64)
* 22, 4, Uncompressed size (or 0xffffffff for ZIP64)
* 26, 2, File name length (n)
* 28, 2, Extra field length (m)
* 30, n, File name
* 30+n, m, Extra field

    val = lo_stream->get( ).
  ENDMETHOD.

ENDCLASS.