CLASS cx_web_message_error DEFINITION PUBLIC INHERITING FROM cx_dynamic_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL.

    METHODS get_message_number
      RETURNING
        VALUE(msgno) TYPE symsgno.

ENDCLASS.

CLASS cx_web_message_error IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).
  ENDMETHOD.

  METHOD get_message_number.
    CLEAR msgno.
  ENDMETHOD.

ENDCLASS.
