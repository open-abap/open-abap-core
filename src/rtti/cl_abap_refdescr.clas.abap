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
        !p_referenced_type TYPE REF TO cl_abap_typedescr
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_refdescr.
    RAISING
      cx_sy_creation.

  PRIVATE SECTION.
    DATA referenced TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS cl_abap_refdescr IMPLEMENTATION.

  METHOD get_ref_to_object.
    "todo
  ENDMETHOD.

  METHOD create.
    "todo
  ENDMETHOD.

  METHOD get_referenced_type.
    type = referenced.
  ENDMETHOD.

  METHOD get_ref_to_data.
    DATA foo TYPE REF TO data.
    p_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.
ENDCLASS.
