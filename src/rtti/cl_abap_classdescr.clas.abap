CLASS cl_abap_classdescr DEFINITION PUBLIC INHERITING FROM cl_abap_objectdescr.
  PUBLIC SECTION.

    DATA class_kind TYPE string.
    DATA create_visibility TYPE string.

    CLASS-METHODS get_class_name
      IMPORTING
        p_object      TYPE REF TO object
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
    DATA lv_name TYPE string.
    WRITE '@KERNEL lv_name.set(p_object.get().constructor.INTERNAL_NAME);'.
    p_name = kernel_internal_name=>internal_to_rtti( lv_name ).
  ENDMETHOD.

  METHOD get_super_class_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
