CLASS cx_sy_dyn_call_error DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.

  PUBLIC SECTION.
    DATA function TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        function LIKE function OPTIONAL.
ENDCLASS.

CLASS cx_sy_dyn_call_error IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).

    me->function = function.
  ENDMETHOD.

ENDCLASS.