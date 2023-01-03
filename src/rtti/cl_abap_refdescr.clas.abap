CLASS cl_abap_refdescr DEFINITION PUBLIC INHERITING FROM cl_abap_datadescr.
  PUBLIC SECTION.
    METHODS get_referenced_type
      RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.

    CLASS-METHODS get_ref_to_data
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_refdescr.

  PRIVATE SECTION.
    DATA referenced TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS cl_abap_refdescr IMPLEMENTATION.
  METHOD get_referenced_type.
    IF referenced IS NOT INITIAL.
      type = referenced.
    ELSE.
      type ?= me.
    ENDIF.
  ENDMETHOD.

  METHOD get_ref_to_data.
    DATA foo TYPE REF TO data.
    p_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.
ENDCLASS.