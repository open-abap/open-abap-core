CLASS cl_salv_aggregations DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS add_aggregation
      IMPORTING
        columnname   TYPE any
        aggregation  TYPE i DEFAULT if_salv_c_aggregation=>total.
ENDCLASS.

CLASS cl_salv_aggregations IMPLEMENTATION.
  METHOD add_aggregation.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.