CLASS cl_oo_factory DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create_instance
      RETURNING
        VALUE(result) TYPE REF TO cl_oo_factory.
    METHODS create_clif_source
      IMPORTING
        clif_name TYPE csequence
      RETURNING
        VALUE(result) TYPE REF TO if_oo_clif_source.
ENDCLASS.

CLASS cl_oo_factory IMPLEMENTATION.
  METHOD create_instance.
    CREATE OBJECT result.
  ENDMETHOD.

  METHOD create_clif_source.
    CLEAR result.
    ASSERT clif_name = 'todo'.
  ENDMETHOD.
ENDCLASS.