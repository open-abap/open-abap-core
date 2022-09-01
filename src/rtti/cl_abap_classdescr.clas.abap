CLASS cl_abap_classdescr DEFINITION PUBLIC INHERITING FROM cl_abap_objectdescr.
  PUBLIC SECTION.
    CLASS-METHODS get_class_name
      IMPORTING
        p_object TYPE REF TO object
      RETURNING
        VALUE(p_name) TYPE abap_abstypename.

    METHODS get_super_class_type
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_classdescr
      EXCEPTIONS
        super_class_not_found.
ENDCLASS.

CLASS cl_abap_classdescr IMPLEMENTATION.
  METHOD get_class_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_super_class_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.