CLASS kernel_numberrange DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS number_get
      IMPORTING
        nr_range_nr TYPE cl_numberrange_runtime=>nr_interval
        object      TYPE cl_numberrange_runtime=>nr_object
      EXPORTING
        number      TYPE cl_numberrange_runtime=>nr_number
      RAISING
        cx_static_check.
ENDCLASS.

CLASS kernel_numberrange IMPLEMENTATION.

  METHOD number_get.
    number = number + 1.
  ENDMETHOD.

ENDCLASS.