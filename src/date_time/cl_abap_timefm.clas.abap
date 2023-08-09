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
ENDCLASS.

CLASS cl_abap_timefm IMPLEMENTATION.
  METHOD conv_time_ext_to_int.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.