CLASS cx_sy_assign_error DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid LIKE textid OPTIONAL.
ENDCLASS.

CLASS cx_sy_assign_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( textid = textid ).
  ENDMETHOD.
ENDCLASS.
