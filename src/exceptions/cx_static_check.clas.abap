CLASS cx_static_check DEFINITION PUBLIC INHERITING FROM cx_root.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE if_t100_message=>t100key OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL
        msgv1    TYPE c OPTIONAL
        msgv2    TYPE c OPTIONAL
        msgv3    TYPE c OPTIONAL
        msgv4    TYPE c OPTIONAL.
ENDCLASS.

CLASS cx_static_check IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).
  ENDMETHOD.

ENDCLASS.
