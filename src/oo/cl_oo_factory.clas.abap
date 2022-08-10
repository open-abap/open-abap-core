CLASS cl_oo_factory DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_oo_clif_source.

    CLASS-METHODS create_instance
      RETURNING
        VALUE(result) TYPE REF TO cl_oo_factory.

    METHODS create_clif_source
      IMPORTING
        clif_name     TYPE csequence
      RETURNING
        VALUE(result) TYPE REF TO if_oo_clif_source
      RAISING
        cx_oo_clif_not_exists.

  PRIVATE SECTION.
    DATA mv_name TYPE string.
ENDCLASS.

CLASS cl_oo_factory IMPLEMENTATION.
  METHOD create_instance.
    CREATE OBJECT result.
  ENDMETHOD.

  METHOD create_clif_source.
* todo, this not correct, should return a new instance, but will work for now
    result = me.
    mv_name = to_upper( clif_name ).
  ENDMETHOD.

  METHOD if_oo_clif_source~get_source.
    DATA ls_data TYPE reposrc.
    SELECT SINGLE * FROM reposrc INTO ls_data WHERE progname = mv_name.
    SPLIT ls_data-data AT |\n| INTO TABLE source.
  ENDMETHOD.
ENDCLASS.