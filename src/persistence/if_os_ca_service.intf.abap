INTERFACE if_os_ca_service PUBLIC.

  METHODS save_in_update_task
    IMPORTING
      xcontainer TYPE xstring OPTIONAL.
  METHODS save.

ENDINTERFACE.