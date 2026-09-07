INTERFACE if_os_clone PUBLIC.

  METHODS clone
    RETURNING
      VALUE(result) TYPE REF TO object.

ENDINTERFACE.
