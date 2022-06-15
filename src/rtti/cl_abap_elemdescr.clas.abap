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

    DATA output_length TYPE i READ-ONLY.
    DATA edit_mask TYPE abap_editmask READ-ONLY.

    METHODS get_ddic_fixed_values
      RETURNING
        VALUE(p_fixed_values) TYPE fixvalues.

    METHODS get_ddic_field
      IMPORTING
        p_langu TYPE sy-langu DEFAULT sy-langu
      RETURNING
        VALUE(p_flddescr) TYPE dfies
      EXCEPTIONS
        not_found
        no_ddic_type.

    CLASS-METHODS get_i RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_f RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_d RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_t RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.

ENDCLASS.

CLASS cl_abap_elemdescr IMPLEMENTATION.

  METHOD get_ddic_field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_i.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_f.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_d.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_t.
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