INTERFACE if_os_state PUBLIC.

  EVENTS changed.
  EVENTS write_access.
  EVENTS read_access.

  METHODS handle_exception
    IMPORTING
      i_exception TYPE REF TO if_os_exception_info OPTIONAL
      i_ex_os     TYPE REF TO cx_os_object_not_found OPTIONAL
    RAISING
      cx_os_object_not_found.

  METHODS get
    RETURNING
      VALUE(result) TYPE REF TO object.
  METHODS init.

  METHODS set
    IMPORTING
      i_state TYPE REF TO object.

  METHODS invalidate.

ENDINTERFACE.