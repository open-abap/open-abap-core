CLASS cl_abap_structdescr DEFINITION PUBLIC INHERITING FROM cl_abap_complexdescr.

  PUBLIC SECTION.
    METHODS
      constructor
        IMPORTING data TYPE any.

    TYPES component TYPE abap_componentdescr.
    TYPES component_table TYPE abap_component_tab.
    TYPES included_view TYPE abap_component_view_tab.

    METHODS
      get_components
        RETURNING
          VALUE(rt_components) TYPE component_table.

    METHODS:
      get_ddic_field_list RETURNING VALUE(rt_components) TYPE ddfields,
      is_ddic_type RETURNING VALUE(bool) TYPE abap_bool,
      get_component_type
        IMPORTING
          p_name TYPE any
        RETURNING
          VALUE(p_descr_ref) TYPE REF TO cl_abap_datadescr
        EXCEPTIONS
          component_not_found
          unsupported_input_type.

    METHODS get_included_view
      IMPORTING
        p_level TYPE i OPTIONAL
      RETURNING
        VALUE(p_result) TYPE included_view.

    CLASS-METHODS create
      IMPORTING
        p_components TYPE component_table
        p_strict     TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(ref)   TYPE REF TO cl_abap_structdescr.

    DATA components TYPE abap_compdescr_tab.
    DATA struct_kind TYPE abap_structkind READ-ONLY.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_refs,
             name TYPE string,
             ref  TYPE REF TO cl_abap_datadescr,
           END OF ty_refs.
    DATA mt_refs TYPE STANDARD TABLE OF ty_refs.
ENDCLASS.

CLASS cl_abap_structdescr IMPLEMENTATION.

  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_included_view.
    ASSERT 1 = 'todo'.
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
*    ASSERT 1 = 'todo'.

  ENDMETHOD.

  METHOD is_ddic_type.
    bool = ddic.
  ENDMETHOD.

  METHOD constructor.
    DATA lv_name      TYPE string.
    DATA ls_component LIKE LINE OF components.
    DATA ls_ref       LIKE LINE OF mt_refs.
    DATA lo_datadescr TYPE REF TO cl_abap_datadescr.

    FIELD-SYMBOLS <fs> TYPE any.

* todo, fail if input is not a structure?
    WRITE '@KERNEL for (const name of Object.keys(INPUT.data.value)) {'.
    WRITE '@KERNEL   lv_name.set(name.toUpperCase());'.
    CLEAR ls_component.
    ls_component-name = lv_name.
    ASSIGN COMPONENT lv_name OF STRUCTURE data TO <fs>.
    lo_datadescr ?= cl_abap_typedescr=>describe_by_data( <fs> ).
    ls_component-type_kind = lo_datadescr->type_kind.
    APPEND ls_component TO components.

    ls_ref-name = lv_name.
    ls_ref-ref = lo_datadescr.
    APPEND ls_ref TO mt_refs.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD get_components.
    DATA ls_component LIKE LINE OF components.
    DATA ret          LIKE LINE OF rt_components.
    DATA ls_ref       LIKE LINE OF mt_refs.

    LOOP AT components INTO ls_component.
      CLEAR ret.
      ret-name = ls_component-name.
      READ TABLE mt_refs INTO ls_ref WITH KEY name = ls_component-name.
      IF sy-subrc = 0.
        ret-type = ls_ref-ref.
        ret-type_kind = ret-type->type_kind.
      ENDIF.
      " as_include type abap_bool,
      " suffix     type string,
      APPEND ret TO rt_components.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_component_type.
    DATA line LIKE LINE OF mt_refs.
    READ TABLE mt_refs INTO line WITH KEY name = p_name.
    IF sy-subrc <> 0.
      RAISE component_not_found.
    ELSE.
      p_descr_ref = line-ref.
    ENDIF.
  ENDMETHOD.

ENDCLASS.