CLASS cx_abap_invalid_value DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.
  PUBLIC SECTION.
    DATA value TYPE string.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        value    TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_abap_invalid_value IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).

    me->value = value.
  ENDMETHOD.
ENDCLASS.
