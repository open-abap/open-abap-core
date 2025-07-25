CLASS cx_sy_dyn_call_illegal_func DEFINITION PUBLIC INHERITING FROM cx_sy_dyn_call_error.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        function LIKE function OPTIONAL.

ENDCLASS.

CLASS cx_sy_dyn_call_illegal_func IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous
      function = function ).
  ENDMETHOD.

ENDCLASS.