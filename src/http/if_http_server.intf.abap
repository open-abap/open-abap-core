INTERFACE if_http_server PUBLIC.

  DATA response TYPE REF TO if_http_response.
  DATA request TYPE REF TO if_http_request.

  CONSTANTS authmethod_service             TYPE i VALUE 4.
  CONSTANTS co_compress_based_on_mime_type TYPE i VALUE 2.
  CONSTANTS co_disabled                    TYPE i VALUE 0.
  CONSTANTS co_enabled                     TYPE i VALUE 1.
  CONSTANTS co_page_error_type             TYPE c LENGTH 1 VALUE '1'.
  CONSTANTS co_response_page_option        TYPE c LENGTH 1 VALUE ' '.

  CLASS-DATA session_id TYPE string READ-ONLY.
  CLASS-DATA authentication_method TYPE i READ-ONLY.
  CLASS-DATA authenticated TYPE i READ-ONLY.

  METHODS logoff
    IMPORTING
      delete_mysapsso2_cookie TYPE abap_bool OPTIONAL
      propagate_logoff        TYPE abap_bool OPTIONAL
      redirect_url            TYPE string OPTIONAL.

  METHODS set_session_stateful
    IMPORTING
      stateful TYPE i DEFAULT co_enabled
      path     TYPE string OPTIONAL.

  CLASS-METHODS append_field_url
    IMPORTING
      name  TYPE string
      value TYPE string
    CHANGING
      url   TYPE string.

  METHODS create_abs_url
    IMPORTING
      protocol    TYPE string OPTIONAL
      post        TYPE string OPTIONAL
      port        TYPE string OPTIONAL
      path        TYPE string OPTIONAL
      querystring TYPE string OPTIONAL
    RETURNING
      VALUE(url)  TYPE string.

  METHODS create_rel_url
    IMPORTING
      path        TYPE string OPTIONAL
      querystring TYPE string OPTIONAL
    RETURNING
      VALUE(url)  TYPE string.

  CLASS-METHODS decode_base64
    IMPORTING
      encoded        TYPE string
    RETURNING
      VALUE(decoded) TYPE string.

  METHODS enable_foreign_session_access
    IMPORTING
      url_path              TYPE string
      user_id               TYPE syuname OPTIONAL
      one_time_access_token TYPE abap_bool DEFAULT abap_true
    EXPORTING
      session_access_token  TYPE string
    EXCEPTIONS
      url_path_is_not_supported
      user_unknown
      session_is_not_stateful
      internal_error.

  CLASS-METHODS encode_base64
    IMPORTING
      unencoded      TYPE string
    RETURNING
      VALUE(encoded) TYPE string.

  CLASS-METHODS escape_html
    IMPORTING
      unescaped      TYPE string
    RETURNING
      VALUE(escaped) TYPE string.

  CLASS-METHODS escape_url
    IMPORTING
      unescaped      TYPE string
    RETURNING
      VALUE(escaped) TYPE string.

  CLASS-METHODS get_extension_info
    IMPORTING
      extension_class TYPE string OPTIONAL
    EXPORTING
      urls            TYPE string_table.

  CLASS-METHODS get_extension_url
    IMPORTING
      extension_class TYPE string
    EXPORTING
      urls            TYPE string_table.

  METHODS get_last_error
    RETURNING
      VALUE(rc) TYPE i.

  CLASS-METHODS get_location
    IMPORTING
      protocol            TYPE csequence OPTIONAL
      application         TYPE csequence OPTIONAL
      for_domain          TYPE csequence OPTIONAL
      server              TYPE REF TO if_http_server OPTIONAL
      use_ticket_protocol TYPE abap_bool DEFAULT abap_true
    EXPORTING
      host                TYPE string
      port                TYPE string
      out_protocol        TYPE string
      vh_switch           TYPE abap_bool
    RETURNING
      VALUE(url_part)     TYPE string.

  CLASS-METHODS get_location_exception
    IMPORTING
      protocol            TYPE csequence OPTIONAL
      application         TYPE csequence OPTIONAL
      for_domain          TYPE csequence OPTIONAL
      server              TYPE REF TO if_http_server OPTIONAL
      use_ticket_protocol TYPE abap_bool DEFAULT abap_true
    EXPORTING
      host                TYPE string
      port                TYPE string
      out_protocol        TYPE string
      vh_switch           TYPE abap_bool
    RETURNING
      VALUE(url_part)     TYPE string.

  METHODS get_xsrf_token
    EXPORTING
      token TYPE string
    EXCEPTIONS
      internal_error
      called_by_public_service.

  METHODS send_page.

  METHODS set_compression
    IMPORTING
      options TYPE i DEFAULT co_compress_based_on_mime_type
    EXCEPTIONS
      compression_not_possible.

  METHODS set_page
    IMPORTING
      response_page_type           TYPE char1 DEFAULT co_page_error_type
      response_option              TYPE char1 DEFAULT co_response_page_option
      response_option_page         TYPE any OPTIONAL
      response_option_redirect_url TYPE any OPTIONAL
    EXCEPTIONS
      invalid_parameter
      document_not_found.

  METHODS set_session_stateful_via_url
    IMPORTING
      stateful    TYPE i DEFAULT co_enabled
    CHANGING
      rewrite_url TYPE string OPTIONAL.

  CLASS-METHODS unescape_url
    IMPORTING
      escaped          TYPE string
    RETURNING
      VALUE(unescaped) TYPE string.

  METHODS validate_xsrf_token
    IMPORTING
      token      TYPE string OPTIONAL
    EXPORTING
      successful TYPE abap_bool
    EXCEPTIONS
      token_not_found
      cookie_not_found
      internal_error
      called_by_public_service.

ENDINTERFACE.