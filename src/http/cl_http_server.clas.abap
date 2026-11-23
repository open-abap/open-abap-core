CLASS cl_http_server DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_http_server.

    ALIASES co_enabled FOR if_http_server~co_enabled.
    ALIASES append_field_url FOR if_http_server~append_field_url.
    ALIASES get_location FOR if_http_server~get_location.


    CLASS-DATA c_compression_supported TYPE i.
    DATA m_protocol_version TYPE string READ-ONLY.

ENDCLASS.

CLASS cl_http_server IMPLEMENTATION.
  METHOD if_http_server~logoff.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~set_session_stateful.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~append_field_url.
* name and value are escaped as by ESCAPE_URL; a fragment is not looked at
    DATA lv_separator TYPE string.
    IF url CA '?'.
      lv_separator = '&'.
    ELSE.
      lv_separator = '?'.
    ENDIF.
    url = url && lv_separator
      && cl_http_utility=>do_escape_url( name ) && '='
      && cl_http_utility=>do_escape_url( value ).
  ENDMETHOD.

  METHOD if_http_server~create_abs_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~create_rel_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~decode_base64.
    decoded = cl_http_utility=>do_decode_base64( encoded ).
  ENDMETHOD.

  METHOD if_http_server~enable_foreign_session_access.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~encode_base64.
    encoded = cl_http_utility=>do_encode_base64( unencoded ).
  ENDMETHOD.

  METHOD if_http_server~escape_html.
    escaped = cl_http_utility=>do_escape_html( unescaped ).
  ENDMETHOD.

  METHOD if_http_server~escape_url.
    escaped = cl_http_utility=>do_escape_url( unescaped ).
  ENDMETHOD.

  METHOD if_http_server~get_extension_info.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~get_extension_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~get_last_error.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~get_location.
    host = 'localhost'.
    port = '8080'.
    " no HTTPS support for now
    out_protocol = 'http'.
  ENDMETHOD.

  METHOD if_http_server~get_location_exception.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~get_xsrf_token.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~send_page.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~set_compression.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~set_page.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~set_session_stateful_via_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~unescape_url.
* as CL_HTTP_UTILITY, but without an error code: a failure gives an empty result
    cl_http_utility=>do_unescape_url(
      EXPORTING
        escaped   = escaped
      IMPORTING
        unescaped = unescaped ).
  ENDMETHOD.

  METHOD if_http_server~validate_xsrf_token.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
