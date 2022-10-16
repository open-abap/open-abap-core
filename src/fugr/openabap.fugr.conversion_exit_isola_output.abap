FUNCTION conversion_exit_isola_output.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT)
*"  EXPORTING
*"     VALUE(OUTPUT)
*"----------------------------------------------------------------------

  output = cl_i18n_languages=>sap1_to_sap2( input ).

ENDFUNCTION.