CLASS cl_salv_column DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS set_technical IMPORTING value TYPE abap_bool DEFAULT abap_true.
    METHODS set_short_text IMPORTING value TYPE string.
    METHODS set_medium_text IMPORTING value TYPE string.
    METHODS set_long_text IMPORTING value TYPE string.
    METHODS set_output_length IMPORTING value TYPE any.
    METHODS set_sign IMPORTING value TYPE any.
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

  METHOD set_output_length.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_sign.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.