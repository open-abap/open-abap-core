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
  DATA off      TYPE i.
  DATA total    TYPE i.

  IF key-relid <> 'MI'.
    RAISE wrong_object_type.
  ENDIF.

  WRITE '@KERNEL const w3obj = abap.W3MI?.[key.get().objid.get().trimEnd()];'.
  WRITE '@KERNEL lv_error.set(w3obj === undefined ? "X" : " ");'.

* an object that is not there leaves MIME as it was
  IF lv_error = abap_true.
    RAISE import_error.
  ENDIF.

  CLEAR mime.

  " Reuse w3obj directly
  WRITE '@KERNEL filename.set(w3obj.filename);'.

  WRITE '@KERNEL const fs = await import("fs");'.
  WRITE '@KERNEL const path = await import("path");'.
  WRITE '@KERNEL const url = await import("url");'.
  WRITE '@KERNEL const __filename = url.fileURLToPath(import.meta.url);'.
  WRITE '@KERNEL const __dirname = path.dirname(__filename);'.
  WRITE '@KERNEL xstr.set(fs.readFileSync(__dirname + path.sep + filename.get()).toString("hex").toUpperCase());'.

* walked with an offset: taking the remainder each time copies it, which
* is quadratic, and a file of a few megabytes takes minutes
  total = xstrlen( xstr ).
  WHILE off < total.
    len = 255.
    IF total - off < len.
      len = total - off.
    ENDIF.
    row-line = xstr+off(len).
    APPEND row TO mime.
    off = off + len.
  ENDWHILE.

* temp workaround, classic exceptions not really handled in transpiler yet
  sy-subrc = 0.

ENDFUNCTION.
