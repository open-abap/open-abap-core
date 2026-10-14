CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS sender_and_subject FOR TESTING RAISING cx_static_check.
    METHODS recipients FOR TESTING RAISING cx_static_check.
    METHODS body_parts FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD sender_and_subject.
    DATA lo_mail TYPE REF TO cl_bcs_mail_message.

    lo_mail = cl_bcs_mail_message=>create_instance( ).
    lo_mail->set_sender( 'noreply@example.com' ).
    lo_mail->set_subject( 'Hello' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_mail->get_sender( )
      exp = 'noreply@example.com' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_mail->get_subject( )
      exp = 'Hello' ).
  ENDMETHOD.

  METHOD recipients.
    DATA lo_mail       TYPE REF TO cl_bcs_mail_message.
    DATA lt_recipients TYPE cl_bcs_mail_message=>tyt_recipient.
    DATA ls_recipient  LIKE LINE OF lt_recipients.

    lo_mail = cl_bcs_mail_message=>create_instance( ).
    lo_mail->add_recipient( 'to@example.com' ).
    lo_mail->add_recipient(
      iv_address = 'cc@example.com'
      iv_copy    = cl_bcs_mail_message=>cc ).
    lo_mail->add_recipient(
      iv_address = 'bcc@example.com'
      iv_copy    = cl_bcs_mail_message=>bcc ).

    lt_recipients = lo_mail->get_recipients( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_recipients )
      exp = 3 ).

    READ TABLE lt_recipients INDEX 1 INTO ls_recipient.
    cl_abap_unit_assert=>assert_equals(
      act = ls_recipient-address
      exp = 'to@example.com' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_recipient-copy
      exp = cl_bcs_mail_message=>to ).

    READ TABLE lt_recipients INDEX 2 INTO ls_recipient.
    cl_abap_unit_assert=>assert_equals(
      act = ls_recipient-address
      exp = 'cc@example.com' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_recipient-copy
      exp = cl_bcs_mail_message=>cc ).

    READ TABLE lt_recipients INDEX 3 INTO ls_recipient.
    cl_abap_unit_assert=>assert_equals(
      act = ls_recipient-address
      exp = 'bcc@example.com' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_recipient-copy
      exp = cl_bcs_mail_message=>bcc ).
  ENDMETHOD.

  METHOD body_parts.
    DATA lo_mail TYPE REF TO cl_bcs_mail_message.

    lo_mail = cl_bcs_mail_message=>create_instance( ).
    lo_mail->set_main( cl_bcs_mail_textpart=>create_text_html( `<p>hello</p>` ) ).
    lo_mail->add_main_alternative( cl_bcs_mail_textpart=>create_text_plain( `hello` ) ).
    lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
      iv_content      = 'CAFE'
      iv_content_type = 'application/octet-stream'
      iv_filename     = `blob.bin` ) ).

    cl_abap_unit_assert=>assert_bound( lo_mail ).
  ENDMETHOD.

ENDCLASS.
