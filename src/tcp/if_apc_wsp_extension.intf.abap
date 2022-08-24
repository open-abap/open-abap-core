INTERFACE if_apc_wsp_extension PUBLIC.
  METHODS on_start
    IMPORTING
      i_context         TYPE REF TO if_apc_wsp_server_context
      i_message_manager TYPE REF TO if_apc_wsp_message_manager.

  METHODS on_message
    IMPORTING
      i_message         TYPE REF TO if_apc_wsp_message
      i_message_manager TYPE REF TO if_apc_wsp_message_manager
      i_context         TYPE REF TO if_apc_wsp_server_context.
ENDINTERFACE.