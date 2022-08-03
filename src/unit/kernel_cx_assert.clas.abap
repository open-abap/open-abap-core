CLASS kernel_cx_assert DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.
  PUBLIC SECTION.
    DATA actual TYPE string.
    DATA expected TYPE string.
    DATA msg TYPE string.

    METHODS constructor
      IMPORTING
        msg      TYPE string
        previous LIKE previous OPTIONAL
        expected LIKE expected OPTIONAL
        actual   LIKE actual OPTIONAL.
ENDCLASS.

CLASS kernel_cx_assert IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->expected = expected.
    me->actual = actual.
    me->msg = msg.
    IF me->msg IS INITIAL.
      me->msg = |Unit test assertion failed|.
    ENDIF.
  ENDMETHOD.

ENDCLASS.