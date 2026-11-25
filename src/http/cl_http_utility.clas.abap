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

  PRIVATE SECTION.
* the results of unescaping
    CONSTANTS:
      BEGIN OF c_error,
        ok                  TYPE i VALUE 0,
        null_character      TYPE i VALUE 3,
        invalid_escape      TYPE i VALUE 29,
        incomplete_utf8     TYPE i VALUE 512,
      END OF c_error.

    CLASS-DATA gv_last_error TYPE i.

    CLASS-METHODS do_escape_url
      IMPORTING
        unescaped      TYPE string
      RETURNING
        VALUE(escaped) TYPE string.

    CLASS-METHODS do_unescape_url
      IMPORTING
        escaped   TYPE string
      EXPORTING
        unescaped TYPE string
        rc        TYPE i.

    CLASS-METHODS do_escape_html
      IMPORTING
        unescaped         TYPE string
        keep_num_char_ref TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(escaped)    TYPE string.

    CLASS-METHODS do_encode_base64
      IMPORTING
        unencoded      TYPE string
      RETURNING
        VALUE(encoded) TYPE string.

    CLASS-METHODS do_decode_base64
      IMPORTING
        encoded        TYPE string
      RETURNING
        VALUE(decoded) TYPE string.

    CLASS-METHODS escape_html_text
      IMPORTING
        unescaped      TYPE string
      RETURNING
        VALUE(escaped) TYPE string.

    CLASS-METHODS hex_digit
      IMPORTING
        byte         TYPE x
      RETURNING
        VALUE(value) TYPE i.

    CLASS-METHODS decode_utf8
      IMPORTING
        bytes   TYPE xstring
      EXPORTING
        decoded TYPE string
        rc      TYPE i.

ENDCLASS.

CLASS cl_http_utility IMPLEMENTATION.

  METHOD set_request_uri.
    request->set_header_field(
      name  = '~request_uri'
      value = uri ).
  ENDMETHOD.

  METHOD escape_html.
* abap_undefined, the default, keeps no references either
    escaped = do_escape_html(
      unescaped         = unescaped
      keep_num_char_ref = boolc( keep_num_char_ref = abap_true ) ).
  ENDMETHOD.

  METHOD do_escape_html.
    DATA lt_results TYPE match_result_tab.
    DATA ls_result  LIKE LINE OF lt_results.
    DATA lv_offset  TYPE i.

    IF keep_num_char_ref = abap_false.
      escaped = escape_html_text( unescaped ).
      RETURN.
    ENDIF.

* only short references are kept: up to five decimal or four hex digits
    FIND ALL OCCURRENCES OF REGEX '&#([0-9]{1,5}|[xX][0-9a-fA-F]{1,4});'
      IN unescaped RESULTS lt_results.
    LOOP AT lt_results INTO ls_result.
      escaped = escaped
        && escape_html_text( substring( val = unescaped
                                        off = lv_offset
                                        len = ls_result-offset - lv_offset ) )
        && substring( val = unescaped
                      off = ls_result-offset
                      len = ls_result-length ).
      lv_offset = ls_result-offset + ls_result-length.
    ENDLOOP.
    escaped = escaped && escape_html_text( substring( val = unescaped
                                                      off = lv_offset ) ).
  ENDMETHOD.

  METHOD escape_html_text.
    escaped = unescaped.
    REPLACE ALL OCCURRENCES OF `&` IN escaped WITH `&amp;`.
    REPLACE ALL OCCURRENCES OF `<` IN escaped WITH `&lt;`.
    REPLACE ALL OCCURRENCES OF `>` IN escaped WITH `&gt;`.
    REPLACE ALL OCCURRENCES OF `"` IN escaped WITH `&quot;`.
    REPLACE ALL OCCURRENCES OF `'` IN escaped WITH `&#39;`.
  ENDMETHOD.

  METHOD escape_javascript.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_xml_attr_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_utility~get_last_error.
    rc = gv_last_error.
  ENDMETHOD.

  METHOD if_http_utility~string_to_fields.
    DATA tab TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA str LIKE LINE OF tab.
    DATA ls_field LIKE LINE OF fields.
    DATA lv_name  TYPE string.
    DATA lv_value TYPE string.
    DATA lv_text  TYPE string.
    DATA lv_rc    TYPE i.

    ASSERT ignore_parenthesis = 0.

