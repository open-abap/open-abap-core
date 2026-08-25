CLASS cl_abap_container_utilities DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-METHODS fill_container_c
      IMPORTING
        im_value     TYPE any
      EXPORTING
        ex_container TYPE c
      EXCEPTIONS
        illegal_parameter_type.

    CLASS-METHODS read_container_c
      IMPORTING
        im_container TYPE c
      EXPORTING
        ex_value     TYPE any
      EXCEPTIONS
        illegal_parameter_type.

ENDCLASS.

CLASS cl_abap_container_utilities IMPLEMENTATION.

  METHOD fill_container_c.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD read_container_c.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
