CLASS cl_i18n_languages DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS sap1_to_sap2
      IMPORTING
        im_lang_sap1        TYPE sy-langu
      RETURNING
        VALUE(re_lang_sap2) TYPE string
      EXCEPTIONS
        no_assignment.

    CLASS-METHODS sap2_to_iso639_1
      IMPORTING
        im_lang_sap2   TYPE string
      EXPORTING
        ex_lang_iso639 TYPE string
        ex_country     TYPE land1
      EXCEPTIONS
        no_assignment.
ENDCLASS.

CLASS cl_i18n_languages IMPLEMENTATION.
  METHOD sap1_to_sap2.
* todo, ideally this should look up in a database table first
* if there is no database attached, fallback to the CASE below
    CASE im_lang_sap1.
      WHEN 'E'.
        re_lang_sap2 = 'EN'.
      WHEN 'D'.
        re_lang_sap2 = 'DE'.
      WHEN 'K'.
        re_lang_sap2 = 'DA'.
      WHEN OTHERS.
* todo, raise classic exception
        re_lang_sap2 = 'EN'.
    ENDCASE.
  ENDMETHOD.

  METHOD sap2_to_iso639_1.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.