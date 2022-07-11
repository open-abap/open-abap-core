CLASS cl_abap_structdescr DEFINITION PUBLIC INHERITING FROM cl_abap_complexdescr.

  PUBLIC SECTION.
    METHODS
      constructor
        IMPORTING data TYPE any.

    TYPES: BEGIN OF component,
             name       TYPE string,
             type       TYPE REF TO cl_abap_typedescr,
             as_include TYPE abap_bool,
             type_kind  TYPE c LENGTH 1,
           END OF component.
    TYPES component_table TYPE STANDARD TABLE OF component WITH DEFAULT KEY.

    METHODS:
      get_components RETURNING VALUE(rt_components) TYPE component_table,
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

    CLASS-METHODS create
      IMPORTING
        p_components TYPE component_table
        p_strict     TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(ref)   TYPE REF TO cl_abap_structdescr.

    DATA components TYPE component_table.
    DATA struct_kind TYPE abap_structkind READ-ONLY.
ENDCLASS.

CLASS cl_abap_structdescr IMPLEMENTATION.

  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_ddic_field_list.

    DATA lt_components TYPE component_table.
    DATA ls_component LIKE LINE OF lt_components.
    DATA ls_return LIKE LINE OF rt_components.
    DATA lv_name TYPE string.
    DATA lv_keyfield TYPE string.
    FIELD-SYMBOLS <component> LIKE LINE OF rt_components.

    lt_components = get_components( ).

    ASSERT absolute_name CP '+TYPE=*'.
    lv_name = absolute_name+6.

    LOOP AT lt_components INTO ls_component.
      CLEAR ls_return.
      ls_return-tabname = lv_name.
      ls_return-fieldname = ls_component-name.
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

    FIELD-SYMBOLS <fs> TYPE any.

* todo, fail if input is not a structure?
    WRITE '@KERNEL for (const name of Object.keys(INPUT.data.value)) {'.
    WRITE '@KERNEL   lv_name.set(name.toUpperCase());'.
    CLEAR ls_component.
    ls_component-name = lv_name.
    ASSIGN COMPONENT lv_name OF STRUCTURE data TO <fs>.
    ls_component-type = cl_abap_typedescr=>describe_by_data( <fs> ).
    ls_component-type_kind = ls_component-type->type_kind.
    APPEND ls_component TO components.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD get_components.
    rt_components = components.
  ENDMETHOD.

  METHOD get_component_type.
    DATA line LIKE LINE OF components.
    READ TABLE components INTO line WITH KEY name = p_name.
    IF sy-subrc <> 0.
* todo, RAISE component_not_found, classic exceptions doesnt work with transpiler as of today
      ASSERT 1 = 'todo'.
    ELSE.
      p_descr_ref ?= line-type.
    ENDIF.

  ENDMETHOD.

ENDCLASS.