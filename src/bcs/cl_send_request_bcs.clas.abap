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

    METHODS set_disclosure
      IMPORTING
        i_disclosure TYPE any
      RAISING
      cx_os_object_not_found.

    METHODS create_link
      IMPORTING
        i_object TYPE any
      RAISING
        cx_os_object_not_found.

    CLASS-METHODS getu_ref_by_oid
      IMPORTING
        i_oid         TYPE os_guid
      RETURNING
        VALUE(result) TYPE REF TO cl_send_request_bcs
      RAISING
        cx_send_req_bcs.

    METHODS get_document
      RETURNING
        VALUE(result) TYPE REF TO if_document_bcs
      RAISING
        cx_send_req_bcs.

    METHODS get_sender
      RETURNING
        VALUE(result) TYPE REF TO if_sender_bcs
      RAISING
        cx_send_req_bcs.

    METHODS getu_message_subject_long
      RETURNING
        VALUE(result) TYPE string
      RAISING
        cx_send_req_bcs.
ENDCLASS.

CLASS cl_send_request_bcs IMPLEMENTATION.
  METHOD getu_ref_by_oid.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_document.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_sender.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD getu_message_subject_long.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_disclosure.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD set_link_to_outbox.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_send_at.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_expires_on.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD create_link.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.