CLASS cl_salv_sorts DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS add_sort
      IMPORTING
        columnname TYPE clike
        subtotal   TYPE abap_bool DEFAULT abap_false
      RAISING
        cx_salv_not_found
        cx_salv_existing
        cx_salv_data_error.
ENDCLASS.

CLASS cl_salv_sorts IMPLEMENTATION.
  METHOD add_sort.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.