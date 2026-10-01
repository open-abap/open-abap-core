CLASS cl_abap_zip_save1 DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run.
ENDCLASS.

CLASS cl_abap_zip_save1 IMPLEMENTATION.
  METHOD run.
* a 128 KB entry: SAVE, then LOAD and SAVE again, like filling a template
    DATA lo_zip     TYPE REF TO cl_abap_zip.
    DATA lv_content TYPE xstring.
    DATA lv_zip     TYPE xstring.

    lv_content = '3C726F773E3C632F3E3C2F726F773E0A'. " <row><c/></row>

    DO 13 TIMES.
      CONCATENATE lv_content lv_content INTO lv_content IN BYTE MODE.
    ENDDO.

    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'sheet1.xml'
                 content = lv_content ).
    lv_zip = lo_zip->save( ).

    CREATE OBJECT lo_zip.
    lo_zip->load( lv_zip ).
    lv_zip = lo_zip->save( ).
  ENDMETHOD.
ENDCLASS.
