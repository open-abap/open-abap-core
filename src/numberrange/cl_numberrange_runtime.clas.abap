CLASS cl_numberrange_runtime DEFINITION PUBLIC FINAL.
  PUBLIC SECTION.

    TYPES nr_interval          TYPE c LENGTH 2.
    TYPES nr_object            TYPE c LENGTH 10.
    TYPES nr_number            TYPE n LENGTH 20.
    TYPES nr_number_alpha      TYPE c LENGTH 20.
    TYPES nr_ignore_buffer     TYPE c LENGTH 1.
    TYPES nr_length_check      TYPE c LENGTH 1.
    TYPES nr_numeric_check     TYPE c LENGTH 1.
    TYPES nr_flag              TYPE c LENGTH 1.
    TYPES nr_quantity          TYPE n LENGTH 20.
    TYPES nr_returncode        TYPE c LENGTH 1.
    TYPES nr_returned_quantity TYPE n LENGTH 20.
    TYPES nr_subobject         TYPE c LENGTH 6.
    TYPES nr_toyear            TYPE n LENGTH 4.

    CLASS-METHODS number_get
      IMPORTING
        ignore_buffer     TYPE nr_ignore_buffer DEFAULT space
        nr_range_nr       TYPE nr_interval
        object            TYPE nr_object
        quantity          TYPE nr_quantity DEFAULT '1'
        subobject         TYPE nr_subobject DEFAULT space
        toyear            TYPE nr_toyear DEFAULT '0000'
      EXPORTING
        number            TYPE nr_number
        returncode        TYPE nr_returncode
        returned_quantity TYPE nr_returned_quantity
      RAISING
        cx_nr_object_not_found
        cx_number_ranges.

    CLASS-METHODS number_status
      IMPORTING
        nr_range_nr TYPE nr_interval
        object      TYPE nr_object
        subobject   TYPE nr_subobject DEFAULT space
        toyear      TYPE nr_toyear DEFAULT '0000'
      EXPORTING
        number      TYPE nr_number
      RAISING
        cx_nr_object_not_found
        cx_number_ranges.
ENDCLASS.

CLASS cl_numberrange_runtime IMPLEMENTATION.

  METHOD number_get.
* the intervals are not checked, every object and interval counts from 1, in memory of the session
    IF quantity <> 1.
      ASSERT 1 = 'todo'.
    ENDIF.

    kernel_numberrange=>number_get(
      EXPORTING
        nr_range_nr = nr_range_nr
        object      = object
        subobject   = subobject
        toyear      = toyear
      IMPORTING
        number      = number ).
    CLEAR returncode.
    returned_quantity = 1.
  ENDMETHOD.

  METHOD number_status.
    kernel_numberrange=>number_status(
      EXPORTING
        nr_range_nr = nr_range_nr
        object      = object
        subobject   = subobject
        toyear      = toyear
      IMPORTING
        number      = number ).
  ENDMETHOD.

ENDCLASS.
