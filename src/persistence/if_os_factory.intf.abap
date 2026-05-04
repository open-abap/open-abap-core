INTERFACE if_os_factory PUBLIC.

  METHODS create_persistent_by_key
    IMPORTING
      i_key         TYPE any
    RETURNING
      VALUE(result) TYPE REF TO object
    RAISING
      cx_os_object_existing.

  METHODS create_transient_by_key
    IMPORTING
      i_key         TYPE any
    RETURNING
      VALUE(result) TYPE REF TO object
    RAISING
      cx_os_object_existing.

ENDINTERFACE.