CLASS cl_abap_typedescr DEFINITION PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS
      describe_by_data
        IMPORTING data TYPE any
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.

    DATA type_kind TYPE c LENGTH 1.

    CONSTANTS typekind_int TYPE c LENGTH 1 VALUE 'I'.
    CONSTANTS typekind_struct1 TYPE c LENGTH 1 VALUE 'u'.
    CONSTANTS typekind_struct2 TYPE c LENGTH 1 VALUE 'v'.
    CONSTANTS typekind_xstring TYPE c LENGTH 1 VALUE 'y'.
    CONSTANTS typekind_string TYPE c LENGTH 1 VALUE 'g'.

ENDCLASS.

CLASS cl_abap_typedescr IMPLEMENTATION.

  METHOD describe_by_data.

    DATA lv_name TYPE string.

    WRITE '@KERNEL lv_name.set(data.constructor.name);'.

    CREATE OBJECT type.

* These are the constructor names from the js runtime
    CASE lv_name.
      WHEN 'Integer'.
        type->type_kind = typekind_int.
      WHEN 'Structure'.
        type->type_kind = typekind_struct2.
      WHEN 'XString'.
        type->type_kind = typekind_xstring.
      WHEN 'String'.
        type->type_kind = typekind_string.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.