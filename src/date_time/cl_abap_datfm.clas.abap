CLASS cl_abap_datfm DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS conv_date_ext_to_int
      IMPORTING
        im_datext    TYPE csequence
        im_datfmdes  TYPE char1 OPTIONAL
      EXPORTING
        ex_datint    TYPE d
        ex_datfmused TYPE char1
      RAISING
        cx_abap_datfm.

    CLASS-METHODS get_date_format_des
      IMPORTING
        im_datfm      TYPE char1 OPTIONAL
        im_langu      TYPE spras DEFAULT sy-langu
        im_plain      TYPE abap_bool DEFAULT abap_false
        im_long       TYPE abap_bool DEFAULT abap_false
      EXPORTING
        ex_dateformat TYPE csequence
      RAISING
        cx_abap_datfm.
ENDCLASS.

CLASS cl_abap_datfm IMPLEMENTATION.

  METHOD conv_date_ext_to_int.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_date_format_des.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.