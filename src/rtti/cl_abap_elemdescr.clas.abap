CLASS cl_abap_elemdescr DEFINITION PUBLIC INHERITING FROM cl_abap_datadescr.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF fixvalue,
        low        TYPE c LENGTH 10,
        high       TYPE c LENGTH 10,
        option     TYPE c LENGTH 2,
        ddlanguage TYPE c,
        ddtext     TYPE c LENGTH 60,
      END OF fixvalue.
    TYPES fixvalues TYPE STANDARD TABLE OF fixvalue WITH DEFAULT KEY.

    METHODS get_ddic_fixed_values
      RETURNING
        VALUE(p_fixed_values) TYPE fixvalues.

    METHODS get_ddic_field
      IMPORTING
        VALUE(p_langu) TYPE sy-langu DEFAULT sy-langu
      RETURNING
        VALUE(p_flddescr) TYPE dfies
      EXCEPTIONS
        not_found
        no_ddic_type.
ENDCLASS.

CLASS cl_abap_elemdescr IMPLEMENTATION.

  METHOD get_ddic_field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_ddic_fixed_values.

    DATA lv_dummy TYPE string.
    DATA lv_name  TYPE string.
    DATA ls_row   LIKE LINE OF p_fixed_values.

    SPLIT absolute_name AT '=' INTO lv_dummy lv_name.

    WRITE '@KERNEL for (const f of abap.DDIC[lv_name.get()]?.fixedValues || []) {'.
    CLEAR ls_row.
    WRITE '@KERNEL   ls_row.get().low.set(f.low || "");'.
    WRITE '@KERNEL   ls_row.get().high.set(f.high || "");'.
    WRITE '@KERNEL   ls_row.get().option.set(f.option || "");'.
    WRITE '@KERNEL   ls_row.get().ddlanguage.set(f.ddlanguage || "");'.
    WRITE '@KERNEL   ls_row.get().ddtext.set(f.ddtext || "");'.
    APPEND ls_row TO p_fixed_values.
    WRITE '@KERNEL }'.

  ENDMETHOD.

ENDCLASS.