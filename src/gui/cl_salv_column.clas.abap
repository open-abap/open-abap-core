CLASS cl_salv_column DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS set_technical.
    METHODS set_short_text IMPORTING value TYPE string.
    METHODS set_medium_text IMPORTING value TYPE string.
    METHODS set_long_text IMPORTING value TYPE string.
ENDCLASS.

CLASS cl_salv_column IMPLEMENTATION.
  METHOD set_technical.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_short_text.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_medium_text.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_long_text.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.