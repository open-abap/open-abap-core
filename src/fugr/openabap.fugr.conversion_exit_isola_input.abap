FUNCTION conversion_exit_isola_input.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"        VALUE(INPUT)
*"  EXPORTING
*"        VALUE(OUTPUT)
*"  EXCEPTIONS
*"         UNKNOWN_LANGUAGE
*"----------------------------------------------------------------------

  output = cl_i18n_languages=>sap2_to_sap1(
    EXPORTING
      im_lang_sap2 = input
    EXCEPTIONS
      no_assignment = 1 ).
  IF sy-subrc = 1.
    RAISE unknown_language.
  ENDIF.

ENDFUNCTION.