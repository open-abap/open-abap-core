CLASS cx_sy_conversion_overflow DEFINITION PUBLIC INHERITING FROM cx_sy_conversion_error.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        value    TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_conversion_overflow IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).
  ENDMETHOD.
ENDCLASS.