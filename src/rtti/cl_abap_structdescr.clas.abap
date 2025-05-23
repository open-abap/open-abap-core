CLASS cl_abap_structdescr DEFINITION PUBLIC INHERITING FROM cl_abap_complexdescr.
  PUBLIC SECTION.
    CLASS-METHODS
      construct_from_data
        IMPORTING data         TYPE any
        RETURNING VALUE(descr) TYPE REF TO cl_abap_structdescr.

    TYPES component       TYPE abap_componentdescr.
    TYPES component_table TYPE abap_component_tab.
    TYPES included_view   TYPE abap_component_view_tab.
    TYPES symbol_table    TYPE abap_component_symbol_tab.

    DATA has_include TYPE abap_bool READ-ONLY.

    METHODS
      get_components
        RETURNING
          VALUE(rt_components) TYPE component_table.

    METHODS
      get_ddic_field_list
        IMPORTING
          p_langu                  TYPE syst-langu DEFAULT sy-langu
          p_including_substructres TYPE abap_bool DEFAULT abap_false
        RETURNING
          VALUE(rt_components)     TYPE ddfields
        EXCEPTIONS
          not_found
          no_ddic_type.

    METHODS get_component_type
      IMPORTING
        p_name             TYPE any
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_datadescr
      EXCEPTIONS
        component_not_found
        unsupported_input_type.

    METHODS get_included_view
      IMPORTING
        p_level         TYPE i OPTIONAL
      RETURNING
        VALUE(p_result) TYPE included_view.

    CLASS-METHODS get
      IMPORTING
        p_components    TYPE component_table
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_structdescr
      RAISING
        cx_sy_struct_creation.

    CLASS-METHODS create
      IMPORTING
        p_components TYPE component_table
        p_strict     TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(ref)   TYPE REF TO cl_abap_structdescr.

    METHODS get_symbols
      RETURNING
        VALUE(p_result) TYPE symbol_table.

    DATA components  TYPE abap_compdescr_tab.
    DATA struct_kind TYPE abap_structkind READ-ONLY.

  PRIVATE SECTION.
    METHODS update_components.

    DATA mt_refs TYPE component_table.
    DATA mt_refs_comp TYPE component_table.
ENDCLASS.

CLASS cl_abap_structdescr IMPLEMENTATION.

  METHOD get_symbols.
    DATA lt_components  TYPE component_table.
    DATA ls_symbol      LIKE LINE OF p_result.
    DATA lt_symbols     TYPE symbol_table.
    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.

    FIELD-SYMBOLS <ls_component> LIKE LINE OF lt_components.
    FIELD-SYMBOLS <ls_symbol>    LIKE LINE OF lt_symbols.

    lt_components = get_components( ).
    LOOP AT lt_components ASSIGNING <ls_component>.
      IF <ls_component>-name IS NOT INITIAL.
        ls_symbol-name = <ls_component>-name.
        ls_symbol-type = <ls_component>-type.
        INSERT ls_symbol INTO TABLE p_result.
      ENDIF.
      IF <ls_component>-as_include = abap_true.
        lo_structdescr ?= <ls_component>-type.
        lt_symbols = lo_structdescr->get_symbols( ).
        LOOP AT lt_symbols ASSIGNING <ls_symbol>.
          CONCATENATE <ls_symbol>-name <ls_component>-suffix INTO ls_symbol-name.
          CONCATENATE <ls_symbol>-name <ls_component>-suffix INTO ls_symbol-name.
          ls_symbol-type = <ls_symbol>-type.
          INSERT ls_symbol INTO TABLE p_result.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD create.
    DATA ls_component LIKE LINE OF p_components.
    DATA ls_ref       LIKE LINE OF mt_refs.

    IF lines( p_components ) = 0.
      RAISE EXCEPTION TYPE cx_sy_struct_attributes.
    ENDIF.

    LOOP AT p_components INTO ls_component.
      IF ls_component-name IS INITIAL.
        RAISE EXCEPTION TYPE cx_sy_struct_comp_name.
      ELSEIF ls_component-type IS INITIAL.
        RAISE EXCEPTION TYPE cx_sy_struct_comp_type.
      ELSEIF strlen( ls_component-name ) > 30. " todo, use abap_max_comp_name_ln
        RAISE EXCEPTION TYPE cx_sy_struct_comp_name.
      ENDIF.
    ENDLOOP.

    CREATE OBJECT ref.
    LOOP AT p_components INTO ls_component.
      CLEAR ls_ref.
      ls_ref-name = ls_component-name.
      ls_ref-type = ls_component-type.
      APPEND ls_ref TO ref->mt_refs.
    ENDLOOP.
    ref->update_components( ).

    ref->type_kind = typekind_struct2.
    ref->kind = kind_struct.
  ENDMETHOD.

  METHOD get_included_view.
    DATA ls_view      LIKE LINE OF p_result.
    DATA ls_ref       LIKE LINE OF mt_refs.

    LOOP AT mt_refs INTO ls_ref WHERE as_include = abap_false.
      CLEAR ls_view.

      ls_view-name = ls_ref-name.
      ls_view-type = ls_ref-type.

      INSERT ls_view INTO TABLE p_result.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_ddic_field_list.

    DATA lt_components TYPE component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA ls_return     LIKE LINE OF rt_components.
    DATA lv_name       TYPE string.
    DATA lv_keyfield   TYPE string.
    DATA lo_elemdescr  TYPE REF TO cl_abap_elemdescr.
    FIELD-SYMBOLS <component> LIKE LINE OF rt_components.

    lt_components = get_components( ).

    ASSERT absolute_name CP '+TYPE=*'.
    lv_name = absolute_name+6.

    LOOP AT lt_components INTO ls_component.
      CLEAR ls_return.
      ls_return-tabname = lv_name.
      ls_return-fieldname = ls_component-name.
      IF ls_component-type->kind = cl_abap_typedescr=>kind_elem.
        lo_elemdescr ?= ls_component-type.
        ls_return-leng = lo_elemdescr->output_length.
      ENDIF.
