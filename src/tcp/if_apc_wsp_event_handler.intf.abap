INTERFACE if_apc_wsp_event_handler PUBLIC.
  METHODS on_open.

  METHODS on_message
    IMPORTING i_message TYPE REF TO if_apc_wsp_message.

  METHODS on_close.

  METHODS on_error
    IMPORTING
      i_reason TYPE string.
ENDINTERFACE.