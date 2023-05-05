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
ENDCLASS.

CLASS cl_abap_datfm IMPLEMENTATION.

  METHOD conv_date_ext_to_int.
    DATA is_it_ddmmyyyy_dot_seperated TYPE string VALUE '^(0[1-9]|[12][0-9]|3[01])[- \..](0[1-9]|1[012])[- \..](19|20)\d\d$'.
    IF im_datfmdes <> 1.
      RAISE EXCEPTION TYPE cx_abap_datfm.
    ENDIF.

    FIND ALL OCCURRENCES OF REGEX is_it_ddmmyyyy_dot_seperated IN im_datext.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_datfm.
    ENDIF.
  ENDMETHOD.

ENDCLASS.