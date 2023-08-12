CLASS cl_abap_timefm DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS conv_time_ext_to_int
      IMPORTING
        time_ext        TYPE csequence
        is_24_allowed   TYPE abap_bool DEFAULT abap_false
      EXPORTING
        time_int        TYPE t
      RAISING
        cx_abap_timefm_invalid.

    CLASS-METHODS conv_time_int_to_ext
      IMPORTING
        time_int TYPE t
      EXPORTING
        time_ext TYPE string
      RAISING
        cx_parameter_invalid_range.
ENDCLASS.

CLASS cl_abap_timefm IMPLEMENTATION.
  METHOD conv_time_ext_to_int.
    DATA lv_text TYPE string.

* todo,
    ASSERT is_24_allowed = abap_true.

    FIND REGEX '^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$' IN time_ext.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_timefm_invalid.
    ENDIF.

    lv_text = time_ext.
    REPLACE ALL OCCURRENCES OF ':' IN lv_text WITH ''.
    time_int = lv_text.
  ENDMETHOD.

  METHOD conv_time_int_to_ext.

  ENDMETHOD.
ENDCLASS.