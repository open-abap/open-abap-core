CLASS cl_abap_refdescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.
  PUBLIC SECTION.
    METHODS get_referenced_type RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS cl_abap_refdescr IMPLEMENTATION.
  METHOD get_referenced_type.
    ASSERT 2 = 'todo'.
  ENDMETHOD.
ENDCLASS.