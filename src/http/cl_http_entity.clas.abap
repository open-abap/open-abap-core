CLASS cl_http_entity DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_http_response.
    INTERFACES if_http_request.
  PRIVATE SECTION.
    DATA mv_status       TYPE i.
    DATA mv_reason       TYPE string.
    DATA mv_content_type TYPE string.
    DATA mv_method       TYPE string.
    DATA mv_data         TYPE xstring.
    DATA mt_headers      TYPE tihttpnvp.
    DATA mt_form_fields  TYPE tihttpnvp.
ENDCLASS.

CLASS cl_http_entity IMPLEMENTATION.
  METHOD if_http_request~get_user_agent.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~get_uri_parameter.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~get_raw_message.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~get_form_data.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~get_authorization.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~copy.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~set_authorization.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~add_multipart.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_cookie_field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~set_compression.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~append_cdata.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~append_cdata2.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~add_cookie_field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~append_data.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~to_xstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~delete_cookie_secure.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_cookies.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~delete_form_field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~delete_form_field_secure.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_cookie.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_data_length.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~from_xstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_form_field_cs.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_last_error.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~delete_header_field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~delete_header_field_secure.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~delete_cookie.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~set_header_fields.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~suppress_content_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~set_formfield_encoding.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~set_cookie.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_version.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_serialized_message_length.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_header_field.
    DATA ls_header LIKE LINE OF mt_headers.
    READ TABLE mt_headers WITH KEY name = to_lower( name ) INTO ls_header.
    IF sy-subrc = 0.
      value = ls_header-value.
    ENDIF.
  ENDMETHOD.

  METHOD if_http_entity~get_header_fields.
    fields = mt_headers.
  ENDMETHOD.

  METHOD if_http_response~get_status.
    code = mv_status.
    reason = mv_reason.
  ENDMETHOD.

  METHOD if_http_entity~get_cdata.
    cl_abap_conv_in_ce=>create( encoding = 'UTF-8' )->convert(
      EXPORTING input = mv_data
      IMPORTING data = data ).
  ENDMETHOD.

  METHOD if_http_response~set_status.
    mv_status = code.
    mv_reason = reason.
  ENDMETHOD.

  METHOD if_http_entity~set_cdata.
    cl_abap_conv_out_ce=>create( encoding = 'UTF-8' )->convert(
      EXPORTING data = data
      IMPORTING buffer = mv_data ).
  ENDMETHOD.

  METHOD if_http_entity~get_content_type.
    val = mv_content_type.
  ENDMETHOD.

  METHOD if_http_entity~set_content_type.
    mv_content_type = content_type.
  ENDMETHOD.

  METHOD if_http_entity~get_data.
    data = mv_data.
  ENDMETHOD.

  METHOD if_http_entity~set_data.
    mv_data = data.
  ENDMETHOD.

  METHOD if_http_response~delete_cookie_at_client.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_response~redirect.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~num_multiparts.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_multipart.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~get_form_fields_cs.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~set_form_fields.
    mt_form_fields = fields.
  ENDMETHOD.

  METHOD if_http_entity~get_form_fields.
    fields = mt_form_fields.
  ENDMETHOD.

  METHOD if_http_entity~get_form_field.
    DATA ls_field LIKE LINE OF mt_form_fields.
    READ TABLE mt_form_fields INTO ls_field WITH KEY name = to_lower( name ).
    IF sy-subrc = 0.
      value = ls_field-value.
    ENDIF.
  ENDMETHOD.

  METHOD if_http_entity~set_header_field.
    DATA ls_header LIKE LINE OF mt_headers.
    FIELD-SYMBOLS <ls_header> LIKE LINE OF mt_headers.
    READ TABLE mt_headers WITH KEY name = to_lower( name ) ASSIGNING <ls_header>.
    IF sy-subrc = 0.
      <ls_header>-value = value.
    ELSE.
      ls_header-name = to_lower( name ).
      ls_header-value = value.
      APPEND ls_header TO mt_headers.
    ENDIF.
    IF name = '~request_method'.
      if_http_request~set_method( value ).
    ENDIF.
  ENDMETHOD.

  METHOD if_http_request~set_method.
    mv_method = method.
  ENDMETHOD.

  METHOD if_http_request~get_method.
    meth = mv_method.
  ENDMETHOD.

  METHOD if_http_request~set_version.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_entity~set_form_field.
    DATA ls_field LIKE LINE OF mt_form_fields.
    ls_field-name = name.
    ls_field-value = value.
    APPEND ls_field TO mt_form_fields.
  ENDMETHOD.

ENDCLASS.