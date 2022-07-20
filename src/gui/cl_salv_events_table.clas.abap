CLASS cl_salv_events_table DEFINITION PUBLIC.
  PUBLIC SECTION.
    EVENTS double_click
      EXPORTING
        VALUE(row)    TYPE i
        VALUE(column) TYPE string.

    EVENTS added_function
      EXPORTING
        VALUE(e_salv_function) TYPE string OPTIONAL.
ENDCLASS.

CLASS cl_salv_events_table IMPLEMENTATION.

ENDCLASS.