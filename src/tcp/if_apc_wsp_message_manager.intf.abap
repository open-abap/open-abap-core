INTERFACE if_apc_wsp_message_manager PUBLIC.
  METHODS create_message
    RETURNING
      VALUE(ri_message) TYPE REF TO if_apc_wsp_message
    RAISING
      cx_apc_error.
  METHODS send
    IMPORTING
      ii_message TYPE REF TO if_apc_wsp_message
    RAISING
      cx_apc_error.
ENDINTERFACE.