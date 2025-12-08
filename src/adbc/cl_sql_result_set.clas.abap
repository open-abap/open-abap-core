CLASS cl_sql_result_set DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS set_param
      IMPORTING
        data_ref TYPE REF TO data
      RAISING
        cx_parameter_invalid.

    METHODS set_param_table
      IMPORTING
        itab_ref TYPE REF TO data
      RAISING
        cx_parameter_invalid.

    METHODS next
      RETURNING
        VALUE(rows_ret) TYPE i
      RAISING
        cx_sql_exception.

    METHODS close.

    METHODS next_package
      RAISING
        cx_sql_exception
        cx_parameter_invalid_type.

    DATA mv_magic TYPE x LENGTH 1. " todo, move to private somehow
    DATA mv_index TYPE i. " todo, move to private somehow
  PRIVATE SECTION.
    DATA mv_ref   TYPE REF TO data.
ENDCLASS.

CLASS cl_sql_result_set IMPLEMENTATION.

  METHOD set_param.
    mv_ref = data_ref.
  ENDMETHOD.

  METHOD next.
* todo, more work needed here

    DATA lv_total TYPE i.
    DATA lv_value TYPE string.

    WRITE '@KERNEL lv_total.set(this.mv_magic.length);'.
*    WRITE '@KERNEL console.dir(this.mv_magic);'.
    WRITE '@KERNEL const current = this.mv_magic[this.mv_index.get()];'.

    WRITE '@KERNEL if (typeof Object.values(current)[0] === "boolean") {'.
    WRITE '@KERNEL   lv_value.set((Object.values(current)[0] === true) ? "X" : "");'.
    WRITE '@KERNEL } else {'.
    WRITE '@KERNEL   lv_value.set(Object.values(current)[0]);'.
    WRITE '@KERNEL }'.

    IF mv_ref IS NOT INITIAL.
      mv_ref->* = lv_value.
    ENDIF.

    rows_ret = lv_total - mv_index.

    mv_index = mv_index + 1.
  ENDMETHOD.

  METHOD close.
* nothing here,
    RETURN.
  ENDMETHOD.

  METHOD set_param_table.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD next_package.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.