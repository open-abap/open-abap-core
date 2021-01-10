CLASS cl_abap_structdescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.

  PUBLIC SECTION.
    TYPES: BEGIN OF component,
             name TYPE string,
             type TYPE REF TO cl_abap_typedescr,
             as_include TYPE abap_bool,
           END OF component.
    TYPES: component_table TYPE STANDARD TABLE OF component WITH DEFAULT KEY.

    METHODS:
      get_components RETURNING VALUE(components) TYPE component_table.

ENDCLASS.

CLASS cl_abap_structdescr IMPLEMENTATION.

  METHOD get_components.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

ENDCLASS.