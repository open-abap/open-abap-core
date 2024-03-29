CLASS cl_salv_hyperlinks DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS add_hyperlink
      IMPORTING
        handle       TYPE any
        hyperlink    TYPE any OPTIONAL
      RAISING
        cx_salv_existing.

ENDCLASS.

CLASS cl_salv_hyperlinks IMPLEMENTATION.

  METHOD add_hyperlink.
    RETURN.
  ENDMETHOD.
ENDCLASS.