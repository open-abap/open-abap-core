CLASS cx_no_check DEFINITION PUBLIC INHERITING FROM cx_root.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL.

ENDCLASS.

CLASS cx_no_check IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      previous = previous
      textid   = textid ).
  ENDMETHOD.

ENDCLASS.