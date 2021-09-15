INTERFACE if_apc_wsp_client PUBLIC.
  METHODS connect.
  METHODS close.
  METHODS get_message_manager
    RETURNING 
      VALUE(ri_manager) TYPE REF TO if_apc_wsp_message_manager.
ENDINTERFACE.