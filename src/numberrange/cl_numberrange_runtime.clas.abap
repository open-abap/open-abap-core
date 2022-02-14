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

    CALL FUNCTION 'ZNUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = nr_range_nr
        object                  = object
      IMPORTING
        number                  = number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      RETURN. " todo
    ENDIF.

  ENDMETHOD.

ENDCLASS.