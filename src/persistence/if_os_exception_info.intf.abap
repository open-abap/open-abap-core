INTERFACE if_os_exception_info PUBLIC.

  DATA id TYPE t100-arbgb READ-ONLY.
  DATA number TYPE t100-msgnr READ-ONLY.

  METHODS clear.

  METHODS get_context_object
    IMPORTING
      i_id          TYPE string OPTIONAL
    RETURNING
      VALUE(result) TYPE REF TO object
    EXCEPTIONS
      os_exception.

  METHODS get_context_object_tab
    IMPORTING
      i_id          TYPE string OPTIONAL
    RETURNING
      VALUE(result) TYPE ostyp_ref_tab
    EXCEPTIONS
      os_exception.

  METHODS get_context_string
    IMPORTING
      i_id          TYPE string OPTIONAL
    RETURNING
      VALUE(result) TYPE string
    EXCEPTIONS
      os_exception.

  METHODS get_message
    RETURNING
      VALUE(result) TYPE string.

ENDINTERFACE.