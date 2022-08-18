CLASS cl_abap_classdescr DEFINITION PUBLIC INHERITING FROM cl_abap_objectdescr.
  PUBLIC SECTION.
    CLASS-METHODS get_class_name
      IMPORTING
        p_object TYPE REF TO object
      RETURNING
        VALUE(p_name) TYPE abap_abstypename.
ENDCLASS.

CLASS cl_abap_classdescr IMPLEMENTATION.
  METHOD get_class_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.