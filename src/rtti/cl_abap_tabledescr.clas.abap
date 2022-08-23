CLASS cl_abap_tabledescr DEFINITION PUBLIC INHERITING FROM cl_abap_datadescr.
  PUBLIC SECTION.
    METHODS
      constructor
        IMPORTING data TYPE any.
    METHODS get_table_line_type
      RETURNING
        VALUE(type) TYPE REF TO cl_abap_datadescr.
    CLASS-METHODS get
      IMPORTING type TYPE REF TO cl_abap_typedescr
      RETURNING VALUE(val) TYPE REF TO cl_abap_tabledescr.
    CLASS-METHODS get_with_keys
      IMPORTING
        p_line_type TYPE REF TO cl_abap_datadescr
        p_keys TYPE any
      RETURNING VALUE(val) TYPE REF TO cl_abap_tabledescr.
    CLASS-METHODS create
      IMPORTING type TYPE REF TO cl_abap_typedescr
      RETURNING VALUE(ref) TYPE REF TO cl_abap_tabledescr.

    DATA table_kind TYPE c LENGTH 1.
    DATA has_unique_key TYPE abap_bool READ-ONLY.

    CONSTANTS tablekind_any TYPE c LENGTH 1 VALUE 'A'.
    CONSTANTS tablekind_std TYPE c LENGTH 1 VALUE 'S'.
    CONSTANTS tablekind_index TYPE c LENGTH 1 VALUE 'I'.
    CONSTANTS tablekind_hashed TYPE c LENGTH 1 VALUE 'H'.
    CONSTANTS tablekind_sorted TYPE c LENGTH 1 VALUE 'O'.
    CONSTANTS keydefkind_default TYPE c LENGTH 1 VALUE 'D'.
    CONSTANTS keydefkind_tableline TYPE c LENGTH 1 VALUE 'L'.
    CONSTANTS keydefkind_user TYPE c LENGTH 1 VALUE 'U'.
    CONSTANTS keydefkind_empty TYPE c LENGTH 1 VALUE 'E'.

  PRIVATE SECTION.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS cl_abap_tabledescr IMPLEMENTATION.
  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_with_keys.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD constructor.
    DATA lv_dummy TYPE i.
    DATA lv_flag TYPE abap_bool.
*    WRITE '@KERNEL console.dir(data);'.

    WRITE '@KERNEL lv_flag.set(data.getOptions()?.isUnique === true ? "X" : "");'.
    has_unique_key = lv_flag.

    WRITE '@KERNEL lv_dummy = data.getRowType();'.
    lo_type = cl_abap_typedescr=>describe_by_data( lv_dummy ).
  ENDMETHOD.

  METHOD get_table_line_type.
    type ?= lo_type.
  ENDMETHOD.
ENDCLASS.