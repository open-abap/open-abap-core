CLASS cl_sxml_string_reader DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        input         TYPE xstring
      RETURNING
        VALUE(reader) TYPE REF TO if_sxml_reader.
ENDCLASS.

CLASS cl_sxml_string_reader IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT reader TYPE lcl_reader
      EXPORTING
        iv_json = cl_abap_codepage=>convert_from( input ).
  ENDMETHOD.
ENDCLASS.