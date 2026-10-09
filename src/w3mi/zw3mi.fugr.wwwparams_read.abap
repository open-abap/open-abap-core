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

  WRITE '@KERNEL filename.set(abap.W3MI[objid.get().trimEnd()].filename);'.

  WRITE '@KERNEL const fs = await import("fs");'.
  WRITE '@KERNEL const path = await import("path");'.
  WRITE '@KERNEL const url = await import("url");'.
  WRITE '@KERNEL const __filename = url.fileURLToPath(import.meta.url);'.
  WRITE '@KERNEL const __dirname = path.dirname(__filename);'.
* W3MI filenames are relative to the output root, which contains _top.mjs.
* Older flat output can keep resolving relative to this module.
  WRITE '@KERNEL let root = __dirname;'.
  WRITE '@KERNEL while (!fs.existsSync(path.join(root, "_top.mjs"))) {'.
  WRITE '@KERNEL   const parent = path.dirname(root);'.
  WRITE '@KERNEL   if (parent === root) { root = __dirname; break; }'.
  WRITE '@KERNEL   root = parent;'.
  WRITE '@KERNEL }'.
  WRITE '@KERNEL const buf = fs.readFileSync(path.resolve(root, filename.get()));'.

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
