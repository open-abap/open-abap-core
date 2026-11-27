INTERFACE if_sender_bcs PUBLIC.

  METHODS address_string
    RETURNING
      VALUE(result) TYPE string
    RAISING
      cx_address_bcs.

ENDINTERFACE.
