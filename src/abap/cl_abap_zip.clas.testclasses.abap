CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_index FOR TESTING.
    METHODS delete_index FOR TESTING.
    METHODS invalid_index FOR TESTING.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS get FOR TESTING RAISING cx_static_check.
    METHODS delete FOR TESTING RAISING cx_static_check.
    METHODS get_missing FOR TESTING RAISING cx_static_check.
    METHODS crc FOR TESTING RAISING cx_static_check.
    METHODS crc_check_values FOR TESTING RAISING cx_static_check.
    METHODS save FOR TESTING RAISING cx_static_check.
    METHODS load FOR TESTING RAISING cx_static_check.
    METHODS load_save FOR TESTING RAISING cx_static_check.
    METHODS load_stored FOR TESTING RAISING cx_static_check.
    METHODS load_data_descriptor FOR TESTING RAISING cx_static_check.
    METHODS read_int4 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_index.
    DATA lo_zip TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'first'
                 content = '41' ).
    lo_zip->add( name    = 'last'
                 content = '42' ).
    lo_zip->get( EXPORTING index = 1 IMPORTING content = lv_content ).
    cl_abap_unit_assert=>assert_equals( act = lv_content
                                        exp = '41' ).
    lo_zip->get( EXPORTING index = 2 IMPORTING content = lv_content ).
    cl_abap_unit_assert=>assert_equals( act = lv_content
                                        exp = '42' ).
  ENDMETHOD.

  METHOD delete_index.
    DATA lo_zip TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.
    DATA lv_saved TYPE xstring.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'first'
                 content = '41' ).
    lo_zip->add( name    = 'middle'
                 content = '42' ).
    lo_zip->add( name    = 'last'
                 content = '43' ).
    lv_saved = lo_zip->save( ).
    lo_zip->load( lv_saved ).
    lo_zip->delete( index = 2 ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_zip->files )
                                        exp = 2 ).
    lo_zip->get( EXPORTING index = 2 IMPORTING content = lv_content ).
    cl_abap_unit_assert=>assert_equals( act = lv_content
                                        exp = '43' ).
    lo_zip->delete( index = 2 ).
    lo_zip->delete( index = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_zip->files )
                                        exp = 0 ).
    lo_zip->get( EXPORTING name = 'first' EXCEPTIONS zip_index_error = 1 ).
    cl_abap_unit_assert=>assert_equals( act = sy-subrc
                                        exp = 1 ).
  ENDMETHOD.

  METHOD invalid_index.
    DATA lo_zip TYPE REF TO cl_abap_zip.
    DATA lv_index TYPE i.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'first'
                 content = '41' ).
    DO 3 TIMES.
      CASE sy-index.
        WHEN 1.
          lv_index = -1.
        WHEN 2.
          lv_index = 0.
        WHEN 3.
          lv_index = 2.
      ENDCASE.
      lo_zip->get( EXPORTING index = lv_index EXCEPTIONS zip_index_error = 1 ).
      cl_abap_unit_assert=>assert_equals( act = sy-subrc
                                          exp = 1 ).
      lo_zip->delete( EXPORTING index = lv_index EXCEPTIONS zip_index_error = 1 ).
      cl_abap_unit_assert=>assert_equals( act = sy-subrc
                                          exp = 1 ).
    ENDDO.
  ENDMETHOD.

  METHOD crc.
    DATA lv_crc TYPE i.
    lv_crc = cl_abap_zip=>crc32( '1122334455' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_crc
      exp = 950032937 ).
  ENDMETHOD.

  METHOD crc_check_values.
* inputs of 0, 1, 3, 4 and 9 bytes: every remainder after whole 4-byte words
    DATA lv_empty TYPE xstring.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_zip=>crc32( lv_empty )
      exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_zip=>crc32( '61' )
      exp = -390611389 ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_zip=>crc32( '616263' )
      exp = 891568578 ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_zip=>crc32( '61626364' )
      exp = -310194927 ).
* "123456789", the CRC-32 check value CBF43926
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_zip=>crc32( '313233343536373839' )
      exp = -873187034 ).
  ENDMETHOD.

  METHOD test1.
    DATA lo_zip     TYPE REF TO cl_abap_zip.
    DATA lv_res     TYPE xstring.
    DATA lv_sub     TYPE xstring.
    DATA lv_content TYPE xstring.

    lv_content = '1122334455667788AABBCCDDEEFF'.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'foobar'
                 content = lv_content ).
    lv_res = lo_zip->save( ).
    lv_sub = lv_res(4).
