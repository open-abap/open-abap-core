CLASS cl_numberrange_objects DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF nr_attributes,
             object     TYPE c LENGTH 10,
             domlen     TYPE c LENGTH 30,
             percentage TYPE i,
             buffer     TYPE abap_bool,
             noivbuffer TYPE i,
             devclass   TYPE c LENGTH 30,
             corrnr     TYPE c LENGTH 20,
           END OF nr_attributes.

    TYPES: BEGIN OF nr_obj_text,
             object   TYPE c LENGTH 10,
             langu    TYPE sy-langu,
             txt      TYPE string,
             txtshort TYPE string,
           END OF nr_obj_text.

    TYPES: BEGIN OF nr_error,
             message TYPE string,
           END OF nr_error.

    TYPES nr_errors TYPE STANDARD TABLE OF nr_error WITH DEFAULT KEY.

    CLASS-METHODS create
      IMPORTING
        attributes TYPE nr_attributes
        obj_text   TYPE nr_obj_text
      EXPORTING
        errors     TYPE nr_errors
        returncode TYPE i
      RAISING
        cx_number_ranges
        cx_nr_object_not_found.
ENDCLASS.

CLASS cl_numberrange_objects IMPLEMENTATION.

  METHOD create.
    CLEAR errors.
    returncode = 0.
  ENDMETHOD.

ENDCLASS.