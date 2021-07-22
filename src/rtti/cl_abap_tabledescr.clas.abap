CLASS cl_abap_tabledescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.
  PUBLIC SECTION.
    METHODS
      constructor
        IMPORTING data TYPE any.
    METHODS get_table_line_type
      RETURNING
        VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS create IMPORTING type TYPE REF TO cl_abap_typedescr.
  PRIVATE SECTION.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS cl_abap_tabledescr IMPLEMENTATION.
  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD constructor.
    DATA lv_dummy TYPE i.
*    WRITE '@KERNEL console.dir(data);'.
    WRITE '@KERNEL lv_dummy = data.getRowType();'.
*    WRITE '@KERNEL console.dir(lv_dummy);'.

    lo_type = cl_abap_typedescr=>describe_by_data( lv_dummy ).
  ENDMETHOD.

  METHOD get_table_line_type.
    type = lo_type.
  ENDMETHOD.
ENDCLASS.