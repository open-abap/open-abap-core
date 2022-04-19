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
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_status,
             nr_range_nr TYPE cl_numberrange_runtime=>nr_interval,
             object      TYPE cl_numberrange_runtime=>nr_object,
             number      TYPE cl_numberrange_runtime=>nr_number,
           END OF ty_status.
    CLASS-DATA status TYPE STANDARD TABLE OF ty_status WITH DEFAULT KEY.
ENDCLASS.

CLASS kernel_numberrange IMPLEMENTATION.

  METHOD number_get.
* for now, only in memory for the current session
    FIELD-SYMBOLS <row> LIKE LINE OF status.
    READ TABLE status WITH KEY nr_range_nr = nr_range_nr object = object ASSIGNING <row>.
    IF sy-subrc = 0.
      <row>-number = <row>-number + 1.
    ELSE.
      APPEND INITIAL LINE TO status ASSIGNING <row>.
      <row>-nr_range_nr = nr_range_nr.
      <row>-object = object.
      <row>-number = 1.
    ENDIF.
    number = <row>-number.
  ENDMETHOD.

ENDCLASS.