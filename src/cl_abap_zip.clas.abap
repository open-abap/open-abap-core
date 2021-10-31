CLASS cl_abap_zip DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS add
      IMPORTING
        name TYPE string
        content TYPE xstring.

    METHODS save RETURNING VALUE(val) TYPE xstring.

    METHODS load IMPORTING zip TYPE xstring.

    TYPES: BEGIN OF t_file,
             name TYPE string,
           END OF t_file.
    TYPES t_files TYPE STANDARD TABLE OF t_file.
    DATA files TYPE STANDARD TABLE OF t_files WITH DEFAULT KEY.

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