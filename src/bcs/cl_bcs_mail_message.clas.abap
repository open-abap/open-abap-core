CLASS cl_bcs_mail_message DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES ty_address TYPE c LENGTH 512.
    TYPES ty_subject TYPE c LENGTH 1024.
    TYPES ty_status TYPE c.
    TYPES ty_creation_time TYPE p LENGTH 11 DECIMALS 7.
    TYPES ty_mail_id TYPE x LENGTH 16.
* the copy type, data element BCS_MSG_COPY on a system
    TYPES ty_copy_base TYPE c LENGTH 1.
    TYPES:
      BEGIN OF ENUM ty_copy BASE TYPE ty_copy_base,
        to  VALUE IS INITIAL,
        cc  VALUE 'C',
        bcc VALUE 'B',
      END OF ENUM ty_copy.
    TYPES:
      BEGIN OF tys_status,
        recipient TYPE ty_address,
        status    TYPE ty_status,
      END OF tys_status.
    TYPES tyt_status TYPE STANDARD TABLE OF tys_status WITH DEFAULT KEY.
    TYPES:
      BEGIN OF tys_recipient,
        address TYPE ty_address,
        copy    TYPE ty_copy,
      END OF tys_recipient.
    TYPES tyt_recipient TYPE STANDARD TABLE OF tys_recipient WITH EMPTY KEY.
    TYPES:
      BEGIN OF tys_exception,
        exception TYPE REF TO cx_bcs_mail,
      END OF tys_exception.
    TYPES tyt_exceptions TYPE STANDARD TABLE OF tys_exception WITH DEFAULT KEY.

    CLASS-METHODS create_instance
      RETURNING
        VALUE(ro_mail_message) TYPE REF TO cl_bcs_mail_message
      RAISING
        cx_bcs_mail.

    METHODS send
      EXPORTING
        et_status      TYPE tyt_status
        ev_mail_status TYPE ty_status
      RAISING
        cx_bcs_mail.

    METHODS check
      EXPORTING
        et_exceptions    TYPE tyt_exceptions
      RETURNING
        VALUE(rv_all_ok) TYPE abap_bool.

    METHODS add_recipient
      IMPORTING
        iv_address TYPE ty_address
        iv_copy    TYPE ty_copy DEFAULT to
      RAISING
        cx_bcs_mail.

    METHODS add_attachment
      IMPORTING
        io_attachment TYPE REF TO cl_bcs_mail_bodypart
      RAISING
        cx_bcs_mail.

    METHODS add_main_alternative
      IMPORTING
        io_alternative TYPE REF TO cl_bcs_mail_bodypart
      RAISING
        cx_bcs_mail.

    METHODS set_sender
      IMPORTING
        iv_address TYPE ty_address
      RAISING
        cx_bcs_mail.

    METHODS set_subject
      IMPORTING
        iv_subject TYPE ty_subject.

    METHODS set_main
      IMPORTING
        io_main TYPE REF TO cl_bcs_mail_bodypart
      RAISING
        cx_bcs_mail.

    METHODS get_mail_id
      RETURNING
        VALUE(rv_request_id) TYPE ty_mail_id.

    METHODS get_subject
      RETURNING
        VALUE(rv_subject) TYPE ty_subject.

    METHODS get_sender
      RETURNING
        VALUE(rv_sender) TYPE ty_address.

    METHODS get_recipients
      RETURNING
        VALUE(rt_recipients) TYPE tyt_recipient.

    METHODS get_creation_time
      RETURNING
        VALUE(rv_creation_time) TYPE ty_creation_time.

  PRIVATE SECTION.
    TYPES ty_bodyparts TYPE STANDARD TABLE OF REF TO cl_bcs_mail_bodypart WITH EMPTY KEY.

    DATA mv_sender TYPE ty_address.
    DATA mv_subject TYPE ty_subject.
    DATA mt_recipients TYPE tyt_recipient.
    DATA mo_main TYPE REF TO cl_bcs_mail_bodypart.
    DATA mt_alternatives TYPE ty_bodyparts.
    DATA mt_attachments TYPE ty_bodyparts.

ENDCLASS.

CLASS cl_bcs_mail_message IMPLEMENTATION.

  METHOD create_instance.
    CREATE OBJECT ro_mail_message.
  ENDMETHOD.

  METHOD send.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD check.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD add_recipient.
    DATA ls_recipient LIKE LINE OF mt_recipients.

    ls_recipient-address = iv_address.
    ls_recipient-copy = iv_copy.
    APPEND ls_recipient TO mt_recipients.
  ENDMETHOD.

  METHOD add_attachment.
    APPEND io_attachment TO mt_attachments.
  ENDMETHOD.

  METHOD add_main_alternative.
    APPEND io_alternative TO mt_alternatives.
  ENDMETHOD.

  METHOD set_sender.
    mv_sender = iv_address.
  ENDMETHOD.

  METHOD set_subject.
    mv_subject = iv_subject.
  ENDMETHOD.

  METHOD set_main.
    mo_main = io_main.
  ENDMETHOD.

  METHOD get_mail_id.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_subject.
    rv_subject = mv_subject.
  ENDMETHOD.

  METHOD get_sender.
    rv_sender = mv_sender.
  ENDMETHOD.

  METHOD get_recipients.
    rt_recipients = mt_recipients.
  ENDMETHOD.

  METHOD get_creation_time.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