* processing stops at the first field that cannot be unescaped
    SPLIT string AT '&' INTO TABLE tab.
    LOOP AT tab INTO str.
      CLEAR ls_field.
      SPLIT str AT '=' INTO lv_name lv_value.
      do_unescape_url(
        EXPORTING
          escaped   = lv_name
        IMPORTING
          unescaped = lv_text
          rc        = lv_rc ).
      ls_field-name = lv_text.
      IF lv_rc = c_error-ok.
        do_unescape_url(
          EXPORTING
            escaped   = lv_value
          IMPORTING
            unescaped = lv_text
            rc        = lv_rc ).
        ls_field-value = lv_text.
      ENDIF.
      APPEND ls_field TO fields.
      IF lv_rc <> c_error-ok.
        EXIT.
      ENDIF.
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
    DATA lv_name  TYPE string.
    DATA lv_value TYPE string.

    LOOP AT fields INTO ls_field.
      lv_name = do_escape_url( ls_field-name ).
      lv_value = do_escape_url( ls_field-value ).
      str = lv_name && '=' && lv_value.
      APPEND str TO tab.
    ENDLOOP.
    string = concat_lines_of( table = tab
                              sep   = '&' ).
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
* OPTIONS is not supported
    do_unescape_url(
      EXPORTING
        escaped   = escaped
      IMPORTING
        unescaped = unescaped
        rc        = gv_last_error ).
  ENDMETHOD.

  METHOD do_unescape_url.
* characters outside ASCII are taken as "#"; "+" is a blank. An escaped NUL
* (two non-hex digits count as one) gives error 3 and wins over a malformed
* or cut-off escape, error 29, which wins over a cut-off UTF-8 sequence, 512
    CONSTANTS lc_percent TYPE x LENGTH 1 VALUE '25'.
    CONSTANTS lc_plus TYPE x LENGTH 1 VALUE '2B'.
    CONSTANTS lc_blank TYPE x LENGTH 1 VALUE '20'.
    CONSTANTS lc_hash TYPE x LENGTH 1 VALUE '23'.

    DATA lv_utf8      TYPE xstring.
    DATA lv_ascii     TYPE xstring.
    DATA lv_bytes     TYPE xstring.
    DATA lv_byte      TYPE x LENGTH 1.
    DATA lv_value     TYPE i.
    DATA lv_high      TYPE i.
    DATA lv_low       TYPE i.
    DATA lv_len       TYPE i.
    DATA lv_pos       TYPE i.
    DATA lv_next      TYPE i.
    DATA lv_nul       TYPE abap_bool.
    DATA lv_malformed TYPE abap_bool.

    CLEAR unescaped.
    rc = c_error-ok.

    lv_utf8 = cl_abap_codepage=>convert_to( escaped ).
    lv_len = xstrlen( lv_utf8 ).
    WHILE lv_pos < lv_len.
      lv_byte = lv_utf8+lv_pos(1).
      lv_value = lv_byte.
      IF lv_value >= 192.
        CONCATENATE lv_ascii lc_hash INTO lv_ascii IN BYTE MODE.
      ELSEIF lv_value < 128.
        CONCATENATE lv_ascii lv_byte INTO lv_ascii IN BYTE MODE.
      ENDIF.
      lv_pos = lv_pos + 1.
    ENDWHILE.

    lv_len = xstrlen( lv_ascii ).
    lv_pos = 0.
    WHILE lv_pos < lv_len.
      lv_byte = lv_ascii+lv_pos(1).
      IF lv_byte = lc_percent.
        IF lv_pos + 2 >= lv_len.
          lv_malformed = abap_true.
          EXIT.
        ENDIF.
        lv_next = lv_pos + 1.
        lv_byte = lv_ascii+lv_next(1).
        lv_high = hex_digit( lv_byte ).
        lv_next = lv_pos + 2.
        lv_byte = lv_ascii+lv_next(1).
        lv_low = hex_digit( lv_byte ).
        IF lv_high < 0 AND lv_low < 0.
          lv_nul = abap_true.
        ELSEIF lv_high < 0 OR lv_low < 0.
          lv_malformed = abap_true.
        ELSE.
          lv_value = lv_high * 16 + lv_low.
          lv_byte = lv_value.
          IF lv_value = 0.
            lv_nul = abap_true.
          ENDIF.
          CONCATENATE lv_bytes lv_byte INTO lv_bytes IN BYTE MODE.
        ENDIF.
        lv_pos = lv_pos + 3.
      ELSE.
        IF lv_byte = lc_plus.
          lv_byte = lc_blank.
        ENDIF.
        CONCATENATE lv_bytes lv_byte INTO lv_bytes IN BYTE MODE.
        lv_pos = lv_pos + 1.
      ENDIF.
    ENDWHILE.

    IF lv_nul = abap_true.
      rc = c_error-null_character.
    ELSEIF lv_malformed = abap_true.
      rc = c_error-invalid_escape.
    ELSE.
      decode_utf8(
        EXPORTING
          bytes   = lv_bytes
        IMPORTING
          decoded = unescaped
          rc      = rc ).
    ENDIF.
  ENDMETHOD.

  METHOD hex_digit.
    value = byte.
    IF value >= 48 AND value <= 57.
      value = value - 48.
    ELSEIF value >= 65 AND value <= 70.
      value = value - 55.
    ELSEIF value >= 97 AND value <= 102.
      value = value - 87.
    ELSE.
      value = -1.
    ENDIF.
  ENDMETHOD.

  METHOD decode_utf8.