* https://en.wikipedia.org/wiki/ZIP_(file_format)
    cl_abap_unit_assert=>assert_equals(
      act = lv_sub
      exp = '504B0304' ).
  ENDMETHOD.

  METHOD get.
    DATA lo_zip     TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.
    DATA lv_act     TYPE xstring.

    lv_content = '1122334455667788AABBCCDDEEFF'.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'foobar'
                 content = lv_content ).
    lo_zip->get( EXPORTING name    = 'foobar'
                 IMPORTING content = lv_act ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_act
      exp = lv_content ).
  ENDMETHOD.

  METHOD save.
    DATA lo_zip     TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.
    DATA lv_save    TYPE xstring.

    lv_content = '1122334455667788AABBCCDDEEFF'.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'foobar'
                 content = lv_content ).
    lv_save = lo_zip->save( ).

    " WRITE '@KERNEL const fs = await import("fs");'.
    " WRITE '@KERNEL fs.writeFileSync("foo.zip", Buffer.from(lv_save.get().toLowerCase(), "hex"));'.

  ENDMETHOD.

  METHOD load.
    DATA lo_zip     TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.
    DATA lv_save    TYPE xstring.
    DATA lv_act     TYPE xstring.

    lv_content = '1122334455667788AABBCCDDEEFF'.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'foobar'
                 content = lv_content ).
    lv_save = lo_zip->save( ).

    CREATE OBJECT lo_zip.
    lo_zip->load( lv_save ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_zip->files )
      exp = 1 ).

    lo_zip->get( EXPORTING name    = 'foobar'
                 IMPORTING content = lv_act ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_act
      exp = lv_content ).
  ENDMETHOD.

  METHOD load_save.
