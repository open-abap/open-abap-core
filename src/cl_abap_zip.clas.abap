CLASS cl_abap_zip DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS add
      IMPORTING 
        name TYPE string
        content TYPE xstring.

    METHODS save.

    METHODS load IMPORTING zip TYPE xstring.

ENDCLASS.

CLASS cl_abap_zip IMPLEMENTATION.

  METHOD add.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD load.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD save.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.