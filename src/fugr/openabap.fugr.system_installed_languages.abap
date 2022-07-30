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

ENDFUNCTION.