* a sequence cut off by the end of the input fails as a whole; other invalid
* bytes become U+FFFD: a stray byte or a lead byte without its continuation
* bytes one by one, an overlong or out of range sequence as one character
    CONSTANTS lc_replacement TYPE x LENGTH 3 VALUE 'EFBFBD'.

    DATA lv_fixed  TYPE xstring.
    DATA lv_seq    TYPE xstring.
    DATA lv_byte   TYPE x LENGTH 1.
    DATA lv_lead   TYPE i.
    DATA lv_second TYPE i.
    DATA lv_value  TYPE i.
    DATA lv_len    TYPE i.
    DATA lv_pos    TYPE i.
    DATA lv_next   TYPE i.
    DATA lv_need   TYPE i.
    DATA lv_valid  TYPE abap_bool.

    CLEAR decoded.
    rc = c_error-ok.

    lv_len = xstrlen( bytes ).
    WHILE lv_pos < lv_len.
      lv_byte = bytes+lv_pos(1).
      lv_lead = lv_byte.
      IF lv_lead < 128.
        CONCATENATE lv_fixed lv_byte INTO lv_fixed IN BYTE MODE.
        lv_pos = lv_pos + 1.
        CONTINUE.
      ELSEIF lv_lead < 192 OR lv_lead >= 254.
        CONCATENATE lv_fixed lc_replacement INTO lv_fixed IN BYTE MODE.
        lv_pos = lv_pos + 1.
        CONTINUE.
      ELSEIF lv_lead < 224.
        lv_need = 2.
      ELSEIF lv_lead < 240.
        lv_need = 3.
      ELSEIF lv_lead < 248.
        lv_need = 4.
      ELSEIF lv_lead < 252.
        lv_need = 5.
      ELSE.
        lv_need = 6.
      ENDIF.

      IF lv_pos + lv_need > lv_len.
        rc = c_error-incomplete_utf8.
        RETURN.
      ENDIF.

      lv_valid = abap_true.
      lv_next = lv_pos + 1.
      WHILE lv_next < lv_pos + lv_need.
        lv_byte = bytes+lv_next(1).
        lv_value = lv_byte.
        IF lv_value < 128 OR lv_value >= 192.
          lv_valid = abap_false.
          EXIT.
        ENDIF.
        lv_next = lv_next + 1.
      ENDWHILE.
      IF lv_valid = abap_false.
        CONCATENATE lv_fixed lc_replacement INTO lv_fixed IN BYTE MODE.
        lv_pos = lv_pos + 1.
        CONTINUE.
      ENDIF.

      lv_next = lv_pos + 1.
      lv_byte = bytes+lv_next(1).
      lv_second = lv_byte.
      IF lv_need >= 5
          OR lv_lead = 192 OR lv_lead = 193
          OR ( lv_lead = 224 AND lv_second < 160 )
          OR ( lv_lead = 237 AND lv_second >= 160 )
          OR ( lv_lead = 240 AND lv_second < 144 )
          OR ( lv_lead = 244 AND lv_second >= 144 )
          OR lv_lead >= 245.
        CONCATENATE lv_fixed lc_replacement INTO lv_fixed IN BYTE MODE.
      ELSE.
        lv_seq = bytes+lv_pos(lv_need).
        CONCATENATE lv_fixed lv_seq INTO lv_fixed IN BYTE MODE.
      ENDIF.
      lv_pos = lv_pos + lv_need.
    ENDWHILE.

    decoded = cl_abap_codepage=>convert_from( lv_fixed ).
  ENDMETHOD.

  METHOD if_http_utility~escape_url.
    escaped = do_escape_url( unescaped ).
  ENDMETHOD.

  METHOD do_escape_url.
    DATA lv_index TYPE i.
    DATA lv_char  TYPE string.
    DATA lv_hex   TYPE string.
    DATA lv_run   TYPE string.

