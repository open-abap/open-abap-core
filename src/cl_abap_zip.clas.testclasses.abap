CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS get FOR TESTING RAISING cx_static_check.
    METHODS crc FOR TESTING RAISING cx_static_check.
    METHODS save FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD crc.
    DATA lv_crc TYPE i.
    lv_crc = cl_abap_zip=>crc32( '1122334455' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_crc
      exp = 950032937 ).
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

    WRITE '@KERNEL const fs = await import("fs");'.
    WRITE '@KERNEL fs.writeFileSync("foo.zip", Buffer.from(lv_save.get().toLowerCase(), "hex"));'.

  ENDMETHOD.

ENDCLASS.