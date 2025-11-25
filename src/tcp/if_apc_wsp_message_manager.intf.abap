INTERFACE if_apc_wsp_message_manager PUBLIC.
  METHODS create_message
    RETURNING
      VALUE(r_message) TYPE REF TO if_apc_wsp_message
    RAISING
      cx_apc_error.

  METHODS send
    IMPORTING
      i_message TYPE REF TO if_apc_wsp_message
    RAISING
      cx_apc_error.
ENDINTERFACE.