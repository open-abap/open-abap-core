CLASS cx_parameter_invalid_range DEFINITION PUBLIC INHERITING FROM cx_parameter_invalid.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid    LIKE textid OPTIONAL
        previous  LIKE previous OPTIONAL
        parameter TYPE string OPTIONAL
        value     TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_parameter_invalid_range IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid    = textid
      previous  = previous
      parameter = parameter ).
  ENDMETHOD.
ENDCLASS.