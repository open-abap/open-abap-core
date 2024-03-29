CLASS cl_salv_functional_settings DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS get_hyperlinks
      RETURNING
        VALUE(value) TYPE REF TO cl_salv_hyperlinks.
ENDCLASS.

CLASS cl_salv_functional_settings IMPLEMENTATION.
  METHOD get_hyperlinks.
    RETURN.
  ENDMETHOD.
ENDCLASS.