CLASS cl_send_request_bcs DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS set_expires_on
      IMPORTING
        i_expires_on TYPE any
      RAISING
        cx_os_object_not_found.

    METHODS set_send_at
      IMPORTING
        i_send_at TYPE any
      RAISING
        cx_os_object_not_found.

    METHODS set_link_to_outbox
      IMPORTING
        i_link_to_outbox TYPE abap_bool
      RAISING
        cx_os_object_not_found.
ENDCLASS.

CLASS cl_send_request_bcs IMPLEMENTATION.
  METHOD set_link_to_outbox.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_send_at.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_expires_on.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.