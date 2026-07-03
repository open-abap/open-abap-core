CLASS cl_bcs DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA send_request TYPE REF TO cl_send_request_bcs READ-ONLY.

    CONSTANTS gc_direct TYPE char1 VALUE 'D'.
    CONSTANTS gc_retry TYPE char1 VALUE 'R'.
    CONSTANTS gc_future TYPE char1 VALUE 'F'.
    CONSTANTS gc_incons TYPE char1 VALUE 'X'.
    CONSTANTS gc_ok TYPE char1 VALUE 'I'.

    CLASS-METHODS create_persistent
      RETURNING
        VALUE(result) TYPE REF TO cl_bcs
      RAISING
        cx_bcs.

    METHODS document
      RETURNING
        VALUE(result) TYPE REF TO if_document_bcs
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
        i_requested_status TYPE any
        i_status_mail      TYPE any OPTIONAL.

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

    METHODS set_disclosure
      IMPORTING
        i_disclosure TYPE any.

    METHODS set_priority
      IMPORTING
        i_priority TYPE any
      RAISING
        cx_send_req_bcs.

    METHODS create_link_to_app
      IMPORTING
        i_app_instance TYPE any
      RAISING
        cx_send_req_bcs.

ENDCLASS.

CLASS cl_bcs IMPLEMENTATION.
  METHOD create_link_to_app.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD set_priority.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD set_disclosure.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD document.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

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