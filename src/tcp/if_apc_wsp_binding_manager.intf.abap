INTERFACE if_apc_wsp_binding_manager PUBLIC.
  METHODS bind_amc_message_consumer
    IMPORTING
      i_application_id TYPE clike
      i_channel_id     TYPE clike
    RAISING
      cx_apc_error.
ENDINTERFACE.