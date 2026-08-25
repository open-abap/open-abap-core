CLASS cx_sy_too_many_files DEFINITION PUBLIC INHERITING FROM cx_no_check.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL.
ENDCLASS.

CLASS cx_sy_too_many_files IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).
  ENDMETHOD.
ENDCLASS.
