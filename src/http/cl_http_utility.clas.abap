CLASS cl_http_utility DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_utility.

    ALIASES decode_base64 FOR if_http_utility~decode_base64.
    ALIASES encode_base64 FOR if_http_utility~encode_base64.
    ALIASES escape_url FOR if_http_utility~escape_url.
    ALIASES fields_to_string FOR if_http_utility~fields_to_string.
    ALIASES get_last_error FOR if_http_utility~get_last_error.
    ALIASES string_to_fields FOR if_http_utility~string_to_fields.
    ALIASES unescape_url FOR if_http_utility~unescape_url.
    ALIASES normalize_url FOR if_http_utility~normalize_url.

    CLASS-METHODS decode_x_base64
      IMPORTING
        encoded        TYPE string
      RETURNING
        VALUE(decoded) TYPE xstring.

    CLASS-METHODS encode_x_base64
      IMPORTING
        unencoded      TYPE xstring
      RETURNING
        VALUE(encoded) TYPE string.

    CLASS-METHODS set_query
      IMPORTING
        request TYPE REF TO if_http_request
        query   TYPE string.

    CLASS-METHODS set_request_uri
      IMPORTING
        request TYPE REF TO if_http_request
        uri     TYPE string.

    CLASS-METHODS escape_xml_attr_value
      IMPORTING
        unescaped      TYPE csequence
      RETURNING
        VALUE(escaped) TYPE string.

    CLASS-METHODS escape_html
      IMPORTING
        unescaped         TYPE string
        keep_num_char_ref TYPE abap_bool DEFAULT abap_undefined
      RETURNING
        VALUE(escaped)    TYPE string.

    CLASS-METHODS escape_javascript
      IMPORTING
        unescaped      TYPE string
        inside_html    TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(escaped) TYPE string.

ENDCLASS.

CLASS cl_http_utility IMPLEMENTATION.

  METHOD set_request_uri.
    request->set_header_field(
      name = '~request_uri'
      value = uri ).
  ENDMETHOD.

  METHOD escape_html.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_javascript.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_xml_attr_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_utility~get_last_error.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_utility~string_to_fields.
    DATA tab TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA str LIKE LINE OF tab.
    DATA ls_field LIKE LINE OF fields.

    ASSERT ignore_parenthesis = 0.

    SPLIT string AT '&' INTO TABLE tab.
    LOOP AT tab INTO str.
      SPLIT str AT '=' INTO ls_field-name ls_field-value.
      APPEND ls_field TO fields.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_query.
    request->set_form_fields( string_to_fields( query ) ).
  ENDMETHOD.

  METHOD if_http_utility~normalize_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_utility~fields_to_string.
    DATA tab TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA str TYPE string.
    DATA ls_field LIKE LINE OF fields.

    LOOP AT fields INTO ls_field.
      ls_field-value = if_http_utility~escape_url( ls_field-value ).
      str = ls_field-name && '=' && ls_field-value.
      APPEND str TO tab.
    ENDLOOP.
    string = concat_lines_of( table = tab
                              sep = '&' ).
  ENDMETHOD.

  METHOD encode_x_base64.
    WRITE '@KERNEL let buffer = Buffer.from(unencoded.get(), "hex");'.
    WRITE '@KERNEL encoded.set(buffer.toString("base64"));'.
  ENDMETHOD.

  METHOD decode_x_base64.
    WRITE '@KERNEL let buffer = Buffer.from(encoded.get(), "base64");'.
    WRITE '@KERNEL decoded.set(buffer.toString("hex").toUpperCase());'.
  ENDMETHOD.

  METHOD if_http_utility~unescape_url.
    WRITE '@KERNEL let foo = escaped.get();'.
    WRITE '@KERNEL unescaped.set(decodeURIComponent(foo));'.
  ENDMETHOD.

  METHOD if_http_utility~escape_url.
    DATA lv_index TYPE i.
    DATA lv_char  TYPE string.

    DO strlen( unescaped ) TIMES.
      lv_index = sy-index - 1.
      lv_char = unescaped+lv_index(1).
      IF to_upper( lv_char ) CA sy-abcde OR lv_char CA '0123456789.-()'.
        escaped = escaped && lv_char.
      ELSE.
        escaped = escaped && '%' && to_lower( cl_abap_codepage=>convert_to( lv_char ) ).
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD if_http_utility~encode_base64.
    WRITE '@KERNEL let buffer = Buffer.from(unencoded.get());'.
    WRITE '@KERNEL encoded.set(buffer.toString("base64"));'.
  ENDMETHOD.

  METHOD if_http_utility~decode_base64.
    WRITE '@KERNEL let buffer = Buffer.from(encoded.get(), "base64");'.
    WRITE '@KERNEL decoded.set(buffer.toString());'.
  ENDMETHOD.
ENDCLASS.