CLASS cx_web_http_client_error DEFINITION PUBLIC INHERITING FROM cx_static_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    METHODS constructor
      IMPORTING
        textid   LIKE if_t100_message=>t100key OPTIONAL
        previous LIKE previous OPTIONAL.

    METHODS get_message_id
      RETURNING
        VALUE(id) TYPE symsgno.

ENDCLASS.

CLASS cx_web_http_client_error IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

  METHOD get_message_id.
    id = if_t100_message~t100key-msgno.
  ENDMETHOD.

ENDCLASS.
