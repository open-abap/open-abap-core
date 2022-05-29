CLASS cl_http_entity DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_http_response.
    INTERFACES if_http_request.
  PRIVATE SECTION.
    DATA mv_status TYPE i.
    DATA mv_reason TYPE string.
    DATA content_type TYPE string.
    DATA mv_method TYPE string.
    DATA mv_data TYPE xstring.
    DATA mt_headers TYPE tihttpnvp.
    DATA mt_form_fields TYPE tihttpnvp.
ENDCLASS.

CLASS cl_http_entity IMPLEMENTATION.

  METHOD if_http_response~set_header_field.
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
  ENDMETHOD.

  METHOD if_http_response~get_header_field.
    DATA ls_header LIKE LINE OF mt_headers.
    READ TABLE mt_headers WITH KEY name = to_lower( name ) INTO ls_header.
    IF sy-subrc = 0.
      value = ls_header-value.
    ENDIF.
  ENDMETHOD.

  METHOD if_http_response~get_header_fields.
    fields = mt_headers.
  ENDMETHOD.

  METHOD if_http_response~get_status.
    code = mv_status.
    reason = mv_reason.
  ENDMETHOD.

  METHOD if_http_response~get_cdata.
    cl_abap_conv_in_ce=>create( encoding = 'UTF-8' )->convert(
      EXPORTING input = mv_data
      IMPORTING data = data ).
  ENDMETHOD.

  METHOD if_http_response~set_status.
    mv_status = code.
    mv_reason = reason.
  ENDMETHOD.

  METHOD if_http_response~set_cdata.
    cl_abap_conv_out_ce=>create( encoding = 'UTF-8' )->convert(
      EXPORTING data = data
      IMPORTING buffer = mv_data ).
  ENDMETHOD.

  METHOD if_http_response~get_content_type.
    val = content_type.
  ENDMETHOD.

  METHOD if_http_response~set_content_type.
    content_type = val.
  ENDMETHOD.

  METHOD if_http_request~set_content_type.
    content_type = val.
  ENDMETHOD.

  METHOD if_http_response~get_data.
    val = mv_data.
  ENDMETHOD.

  METHOD if_http_response~set_data.
    mv_data = val.
  ENDMETHOD.

*****************************************

  METHOD if_http_request~set_form_fields.
    mt_form_fields = fields.
  ENDMETHOD.

  METHOD if_http_request~get_form_fields.
    fields = mt_form_fields.
  ENDMETHOD.

  METHOD if_http_request~get_form_field.
    DATA ls_field LIKE LINE OF mt_form_fields.
    READ TABLE mt_form_fields INTO ls_field WITH KEY name = to_lower( name ).
    IF sy-subrc = 0.
      value = ls_field-value.
    ENDIF.
  ENDMETHOD.

  METHOD if_http_request~set_header_field.
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

  METHOD if_http_request~get_header_field.
    DATA ls_header LIKE LINE OF mt_headers.
    READ TABLE mt_headers WITH KEY name = to_lower( name ) INTO ls_header.
    IF sy-subrc = 0.
      value = ls_header-value.
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

  METHOD if_http_request~set_data.
    mv_data = data.
  ENDMETHOD.

  METHOD if_http_request~get_data.
    data = mv_data.
  ENDMETHOD.

  METHOD if_http_request~set_cdata.
    cl_abap_conv_out_ce=>create( encoding = 'UTF-8' )->convert(
      EXPORTING data = data
      IMPORTING buffer = mv_data ).
  ENDMETHOD.

  METHOD if_http_request~get_cdata.
    cl_abap_conv_in_ce=>create( encoding = 'UTF-8' )->convert(
      EXPORTING input = mv_data
      IMPORTING data = data ).
  ENDMETHOD.

  METHOD if_http_request~set_form_field.
    DATA ls_field LIKE LINE OF mt_form_fields.
    ls_field-name = name.
    ls_field-value = value.
    APPEND ls_field TO mt_form_fields.
  ENDMETHOD.

  METHOD if_http_request~get_header_fields.
    fields = mt_headers.
  ENDMETHOD.

ENDCLASS.