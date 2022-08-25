INTERFACE if_apc_wsp_server_context PUBLIC.
  METHODS get_initial_request
    RETURNING VALUE(r_initial_request) TYPE REF TO if_apc_wsp_initial_request
    RAISING cx_apc_error.
  METHODS get_binding_manager
    RETURNING VALUE(r_binding_manager) TYPE REF TO if_apc_wsp_binding_manager
    RAISING cx_apc_error.
ENDINTERFACE.