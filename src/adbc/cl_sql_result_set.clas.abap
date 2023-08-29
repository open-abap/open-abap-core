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
  PRIVATE SECTION.
    DATA mv_magic TYPE x LENGTH 1.
    DATA mv_index TYPE i.
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
    WRITE '@KERNEL lv_value.set(Object.values(current)[0]);'.

    mv_ref->* = lv_value.

    mv_index = mv_index + 1.
    rows_ret = lv_total - mv_index.
  ENDMETHOD.

  METHOD close.
* nothing here,
    RETURN.
  ENDMETHOD.

  METHOD set_param_table.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.