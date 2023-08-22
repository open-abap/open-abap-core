CLASS cl_bcs_convert DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-METHODS string_to_soli
      IMPORTING
        iv_string      TYPE string
      RETURNING
        VALUE(et_soli) TYPE soli_tab.

    CLASS-METHODS xstring_to_solix
      IMPORTING
        iv_xstring      TYPE xstring
      RETURNING
        VALUE(et_solix) TYPE solix_tab.

    CLASS-METHODS raw_to_string
      IMPORTING
        it_soli          TYPE soli_tab
      RETURNING
        VALUE(ev_string) TYPE string
      RAISING
        cx_bcs.

    CLASS-METHODS solix_to_xstring
      IMPORTING
        it_solix TYPE solix_tab
        iv_size TYPE i OPTIONAL
      RETURNING
        VALUE(ev_xstring) TYPE xstring.

ENDCLASS.

CLASS cl_bcs_convert IMPLEMENTATION.

  METHOD string_to_soli.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD solix_to_xstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD xstring_to_solix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD raw_to_string.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.