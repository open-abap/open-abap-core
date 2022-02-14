CLASS cl_numberrange_runtime DEFINITION PUBLIC.
  PUBLIC SECTION.

    TYPES nr_interval TYPE c LENGTH 2.
    TYPES nr_object   TYPE c LENGTH 10.
    TYPES nr_number   TYPE n LENGTH 20.

    CLASS-METHODS number_get
      IMPORTING
        nr_range_nr TYPE nr_interval
        object      TYPE nr_object
      EXPORTING
        number      TYPE nr_number
      RAISING
        cx_static_check.
ENDCLASS.

CLASS cl_numberrange_runtime IMPLEMENTATION.

  METHOD number_get.
* todo    
  ENDMETHOD.

ENDCLASS.