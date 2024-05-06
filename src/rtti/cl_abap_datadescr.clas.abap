CLASS cl_abap_datadescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.
  PUBLIC SECTION.
    CLASS-METHODS get_data_type_kind
      IMPORTING
        p_data             TYPE data
      RETURNING
        VALUE(p_type_kind) TYPE abap_typekind.

    METHODS applies_to_data
      IMPORTING
        p_data        TYPE data
      RETURNING
        VALUE(p_flag) TYPE abap_bool.
ENDCLASS.

CLASS cl_abap_datadescr IMPLEMENTATION.

  METHOD get_data_type_kind.
    DATA descr TYPE REF TO cl_abap_typedescr.
    descr = cl_abap_typedescr=>describe_by_data( p_data ).
    p_type_kind = descr->type_kind.
  ENDMETHOD.

  METHOD applies_to_data.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.