CLASS cl_abap_tabledescr DEFINITION PUBLIC INHERITING FROM cl_abap_datadescr.
  PUBLIC SECTION.
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
      IMPORTING
        p_line_type  TYPE REF TO cl_abap_typedescr
        p_table_kind TYPE abap_tablekind DEFAULT tablekind_std
        p_unique     TYPE abap_bool DEFAULT abap_false
        p_key        TYPE abap_keydescr_tab OPTIONAL
        p_key_kind   TYPE abap_keydefkind DEFAULT keydefkind_default
      RETURNING
        VALUE(ref) TYPE REF TO cl_abap_tabledescr.

  PRIVATE SECTION.
    DATA mo_line_type TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS cl_abap_tabledescr IMPLEMENTATION.

  METHOD create.

    CREATE OBJECT ref.
    ref->has_unique_key = p_unique.
    ref->mo_line_type   = p_line_type.
    ref->key            = p_key.
    ref->key_defkind    = p_key_kind.
    ref->table_kind     = p_table_kind.

    " cl_abap_typedescr
    ref->type_kind      = typekind_table.
    ref->kind           = kind_table.

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

    " cl_abap_typedescr
    p_result->type_kind      = typekind_table.
    p_result->kind           = kind_table.

  ENDMETHOD.

  METHOD get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD construct_from_data.
* todo, this method should be private
    DATA lv_dummy      TYPE i.
    DATA lv_flag       TYPE abap_bool.
    DATA lv_str        TYPE string.
    DATA lv_type       TYPE string.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA ls_key        TYPE LINE OF abap_keydescr_tab.

    CREATE OBJECT descr.

    WRITE '@KERNEL lv_flag.set(data.getOptions()?.primaryKey?.isUnique === true ? "X" : "");'.
    descr->has_unique_key = lv_flag.

    WRITE '@KERNEL lv_type.set(data.getOptions()?.primaryKey?.type || "");'.
    CASE lv_type.
      WHEN 'STANDARD'.
        descr->table_kind = tablekind_std.
      WHEN 'SORTED'.
        descr->table_kind = tablekind_sorted.
      WHEN 'HASHED'.
        descr->table_kind = tablekind_hashed.
      WHEN OTHERS.
        descr->table_kind = tablekind_std.
    ENDCASE.

    WRITE '@KERNEL lv_dummy = data.getRowType();'.
    descr->mo_line_type = cl_abap_typedescr=>describe_by_data( lv_dummy ).

    WRITE '@KERNEL lv_flag.set(data.getOptions()?.primaryKey?.keyFields.length > 0 ? "X" : "");'.
    IF lv_flag = abap_true.
      descr->key_defkind = keydefkind_user.

      WRITE '@KERNEL for (const k of data.getOptions()?.primaryKey?.keyFields) {'.
      WRITE '@KERNEL lv_str.set(k);'.
      ls_key-name = lv_str.
      APPEND ls_key TO descr->key.
      WRITE '@KERNEL }'.

      IF lines( descr->key ) = 1 AND ls_key-name = 'TABLE_LINE'.
        descr->key_defkind = keydefkind_tableline.
      ENDIF.
    ELSE.
* EMPTY KEY currently not supported in open-abap
      descr->key_defkind = keydefkind_default.
      IF descr->mo_line_type->kind = kind_struct.
        lo_struct ?= descr->mo_line_type.
        lt_components = lo_struct->get_components( ).
        LOOP AT lt_components INTO ls_component.
          ls_key-name = ls_component-name.
          APPEND ls_key TO descr->key.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD get_table_line_type.
    type ?= mo_line_type.
  ENDMETHOD.
ENDCLASS.