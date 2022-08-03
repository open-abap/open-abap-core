CLASS cl_abap_exceptional_values DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_max_value
      IMPORTING
        in TYPE any
      RETURNING
        VALUE(out) TYPE REF TO data.

    CLASS-METHODS get_min_value
      IMPORTING
        in TYPE any
      RETURNING
        VALUE(out) TYPE REF TO data.
ENDCLASS.

CLASS cl_abap_exceptional_values IMPLEMENTATION.

  METHOD get_max_value.
    DATA lv_type TYPE c LENGTH 1.

    DESCRIBE FIELD in TYPE lv_type.

    CASE lv_type.
      WHEN cl_abap_typedescr=>typekind_int.
        GET REFERENCE OF cl_abap_math=>max_int4 INTO out.
      WHEN OTHERS.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

  METHOD get_min_value.
    DATA lv_type TYPE c LENGTH 1.

    DESCRIBE FIELD in TYPE lv_type.

    CASE lv_type.
      WHEN cl_abap_typedescr=>typekind_int.
        GET REFERENCE OF cl_abap_math=>min_int4 INTO out.
      WHEN OTHERS.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.