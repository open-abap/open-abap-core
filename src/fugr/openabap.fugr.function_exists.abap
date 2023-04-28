FUNCTION function_exists.

  DATA lv_name TYPE string.
  DATA lv_exists TYPE abap_bool.

  lv_name = funcname.
  CONDENSE lv_name.

  WRITE '@KERNEL lv_exists.set(abap.FunctionModules[lv_name.get()] === undefined ? " " : "X");'.

  IF lv_exists = abap_false.
    RAISE function_not_exist.
  ENDIF.

ENDFUNCTION.