* SAVE after LOAD reuses the CRC of the loaded local header
    DATA lo_zip     TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.
    DATA lv_first   TYPE xstring.
    DATA lv_second  TYPE xstring.

    lv_content = '1122334455667788AABBCCDDEEFF'.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'foo'
                 content = lv_content ).
    lo_zip->add( name    = 'bar'
                 content = lv_content ).
    lv_first = lo_zip->save( ).

    CREATE OBJECT lo_zip.
    lo_zip->load( lv_first ).
    lv_second = lo_zip->save( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_second
      exp = lv_first ).
  ENDMETHOD.

  METHOD delete.
    DATA lo_zip     TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.
    DATA lv_act     TYPE xstring.

    lv_content = '1122334455667788AABBCCDDEEFF'.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'foo'
                 content = lv_content ).
    lo_zip->add( name    = 'bar'
                 content = lv_content ).

    lo_zip->delete( EXPORTING  name            = 'foo'
                    EXCEPTIONS zip_index_error = 1
                               OTHERS          = 2 ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-subrc
      exp = 0 ).

    " deleting again raises
    lo_zip->delete( EXPORTING  name            = 'foo'
                    EXCEPTIONS zip_index_error = 1
                               OTHERS          = 2 ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-subrc
      exp = 1 ).

    " remaining entry is untouched
    lo_zip->get( EXPORTING name    = 'bar'
                 IMPORTING content = lv_act ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_act
      exp = lv_content ).
  ENDMETHOD.

  METHOD get_missing.
    DATA lo_zip     TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.

    lv_content = '1122334455667788AABBCCDDEEFF'.
    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'foobar'
                 content = lv_content ).

    lo_zip->get( EXPORTING  name            = 'sdfsdfsd'
                 EXCEPTIONS zip_index_error = 1
                            OTHERS          = 2 ).

    cl_abap_unit_assert=>assert_equals(
      act = sy-subrc
      exp = 1 ).
  ENDMETHOD.

  METHOD load_stored.
    " hand-crafted zip with a single STORED (method 0) entry:
    " file name F, payload 4142
    DATA lv_hex TYPE string.
    DATA lv_zip TYPE xstring.
    DATA lv_act TYPE xstring.
    DATA lv_exp TYPE xstring.
    DATA lo_zip TYPE REF TO cl_abap_zip.

    CONCATENATE
      `504B0304`            " local file header signature
      `1400` `0000` `0000`  " version, flags, method = STORED
      `0000` `0000`         " mod time, mod date
      `074C6930`            " crc32
      `02000000` `02000000` " compressed / uncompressed size = 2
      `0100` `0000`         " name length = 1, extra length = 0
      `46`                  " file name F
      `4142`                " stored payload
      `504B0102`            " central directory file header signature
      `1400` `1400`         " version made by, version needed
      `0000` `0000`         " flags, method = STORED
      `0000` `0000`         " mod time, mod date
      `074C6930`            " crc32
      `02000000` `02000000` " compressed / uncompressed size = 2
      `0100` `0000` `0000`  " name length = 1, extra length, comment length
      `0000` `0000`         " disk number, internal attributes
      `00000000`            " external attributes
      `00000000`            " offset of local file header
      `46`                  " file name F
      `504B0506`            " end of central directory signature
      `0000` `0000`         " disk numbers
      `0100` `0100`         " records on this disk, total records
      `2F000000`            " size of central directory = 47
      `21000000`            " offset of central directory = 33
      `0000`                " comment length
      INTO lv_hex.
    lv_zip = lv_hex.

    CREATE OBJECT lo_zip.
    lo_zip->load( lv_zip ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_zip->files )
      exp = 1 ).

    lo_zip->get( EXPORTING name    = `F`
                 IMPORTING content = lv_act ).
    lv_exp = '4142'.
    cl_abap_unit_assert=>assert_equals(
      act = lv_act
      exp = lv_exp ).
  ENDMETHOD.

  METHOD load_data_descriptor.
    " hand-crafted zip as written by LibreOffice or Java ZipOutputStream: flag bit 3 is set,
    " crc32 and sizes are 0 in the local file headers and follow the data in a data descriptor,
    " two deflated entries F = 4142 and G = 434445
    DATA lv_hex TYPE string.
    DATA lv_zip TYPE xstring.
    DATA lv_act TYPE xstring.
    DATA lv_exp TYPE xstring.
    DATA lo_zip TYPE REF TO cl_abap_zip.

    CONCATENATE
      `504B0304`            " local file header signature
      `1400` `0800` `0800`  " version, flags = bit 3, method = DEFLATE
      `0000` `0000`         " mod time, mod date
      `00000000`            " crc32 = 0
      `00000000` `00000000` " compressed / uncompressed size = 0
      `0100` `0000`         " name length = 1, extra length = 0
      `46`                  " file name F
      `73740200`            " deflated 4142
      `504B0708`            " data descriptor signature
      `074C6930`            " crc32
      `04000000` `02000000` " compressed / uncompressed size
      `504B0304`            " local file header signature
      `1400` `0800` `0800`  " version, flags = bit 3, method = DEFLATE
      `0000` `0000`         " mod time, mod date
      `00000000`            " crc32 = 0
      `00000000` `00000000` " compressed / uncompressed size = 0
      `0100` `0000`         " name length = 1, extra length = 0
      `47`                  " file name G
      `7376710500`          " deflated 434445
      `504B0708`            " data descriptor signature
      `95D53E1F`            " crc32
      `05000000` `03000000` " compressed / uncompressed size
      `504B0102`            " central directory file header signature
      `1400` `1400`         " version made by, version needed
      `0800` `0800`         " flags = bit 3, method = DEFLATE
      `0000` `0000`         " mod time, mod date
      `074C6930`            " crc32
      `04000000` `02000000` " compressed / uncompressed size
      `0100` `0000` `0000`  " name length = 1, extra length, comment length
      `0000` `0000`         " disk number, internal attributes
      `00000000`            " external attributes
      `00000000`            " offset of local file header = 0
      `46`                  " file name F
      `504B0102`            " central directory file header signature
      `1400` `1400`         " version made by, version needed
      `0800` `0800`         " flags = bit 3, method = DEFLATE
      `0000` `0000`         " mod time, mod date
      `95D53E1F`            " crc32
      `05000000` `03000000` " compressed / uncompressed size
      `0100` `0000` `0000`  " name length = 1, extra length, comment length
      `0000` `0000`         " disk number, internal attributes
      `00000000`            " external attributes
      `33000000`            " offset of local file header = 51
      `47`                  " file name G
      `504B0506`            " end of central directory signature
      `0000` `0000`         " disk numbers
      `0200` `0200`         " records on this disk, total records
      `5E000000`            " size of central directory = 94
      `67000000`            " offset of central directory = 103
      `0000`                " comment length
      INTO lv_hex.
    lv_zip = lv_hex.

    CREATE OBJECT lo_zip.
    lo_zip->load( lv_zip ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_zip->files )
      exp = 2 ).

    lo_zip->get( EXPORTING name    = `F`
                 IMPORTING content = lv_act ).
    lv_exp = '4142'.
    cl_abap_unit_assert=>assert_equals(
      act = lv_act
      exp = lv_exp ).

    lo_zip->get( EXPORTING name    = `G`
                 IMPORTING content = lv_act ).
    lv_exp = '434445'.
    cl_abap_unit_assert=>assert_equals(
      act = lv_act
      exp = lv_exp ).
  ENDMETHOD.

  METHOD read_int4.
* little endian, read as a signed i the way x LENGTH 4 converts to i
    cl_abap_unit_assert=>assert_equals(
      act = lcl_stream=>read_int4( iv_xstr = '0001000000' iv_offset = 1 )
      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = lcl_stream=>read_int4( iv_xstr = '78563412' iv_offset = 0 )
      exp = 305419896 ).
    cl_abap_unit_assert=>assert_equals(
      act = lcl_stream=>read_int4( iv_xstr = 'FFFFFF7F' iv_offset = 0 )
      exp = 2147483647 ).
    cl_abap_unit_assert=>assert_equals(
      act = lcl_stream=>read_int4( iv_xstr = '00000080' iv_offset = 0 )
      exp = -2147483648 ).
    cl_abap_unit_assert=>assert_equals(
      act = lcl_stream=>read_int4( iv_xstr = 'FFFFFFFF' iv_offset = 0 )
      exp = -1 ).
  ENDMETHOD.

ENDCLASS.
