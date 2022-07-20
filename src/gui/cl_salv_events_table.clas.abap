CLASS cl_salv_events_table DEFINITION PUBLIC.
  PUBLIC SECTION.
    EVENTS double_click
      EXPORTING
        VALUE(row)    TYPE salv_de_row
        VALUE(column) TYPE salv_de_column.
    EVENTS added_function
      EXPORTING
        VALUE(e_salv_function) TYPE salv_de_function OPTIONAL.
ENDCLASS.

CLASS cl_salv_events_table IMPLEMENTATION.

ENDCLASS.