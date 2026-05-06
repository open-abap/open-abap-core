INTERFACE if_os_persistency_manager PUBLIC.

  METHODS get_update_mode
    RETURNING
      VALUE(result) TYPE os_dmode.

ENDINTERFACE.