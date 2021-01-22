CLASS lcl_response DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_http_response.
  PRIVATE SECTION.
    DATA status TYPE i.
    DATA cdata TYPE string.
ENDCLASS.

CLASS lcl_response IMPLEMENTATION.

  METHOD if_http_response~get_header_field.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_response~get_status.
    code = status.
  ENDMETHOD.

  METHOD if_http_response~get_cdata.
    data = cdata.
  ENDMETHOD.

  METHOD if_http_response~get_content_type.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_response~get_data.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_request DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_http_request.
    METHODS constructor IMPORTING uri TYPE string.
  PRIVATE SECTION.
    DATA mv_method TYPE string.
    DATA mt_headers TYPE tihttpnvp.
    DATA mt_form_fields TYPE tihttpnvp.
ENDCLASS.

CLASS lcl_request IMPLEMENTATION.

  METHOD constructor.
    DATA ls_header LIKE LINE OF mt_headers.
    ls_header-name = '~request_uri'.
    ls_header-value = uri.
    APPEND ls_header TO mt_headers.
  ENDMETHOD.

  METHOD if_http_request~get_form_fields.
    fields = mt_form_fields.
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
  ENDMETHOD.

  METHOD if_http_request~get_header_field.
    DATA ls_header LIKE LINE OF mt_headers.
    READ TABLE mt_headers WITH KEY name = to_lower( field ) INTO ls_header.
    IF sy-subrc = 0.
      value = ls_header-value.
    ENDIF.
  ENDMETHOD.

  METHOD if_http_request~set_method.
    mv_method = meth.
  ENDMETHOD.

  METHOD if_http_request~get_method.
    meth = mv_method.
  ENDMETHOD.

  METHOD if_http_request~set_version.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~set_data.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~set_cdata.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~set_form_field.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_request~get_header_fields.
    fields = mt_headers.
  ENDMETHOD.

ENDCLASS.