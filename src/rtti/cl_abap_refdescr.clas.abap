CLASS cl_abap_refdescr DEFINITION PUBLIC INHERITING FROM cl_abap_datadescr.
  PUBLIC SECTION.
    METHODS get_referenced_type
      RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.

    CLASS-METHODS get_ref_to_data
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_refdescr.

    CLASS-METHODS get_ref_to_object
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_refdescr.

    CLASS-METHODS create
      IMPORTING
        p_referenced_type TYPE REF TO cl_abap_typedescr
      RETURNING
        VALUE(p_result)   TYPE REF TO cl_abap_refdescr.

    CLASS-METHODS get
      IMPORTING
        p_referenced_type TYPE REF TO cl_abap_typedescr
      RETURNING
        VALUE(p_result)   TYPE REF TO cl_abap_refdescr
      RAISING
        cx_sy_ref_creation.

  PRIVATE SECTION.
    DATA referenced TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS cl_abap_refdescr IMPLEMENTATION.
  METHOD get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_ref_to_object.
    "todo
  ENDMETHOD.

  METHOD create.
    CREATE OBJECT p_result.
    p_result->referenced = p_referenced_type.
    p_result->kind = cl_abap_typedescr=>kind_ref.
    IF p_referenced_type IS BOUND
        AND ( p_referenced_type->kind = cl_abap_typedescr=>kind_class
        OR p_referenced_type->kind = cl_abap_typedescr=>kind_intf ).
      p_result->type_kind = cl_abap_typedescr=>typekind_oref.
    ELSE.
      p_result->type_kind = cl_abap_typedescr=>typekind_dref.
    ENDIF.
  ENDMETHOD.

  METHOD get_referenced_type.
    type = referenced.
  ENDMETHOD.

  METHOD get_ref_to_data.
    DATA foo TYPE REF TO data.
    p_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.
ENDCLASS.
