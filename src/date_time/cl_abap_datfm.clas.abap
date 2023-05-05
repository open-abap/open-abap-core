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
    IF im_datfmdes <> 1.
      RAISE EXCEPTION TYPE cx_abap_datfm.
    ENDIF.

    IF im_datext IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_datfm.
    ENDIF.
  ENDMETHOD.

ENDCLASS.