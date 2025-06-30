CLASS cl_demo_output DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_demo_output.

    CLASS-METHODS write
      IMPORTING
        data TYPE any
        name TYPE string OPTIONAL.

    CLASS-METHODS clear.

    CLASS-METHODS new
      RETURNING
        VALUE(output) TYPE REF TO if_demo_output.

    CLASS-METHODS display
      IMPORTING
        data TYPE any OPTIONAL
        name TYPE string OPTIONAL PREFERRED PARAMETER data.

    CLASS-METHODS display_html
      IMPORTING
        html TYPE csequence.

    CLASS-METHODS display_text
      IMPORTING
        text TYPE clike.
ENDCLASS.

CLASS cl_demo_output IMPLEMENTATION.
  METHOD display_text.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD display_html.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD write.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD if_demo_output~write.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD new.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD clear.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD display.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD if_demo_output~display.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.
ENDCLASS.