CLASS cx_bcs DEFINITION PUBLIC INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    DATA error_type TYPE c LENGTH 16.
    DATA error_text TYPE string.
    DATA msgid TYPE symsgid.
    DATA msgty TYPE symsgty.
    DATA msgno TYPE symsgno.
    DATA msgv1 TYPE symsgv.
    DATA msgv2 TYPE symsgv.
    DATA msgv3 TYPE symsgv.
    DATA msgv4 TYPE symsgv.

    METHODS constructor
      IMPORTING
        textid     LIKE textid OPTIONAL
        previous   LIKE previous OPTIONAL
        error_type LIKE error_type OPTIONAL
        error_text LIKE error_text OPTIONAL
        msgid      LIKE msgid OPTIONAL
        msgty      LIKE msgty OPTIONAL
        msgno      LIKE msgno OPTIONAL
        msgv1      LIKE msgv1 OPTIONAL
        msgv2      LIKE msgv2 OPTIONAL
        msgv3      LIKE msgv3 OPTIONAL
        msgv4      LIKE msgv4 OPTIONAL.

ENDCLASS.

CLASS cx_bcs IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).

    me->error_type = error_type.
    me->error_text = error_text.
    me->msgid = msgid.
    me->msgty = msgty.
    me->msgno = msgno.
    me->msgv1 = msgv1.
    me->msgv2 = msgv2.
    me->msgv3 = msgv3.
    me->msgv4 = msgv4.
  ENDMETHOD.

ENDCLASS.
