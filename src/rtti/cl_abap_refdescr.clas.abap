CLASS cl_abap_refdescr DEFINITION PUBLIC INHERITING FROM cl_abap_datadescr.
  PUBLIC SECTION.
    METHODS get_referenced_type RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS get_ref_to_data
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_refdescr.
ENDCLASS.

CLASS cl_abap_refdescr IMPLEMENTATION.
  METHOD get_referenced_type.
    CREATE OBJECT type.
    type->absolute_name = 'CLASS_NAME_TODO'.
  ENDMETHOD.

  METHOD get_ref_to_data.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.