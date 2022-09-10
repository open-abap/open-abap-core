CLASS kernel_create_data_handle DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS call
      IMPORTING
        area_handle TYPE REF TO cl_abap_datadescr
      CHANGING
        dref        TYPE REF TO any.
  PRIVATE SECTION.
ENDCLASS.

CLASS kernel_create_data_handle IMPLEMENTATION.

  METHOD call.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.