CLASS lcl_dump DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS to_string
      IMPORTING iv_val TYPE any
      RETURNING VALUE(rv_str) TYPE string.
ENDCLASS.

CLASS lcl_dump IMPLEMENTATION.
  METHOD to_string.
    rv_str = |{ iv_val }|.
  ENDMETHOD.
ENDCLASS.