CLASS cl_abap_typedescr DEFINITION PUBLIC.
* todo, this class should be ABSTRACT
  PUBLIC SECTION.
    CLASS-METHODS
      describe_by_data
        IMPORTING data TYPE any
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS
      describe_by_name
        IMPORTING name TYPE clike
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS
      describe_by_data_ref
        IMPORTING data TYPE REF TO data
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS
      describe_by_object_ref
        IMPORTING data TYPE REF TO object
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.

    DATA type_kind TYPE c LENGTH 1.
    DATA kind TYPE c LENGTH 1.
    DATA absolute_name TYPE string.

    CONSTANTS typekind_int TYPE c LENGTH 1 VALUE 'I'.
    CONSTANTS typekind_struct1 TYPE c LENGTH 1 VALUE 'u'.
    CONSTANTS typekind_struct2 TYPE c LENGTH 1 VALUE 'v'.
    CONSTANTS typekind_xstring TYPE c LENGTH 1 VALUE 'y'.
    CONSTANTS typekind_string TYPE c LENGTH 1 VALUE 'g'.
    CONSTANTS typekind_dref TYPE c LENGTH 1 VALUE 'l'.
    CONSTANTS typekind_oref TYPE c LENGTH 1 VALUE 'r'.

    CONSTANTS kind_elem TYPE c LENGTH 1 VALUE 'E'.
    CONSTANTS kind_struct TYPE c LENGTH 1 VALUE 'S'.
    CONSTANTS kind_table TYPE c LENGTH 1 VALUE 'T'.

ENDCLASS.

CLASS cl_abap_typedescr IMPLEMENTATION.

  METHOD describe_by_name.

    " DATA ref TYPE REF TO data.
    " FIELD-SYMBOLS <ref> TYPE any.
    " CREATE DATA ref TYPE (name).
    " ASSIGN ref->* TO <ref>.

    " and then call DESCRIBE_BY_DATA_REF ?

    ASSERT 1 = 'todo'.

  ENDMETHOD.

  METHOD describe_by_data_ref.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD describe_by_object_ref.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD describe_by_data.

    DATA lv_name TYPE string.

* todo, add special handing for field symbol input
    WRITE '@KERNEL lv_name.set(data.constructor.name);'.

* These are the constructor names from the js runtime
    CASE lv_name.
      WHEN 'Integer'.
        CREATE OBJECT type.
        type->type_kind = typekind_int.
        type->kind = kind_elem.
      WHEN 'Structure'.
        CREATE OBJECT type TYPE cl_abap_structdescr
          EXPORTING
            data = data.
        type->type_kind = typekind_struct2.
        type->kind = kind_struct.
      WHEN 'XString'.
        CREATE OBJECT type.
        type->type_kind = typekind_xstring.
        type->kind = kind_elem.
      WHEN 'String'.
        CREATE OBJECT type.
        type->type_kind = typekind_string.
        type->kind = kind_elem.
    ENDCASE.

    type->absolute_name = 'ABSOLUTE_NAME_TODO'.

  ENDMETHOD.

ENDCLASS.