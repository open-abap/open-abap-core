FUNCTION seo_interface_implem_get_all.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INTKEY) TYPE  SEOCLSKEY
*"  EXPORTING
*"     VALUE(IMPKEYS) TYPE  SEOR_IMPLEMENTING_KEYS
*"  EXCEPTIONS
*"      NOT_EXISTING
*"      IS_CLASS
*"----------------------------------------------------------------------

  DATA lv_name   TYPE string.
  DATA lv_type   TYPE string.
  DATA lt_names  TYPE string_table.
  DATA lv_clsname LIKE LINE OF lt_names.
  DATA ls_impkey LIKE LINE OF impkeys.

  CLEAR impkeys.

* the key is read by position: callers pass any one-component CHAR 30
* structure (or a character field) for SEOCLSKEY, like a real system allows
  WRITE '@KERNEL const key = intkey.get();'.
  WRITE '@KERNEL const raw = typeof key === "object" ? Object.values(key)[0]?.get() : key;'.
  WRITE '@KERNEL lv_name.set(String(raw ?? "").trimEnd().toUpperCase());'.
  WRITE '@KERNEL lv_type.set(abap.Classes[lv_name.get()]?.INTERNAL_TYPE || "");'.

  IF lv_type IS INITIAL.
    RAISE not_existing.
  ELSEIF lv_type <> 'INTF'.
    RAISE is_class.
  ENDIF.

* every transpiled class lists the interfaces it implements, those of its
* superclasses included, in IMPLEMENTED_INTERFACES; local classes are
* registered under a prefixed name and left out, a system knows global
* classes only
  WRITE '@KERNEL for (const [name, clas] of Object.entries(abap.Classes)) {'.
  WRITE '@KERNEL   if (clas?.INTERNAL_TYPE !== "CLAS" || name.includes("-")) { continue; }'.
  WRITE '@KERNEL   if ((clas.IMPLEMENTED_INTERFACES || []).includes(lv_name.get()) === false) { continue; }'.
  WRITE '@KERNEL   lt_names.append(new abap.types.String().set(name));'.
  WRITE '@KERNEL }'.

  SORT lt_names.

  LOOP AT lt_names INTO lv_clsname.
    CLEAR ls_impkey.
    ls_impkey-clsname    = lv_clsname.
    ls_impkey-refclsname = lv_name.
    APPEND ls_impkey TO impkeys.
  ENDLOOP.

ENDFUNCTION.
