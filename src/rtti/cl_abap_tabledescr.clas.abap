CLASS cl_abap_tabledescr DEFINITION PUBLIC INHERITING FROM cl_abap_datadescr.
  PUBLIC SECTION.
    CLASS-METHODS
      construct_from_data
        IMPORTING data TYPE any
        RETURNING VALUE(descr) TYPE REF TO cl_abap_tabledescr.

    METHODS get_table_line_type
      RETURNING
        VALUE(type) TYPE REF TO cl_abap_datadescr.

    CLASS-METHODS get
      IMPORTING type TYPE REF TO cl_abap_typedescr
      RETURNING VALUE(val) TYPE REF TO cl_abap_tabledescr.

    CLASS-METHODS get_with_keys
      IMPORTING
        p_line_type TYPE REF TO cl_abap_datadescr
        p_keys      TYPE abap_table_keydescr_tab
      RETURNING VALUE(p_result) TYPE REF TO cl_abap_tabledescr.

    CLASS-METHODS create
      IMPORTING p_line_type TYPE REF TO cl_abap_typedescr
      RETURNING VALUE(ref) TYPE REF TO cl_abap_tabledescr.

    DATA has_unique_key TYPE abap_bool READ-ONLY.
    DATA key            TYPE abap_keydescr_tab READ-ONLY.
    DATA key_defkind    TYPE abap_keydefkind READ-ONLY.
    DATA table_kind     TYPE abap_tablekind.

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
    DATA mo_line_type TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS cl_abap_tabledescr IMPLEMENTATION.
  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_with_keys.
    DATA ls_key LIKE LINE OF p_keys.

    IF lines( p_keys ) <> 1.
      ASSERT 1 = 'todo'.
    ENDIF.
    READ TABLE p_keys INDEX 1 INTO ls_key.
    ASSERT sy-subrc = 0.

    CREATE OBJECT p_result.
    p_result->has_unique_key = ls_key-is_unique.
    p_result->mo_line_type   = p_line_type.
    p_result->key_defkind    = ls_key-key_kind.
    p_result->table_kind     = ls_key-access_kind.
    p_result->type_kind      = typekind_table.
    p_result->kind           = kind_table.
  ENDMETHOD.

  METHOD get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD construct_from_data.
* todo, this method should be private
    DATA lv_dummy TYPE i.
    DATA lv_flag  TYPE abap_bool.

    CREATE OBJECT descr.

    WRITE '@KERNEL lv_flag.set(data.getOptions()?.primaryKey?.isUnique === true ? "X" : "");'.
    descr->has_unique_key = lv_flag.

    WRITE '@KERNEL lv_dummy = data.getRowType();'.
    descr->mo_line_type = cl_abap_typedescr=>describe_by_data( lv_dummy ).
  ENDMETHOD.

  METHOD get_table_line_type.
    type ?= mo_line_type.
  ENDMETHOD.
ENDCLASS.