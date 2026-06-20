CLASS cl_numberrange_intervals DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF nr_nriv_line,
             nrrangenr  TYPE c LENGTH 2,
             fromnumber TYPE n LENGTH 8,
             tonumber   TYPE n LENGTH 8,
             procind    TYPE c LENGTH 1,
           END OF nr_nriv_line.

    TYPES nr_interval TYPE STANDARD TABLE OF nr_nriv_line WITH DEFAULT KEY.

    TYPES: BEGIN OF nr_error,
             message TYPE string,
           END OF nr_error.

    TYPES nr_error_tab TYPE STANDARD TABLE OF nr_error WITH DEFAULT KEY.

    CLASS-METHODS create
      IMPORTING
        interval  TYPE nr_interval
        object    TYPE cl_numberrange_objects=>nr_attributes-object
        subobject TYPE csequence
      EXPORTING
        error     TYPE abap_bool
        error_inf TYPE nr_error
        error_iv  TYPE nr_error_tab
        warning   TYPE abap_bool
      RAISING
        cx_number_ranges
        cx_nr_object_not_found.
ENDCLASS.

CLASS cl_numberrange_intervals IMPLEMENTATION.

  METHOD create.
    CLEAR error.
    CLEAR error_inf.
    CLEAR error_iv.
    CLEAR warning.
  ENDMETHOD.

ENDCLASS.