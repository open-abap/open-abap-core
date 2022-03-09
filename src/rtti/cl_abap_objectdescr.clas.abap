CLASS cl_abap_objectdescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.
  PUBLIC SECTION.
    METHODS get_attribute_type
      IMPORTING
        p_name TYPE any
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_datadescr.
ENDCLASS.

CLASS cl_abap_objectdescr IMPLEMENTATION.
  METHOD get_attribute_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.