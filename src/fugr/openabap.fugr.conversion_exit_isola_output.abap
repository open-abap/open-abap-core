FUNCTION conversion_exit_isola_output.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT)
*"  EXPORTING
*"     VALUE(OUTPUT)
*"----------------------------------------------------------------------

  cl_i18n_languages=>sap1_to_sap2(
    EXPORTING
      im_lang_sap1  = input
    RECEIVING
      re_lang_sap2  = output
    EXCEPTIONS
      no_assignment = 1
      OTHERS        = 2 ).

ENDFUNCTION.