* todo, fill more fields in ls_return
      APPEND ls_return TO rt_components.
    ENDLOOP.

*    WRITE '@KERNEL console.dir(abap.DDIC[lv_name.get()]?.keyFields);'.
    WRITE '@KERNEL for (const keyfield of abap.DDIC[lv_name.get()]?.keyFields || [] ) {'.
    WRITE '@KERNEL lv_keyfield.set(keyfield);'.
*    WRITE '@KERNEL console.dir(rt_components.array()[0].get());'.
    READ TABLE rt_components ASSIGNING <component> WITH KEY fieldname = lv_keyfield.
    ASSERT sy-subrc = 0.
    <component>-keyflag = abap_true.
    WRITE '@KERNEL }'.

  ENDMETHOD.

  METHOD construct_from_data.
* todo, this method should be private
    DATA lv_name       TYPE string.
    DATA ls_ref        LIKE LINE OF mt_refs.
    DATA lv_suffix     TYPE string.
    DATA lv_as_include TYPE abap_bool.
    DATA lo_datadescr  TYPE REF TO cl_abap_datadescr.

    FIELD-SYMBOLS <fs> TYPE any.

    CREATE OBJECT descr.

* todo, fail if input is not a structure?
    WRITE '@KERNEL for (const name of Object.keys(INPUT.data.value)) {'.
    WRITE '@KERNEL   lv_name.set(name.toUpperCase());'.
    ASSIGN COMPONENT lv_name OF STRUCTURE data TO <fs>.
    lo_datadescr ?= cl_abap_typedescr=>describe_by_data( <fs> ).
    ls_ref-name = lv_name.
    ls_ref-type = lo_datadescr.

    WRITE '@KERNEL if (INPUT.data?.getAsInclude) {'.
    WRITE '@KERNEL   lv_as_include.set(INPUT.data?.getAsInclude()?.[name.toLowerCase()] ? "X" : " ");'.
    WRITE '@KERNEL }'.
    ls_ref-as_include = lv_as_include.

    WRITE '@KERNEL if (INPUT.data?.getRenamingSuffix) {'.
    WRITE '@KERNEL   lv_suffix.set(INPUT.data?.getRenamingSuffix()?.[name.toLowerCase()] || "");'.
    TRANSLATE lv_suffix TO UPPER CASE.
    WRITE '@KERNEL }'.
    ls_ref-suffix = lv_suffix.

    APPEND ls_ref TO descr->mt_refs.
    WRITE '@KERNEL }'.

    descr->update_components( ).
  ENDMETHOD.

  METHOD update_components.
    DATA ls_component   LIKE LINE OF components.
    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE abap_component_tab.
    DATA lv_name TYPE string.
    FIELD-SYMBOLS <ls_ref> LIKE LINE OF mt_refs.
    FIELD-SYMBOLS <ls_component> LIKE LINE OF lt_components.

    CLEAR components.

    mt_refs_comp = mt_refs.

    LOOP AT mt_refs ASSIGNING <ls_ref>.
      ls_component-name = <ls_ref>-name.
      ls_component-type_kind = <ls_ref>-type->type_kind.
      ls_component-length = <ls_ref>-type->length.
      ls_component-decimals = <ls_ref>-type->decimals.
      APPEND ls_component TO components.
    ENDLOOP.

* the mt_refs contain really everything available in runtime
* the mt_ref_comp contains only the components that are not added as "as include" (needed for get_components)
    LOOP AT mt_refs ASSIGNING <ls_ref> WHERE as_include = abap_true.
      lo_structdescr ?= <ls_ref>-type.
      lt_components = lo_structdescr->get_components( ).
      LOOP AT lt_components ASSIGNING <ls_component>.
        CONCATENATE <ls_component>-name <ls_ref>-suffix INTO lv_name.
        DELETE mt_refs_comp WHERE name = lv_name.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_components.
    rt_components = mt_refs_comp.
  ENDMETHOD.

  METHOD get_component_type.
    FIELD-SYMBOLS <line> LIKE LINE OF mt_refs.
    READ TABLE mt_refs ASSIGNING <line> WITH KEY name = p_name.
    IF sy-subrc <> 0.
      RAISE component_not_found.
    ELSE.
      p_descr_ref = <line>-type.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
