INTERFACE if_os_ca_persistency PUBLIC.

  METHODS get_persistent_by_key
    IMPORTING
      i_key         TYPE any
    RETURNING
      VALUE(result) TYPE REF TO object
    RAISING
      cx_os_object_not_found
      cx_os_class_not_found.

ENDINTERFACE.