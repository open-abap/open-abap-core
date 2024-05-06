CLASS cl_bcs DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create_persistent
      RETURNING
        VALUE(result) TYPE REF TO cl_bcs
      RAISING
        cx_bcs.

    METHODS add_recipient
      IMPORTING
        i_recipient  TYPE REF TO if_recipient_bcs
        i_express    TYPE abap_bool OPTIONAL
        i_copy       TYPE abap_bool OPTIONAL
        i_blind_copy TYPE abap_bool OPTIONAL
        i_no_forward TYPE abap_bool OPTIONAL
      RAISING
        cx_bcs.

    METHODS set_sender
      IMPORTING
        i_sender TYPE REF TO if_sender_bcs
      RAISING
        cx_bcs.

    METHODS set_status_attributes
      IMPORTING
        i_requested_status TYPE any.

    METHODS set_document
      IMPORTING
        i_document TYPE REF TO if_document_bcs
      RAISING
        cx_bcs.

    METHODS set_message_subject
      IMPORTING
        ip_subject TYPE string
      RAISING
        cx_bcs.

    METHODS send
      IMPORTING
        i_with_error_screen TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(result)       TYPE abap_bool
      RAISING
        cx_bcs.

    METHODS set_send_immediately
      IMPORTING
        i_send_immediately TYPE abap_bool
      RAISING
        cx_bcs.
ENDCLASS.

CLASS cl_bcs IMPLEMENTATION.

  METHOD set_document.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_status_attributes.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_send_immediately.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_message_subject.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_sender.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD send.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD create_persistent.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD add_recipient.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.