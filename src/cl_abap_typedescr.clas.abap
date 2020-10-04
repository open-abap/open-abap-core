CLASS cl_abap_typedescr DEFINITION PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS
      describe_by_data
        IMPORTING data TYPE clike
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.

    DATA type_kind TYPE c LENGTH 1.

    CONSTANTS typekind_int TYPE c LENGTH 1 VALUE 'I'.

ENDCLASS.

CLASS cl_abap_typedescr IMPLEMENTATION.

  METHOD describe_by_data.
    CREATE OBJECT type.
    WRITE '@KERNEL console.log("describe_by_data, todo");'.
    type->type_kind = typekind_int.
  ENDMETHOD.

ENDCLASS.