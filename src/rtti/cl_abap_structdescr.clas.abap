CLASS cl_abap_structdescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.

  PUBLIC SECTION.
    METHODS
      constructor
        IMPORTING data TYPE any.

    TYPES: BEGIN OF component,
             name       TYPE string,
             type       TYPE REF TO cl_abap_typedescr,
             as_include TYPE abap_bool,
           END OF component.
    TYPES: component_table TYPE STANDARD TABLE OF component WITH DEFAULT KEY.

    METHODS:
      get_components RETURNING VALUE(components) TYPE component_table.

  PRIVATE SECTION.
    DATA gt_components TYPE component_table.

ENDCLASS.

CLASS cl_abap_structdescr IMPLEMENTATION.

  METHOD constructor.
    DATA lv_name TYPE string.
    DATA ls_component LIKE LINE OF gt_components.
    FIELD-SYMBOLS <fs> TYPE any.

* todo, fail if input is not a structure?
    WRITE '@KERNEL for (const name of Object.keys(INPUT.data.value)) {'.
    WRITE '@KERNEL   lv_name.set(name.toUpperCase());'.
    CLEAR ls_component.
    ls_component-name = lv_name.
*    ASSIGN COMPONENT lv_name OF STRUCTURE data TO <fs>.
*    ls_component-type = cl_abap_typedescr=>describe_by_data( <fs> ).
    APPEND ls_component TO gt_components.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD get_components.
    components = gt_components.
  ENDMETHOD.

ENDCLASS.