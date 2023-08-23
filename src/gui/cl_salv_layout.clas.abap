CLASS cl_salv_layout DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS set_key
      IMPORTING
        value TYPE any.

    METHODS set_save_restriction
      IMPORTING
        value TYPE any OPTIONAL.

    METHODS set_default
      IMPORTING
        value TYPE abap_bool.
ENDCLASS.

CLASS cl_salv_layout IMPLEMENTATION.
  METHOD set_key.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD set_save_restriction.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD set_default.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.
ENDCLASS.