CLASS cx_parameter_invalid DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.
  PUBLIC SECTION.
    DATA parameter TYPE string.

    METHODS constructor
      IMPORTING
        textid    LIKE textid OPTIONAL
        previous  LIKE previous OPTIONAL
        parameter TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_parameter_invalid IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).

    me->parameter = parameter.
  ENDMETHOD.
ENDCLASS.