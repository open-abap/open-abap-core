FUNCTION system_installed_languages.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"       EXPORTING
*"              LANGUAGES
*"       EXCEPTIONS
*"              SAPGPARAM_ERROR
*"----------------------------------------------------------------------

* only english?
  languages = sy-langu.

* temp workaround, classic exceptions not really handled in transpiler yet
  sy-subrc = 0.

ENDFUNCTION.