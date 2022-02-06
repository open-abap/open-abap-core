CLASS kernel_cx_assert DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.
  PUBLIC SECTION.
    DATA actual TYPE string.
    DATA expected TYPE string.
    DATA message TYPE string.

    METHODS constructor
      IMPORTING
        message  TYPE string
        previous LIKE previous OPTIONAL
        expected LIKE expected OPTIONAL
        actual   LIKE actual OPTIONAL.
ENDCLASS.

CLASS kernel_cx_assert IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->expected = expected.
    me->actual = actual.
    me->message = message.
    IF me->message IS INITIAL.
      me->message = |Unit test assertion failed|.
    ENDIF.
  ENDMETHOD.

ENDCLASS.