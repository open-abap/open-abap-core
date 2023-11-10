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

    CLASS-METHODS conv_period_ext_to_int
      IMPORTING
        im_periodext TYPE csequence
      EXPORTING
        ex_periodint TYPE csequence
      RAISING
        cx_abap_datfm.

  PRIVATE SECTION.
    CONSTANTS ddmmyyyy_dot_seperated TYPE c VALUE '1'.
    CONSTANTS yyyymmdd_dot_seperated TYPE c VALUE '4'.
ENDCLASS.

CLASS cl_abap_datfm IMPLEMENTATION.

  METHOD conv_period_ext_to_int.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD conv_date_ext_to_int.
    DATA regex_ddmmyyyy_dot_seperated TYPE string VALUE '^(0[0-9]|[12][0-9]|3[01])[- \..](0[0-9]|1[012])[- \..]\d\d\d\d$'.
    DATA regex_yyyymmdd_dot_seperated TYPE string VALUE '^\d\d\d\d[- \..](0[0-9]|1[012])[- \..](0[0-9]|[12][0-9]|3[01])$'.
    DATA regex_yyyymmdd_no_dot TYPE string VALUE '^(\d{4})(0[0-9]|1[012])(0[0-9]|[12][0-9]|3[01])$'.

    IF im_datfmdes <> ddmmyyyy_dot_seperated
        AND im_datfmdes <> yyyymmdd_dot_seperated.
      RAISE EXCEPTION TYPE cx_abap_datfm.
    ENDIF.

    FIND ALL OCCURRENCES OF REGEX regex_ddmmyyyy_dot_seperated IN im_datext.
    IF sy-subrc = 0.
      ex_datint = im_datext+6(4) && im_datext+3(2) && im_datext(2).
      ex_datfmused = ddmmyyyy_dot_seperated.
      RETURN.
    ENDIF.

    FIND ALL OCCURRENCES OF REGEX regex_yyyymmdd_dot_seperated IN im_datext.
    IF sy-subrc = 0.
      ex_datint = im_datext(4) && im_datext+5(2) && im_datext+8(2).
      ex_datfmused = yyyymmdd_dot_seperated.
      RETURN.
    ENDIF.

    FIND ALL OCCURRENCES OF REGEX regex_yyyymmdd_no_dot IN im_datext.
    IF sy-subrc = 0.
      ex_datint = im_datext.
      ex_datfmused = yyyymmdd_dot_seperated.
      RETURN.
    ENDIF.

    RAISE EXCEPTION TYPE cx_abap_datfm.
  ENDMETHOD.

  METHOD get_date_format_des.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.