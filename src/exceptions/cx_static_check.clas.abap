CLASS cx_static_check DEFINITION PUBLIC INHERITING FROM cx_root ABSTRACT.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL.
ENDCLASS.

CLASS cx_static_check IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).
  ENDMETHOD.

ENDCLASS.