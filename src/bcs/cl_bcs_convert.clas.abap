CLASS cl_bcs_convert DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-METHODS string_to_soli
      IMPORTING
        iv_string      TYPE string
      RETURNING
        VALUE(et_soli) TYPE soli_tab.

    CLASS-METHODS xstring_to_solix
      IMPORTING
        iv_xstring TYPE xstring
      RETURNING
        VALUE(et_solix) TYPE solix_tab.

ENDCLASS.

CLASS cl_bcs_convert IMPLEMENTATION.

  METHOD string_to_soli.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD xstring_to_solix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.