* characters to escape are collected and converted together, so both halves
* of a surrogate pair reach the UTF-8 conversion as one character
    DO strlen( unescaped ) + 1 TIMES.
      lv_index = sy-index - 1.
      IF lv_index < strlen( unescaped ).
        lv_char = unescaped+lv_index(1).
        IF NOT ( to_upper( lv_char ) CA sy-abcde OR lv_char CA '0123456789.-_()' ).
          lv_run = lv_run && lv_char.
          CONTINUE.
        ENDIF.
      ELSE.
        CLEAR lv_char.
      ENDIF.

      IF lv_run IS NOT INITIAL.
* one escape per byte of the UTF-8 encoding
        lv_hex = to_lower( cl_abap_codepage=>convert_to( lv_run ) ).
        WHILE lv_hex IS NOT INITIAL.
          escaped = escaped && '%' && substring( val = lv_hex
                                                 len = 2 ).
          lv_hex = substring( val = lv_hex
                              off = 2 ).
        ENDWHILE.
        CLEAR lv_run.
      ENDIF.
      escaped = escaped && lv_char.
    ENDDO.
  ENDMETHOD.

  METHOD if_http_utility~encode_base64.
    encoded = do_encode_base64( unencoded ).
  ENDMETHOD.

  METHOD do_encode_base64.
* the text is taken as ISO-8859-1, a character outside it becomes "#"
    CONSTANTS lc_hash TYPE x LENGTH 1 VALUE '23'.
    CONSTANTS lc_zero TYPE x LENGTH 1 VALUE '00'.

    DATA lv_utf16  TYPE xstring.
    DATA lv_latin1 TYPE xstring.
    DATA lv_byte   TYPE x LENGTH 1.
    DATA lv_pos    TYPE i.
    DATA lv_high   TYPE i.

    lv_utf16 = cl_abap_codepage=>convert_to(
      source   = unencoded
      codepage = '4103' ).
    WHILE lv_pos < xstrlen( lv_utf16 ).
      lv_high = lv_pos + 1.
      IF lv_utf16+lv_high(1) = lc_zero.
        lv_byte = lv_utf16+lv_pos(1).
      ELSE.
        lv_byte = lc_hash.
      ENDIF.
      CONCATENATE lv_latin1 lv_byte INTO lv_latin1 IN BYTE MODE.
      lv_pos = lv_pos + 2.
    ENDWHILE.

    WRITE '@KERNEL encoded.set(Buffer.from(lv_latin1.get(), "hex").toString("base64"));'.
  ENDMETHOD.

  METHOD if_http_utility~decode_base64.
    decoded = do_decode_base64( encoded ).
  ENDMETHOD.

  METHOD do_decode_base64.
* every byte is one ISO-8859-1 character, built as UTF-16LE: the ISO-8859-1
* decoder of the runtime maps 80 to 9F as windows-1252
    CONSTANTS lc_zero TYPE x LENGTH 1 VALUE '00'.

    DATA lv_latin1 TYPE xstring.
    DATA lv_utf16  TYPE xstring.
    DATA lv_byte   TYPE x LENGTH 1.
    DATA lv_pos    TYPE i.

    WRITE '@KERNEL lv_latin1.set(Buffer.from(encoded.get(), "base64").toString("hex").toUpperCase());'.
    WHILE lv_pos < xstrlen( lv_latin1 ).
      lv_byte = lv_latin1+lv_pos(1).
      CONCATENATE lv_utf16 lv_byte lc_zero INTO lv_utf16 IN BYTE MODE.
      lv_pos = lv_pos + 1.
    ENDWHILE.

    decoded = cl_abap_codepage=>convert_from(
      source   = lv_utf16
      codepage = '4103' ).
  ENDMETHOD.

ENDCLASS.
