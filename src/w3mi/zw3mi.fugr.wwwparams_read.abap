FUNCTION wwwparams_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(RELID) LIKE  WWWPARAMS-RELID
*"     VALUE(OBJID) LIKE  WWWPARAMS-OBJID
*"     VALUE(NAME) TYPE  C
*"  EXPORTING
*"     VALUE(VALUE) TYPE  C
*"  EXCEPTIONS
*"      ENTRY_NOT_EXISTS
*"----------------------------------------------------------------------

  DATA filename TYPE string.
  DATA filesize TYPE i.

  WRITE '@KERNEL filename.set(abap.W3MI[objid.get()].filename);'.

  WRITE '@KERNEL const fs = await import("fs");'.
  WRITE '@KERNEL const path = await import("path");'.
  WRITE '@KERNEL const url = await import("url");'.
  WRITE '@KERNEL const __filename = url.fileURLToPath(import.meta.url);'.
  WRITE '@KERNEL const __dirname = path.dirname(__filename);'.
  WRITE '@KERNEL const buf = fs.readFileSync(__dirname + path.sep + filename.get());'.

  IF name = 'filesize'.
    WRITE '@KERNEL filesize.set(buf.length);'.
    value = filesize.
    CONDENSE value.
  ELSE.
    ASSERT 1 = 'todo'.
  ENDIF.

* temp workaround, classic exceptions not really handled in transpiler yet
  sy-subrc = 0.

ENDFUNCTION.