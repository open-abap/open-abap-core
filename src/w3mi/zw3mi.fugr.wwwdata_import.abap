FUNCTION wwwdata_import.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(KEY) LIKE  WWWDATATAB STRUCTURE  WWWDATATAB
*"  TABLES
*"      MIME STRUCTURE  W3MIME OPTIONAL
*"  EXCEPTIONS
*"      WRONG_OBJECT_TYPE
*"      IMPORT_ERROR
*"----------------------------------------------------------------------

  DATA filename TYPE string.
  DATA xstr     TYPE xstring.
  DATA row      TYPE w3mime.
  DATA len      TYPE i.
  DATA lv_error TYPE abap_bool.

  CLEAR mime.

  WRITE '@KERNEL const w3obj = abap.W3MI?.[key.get().objid.get().trimEnd()];'.
  WRITE '@KERNEL lv_error.set(w3obj === undefined ? "X" : " ");'.

  IF lv_error = abap_true.
    RAISE import_error.
  ENDIF.

  " Reuse w3obj directly
  WRITE '@KERNEL filename.set(w3obj.filename);'.

  WRITE '@KERNEL const fs = await import("fs");'.
  WRITE '@KERNEL const path = await import("path");'.
  WRITE '@KERNEL const url = await import("url");'.
  WRITE '@KERNEL const __filename = url.fileURLToPath(import.meta.url);'.
  WRITE '@KERNEL const __dirname = path.dirname(__filename);'.
  WRITE '@KERNEL xstr.set(fs.readFileSync(__dirname + path.sep + filename.get()).toString("hex").toUpperCase());'.

  WHILE xstrlen( xstr ) > 0.
    len = 255.
    IF xstrlen( xstr ) < len.
      len = xstrlen( xstr ).
    ENDIF.
    row-line = xstr(len).
    APPEND row TO mime.
    xstr = xstr+len.
  ENDWHILE.

* temp workaround, classic exceptions not really handled in transpiler yet
  sy-subrc = 0.

ENDFUNCTION.
