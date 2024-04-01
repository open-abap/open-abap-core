CLASS cl_demo_output DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS write
      IMPORTING
        data TYPE any
        name TYPE string OPTIONAL.

    CLASS-METHODS clear.

    CLASS-METHODS display
      IMPORTING
      data TYPE any OPTIONAL
      name TYPE string OPTIONAL PREFERRED PARAMETER data.
ENDCLASS.

CLASS cl_demo_output IMPLEMENTATION.
  METHOD write.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD clear.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD display.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.
ENDCLASS.