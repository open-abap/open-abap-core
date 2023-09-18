INTERFACE if_apc_wsp_client PUBLIC.
  METHODS connect
    RAISING
      cx_apc_error.

  METHODS close
    RAISING
      cx_apc_error.

  METHODS get_message_manager
    RETURNING
      VALUE(ri_manager) TYPE REF TO if_apc_wsp_message_manager
    RAISING
      cx_apc_error.
ENDINTERFACE.