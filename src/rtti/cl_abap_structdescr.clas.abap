CLASS cl_abap_structdescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.

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
    TYPES: component_table TYPE STANDARD TABLE OF component WITH DEFAULT KEY.

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
ENDCLASS.

CLASS cl_abap_structdescr IMPLEMENTATION.

  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_ddic_field_list.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD is_ddic_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD constructor.
    DATA lv_name TYPE string.
    DATA ls_component LIKE LINE OF components.
    FIELD-SYMBOLS <fs> TYPE any.

* todo, fail if input is not a structure?
    WRITE '@KERNEL for (const name of Object.keys(INPUT.data.value)) {'.
    WRITE '@KERNEL   lv_name.set(name.toUpperCase());'.
    CLEAR ls_component.
    ls_component-name = lv_name.
    ASSIGN COMPONENT lv_name OF STRUCTURE data TO <fs>.
    ls_component-type = cl_abap_typedescr=>describe_by_data( <fs> ).
    APPEND ls_component TO components.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD get_components.
    rt_components = components.
  ENDMETHOD.

  METHOD get_component_type.
    " TODO
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.