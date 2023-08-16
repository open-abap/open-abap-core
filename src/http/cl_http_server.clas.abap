CLASS cl_http_server DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_http_server.

    ALIASES co_enabled FOR if_http_server~co_enabled.

    CLASS-DATA c_compression_supported TYPE i.
    DATA m_protocol_version TYPE string READ-ONLY.

    CLASS-METHODS get_location
      IMPORTING
        application TYPE csequence OPTIONAL
      EXPORTING
        port         TYPE string
        out_protocol TYPE string
        host         TYPE string.
ENDCLASS.

CLASS cl_http_server IMPLEMENTATION.
  METHOD if_http_server~logoff.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~set_session_stateful.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~append_field_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~create_abs_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~create_rel_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~decode_base64.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~enable_foreign_session_access.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~encode_base64.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~escape_html.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~escape_url.
    ASSERT 1 = 'todo'.
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
    ASSERT 1 = 'todo'.
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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_server~validate_xsrf_token.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_location.
    host = 'open-abap.org'.
  ENDMETHOD.
ENDCLASS.