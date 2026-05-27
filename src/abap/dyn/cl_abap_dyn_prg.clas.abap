CLASS cl_abap_dyn_prg DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS check_table_name_str
      IMPORTING
        val               TYPE csequence
        packages          TYPE csequence
        incl_sub_packages TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(val_str)    TYPE string
      RAISING
        cx_abap_not_a_table
        cx_abap_not_in_package.

    CLASS-METHODS check_whitelist_str
      IMPORTING
        val            TYPE csequence
        whitelist      TYPE csequence
      RETURNING
        VALUE(val_str) TYPE string
      RAISING
        cx_abap_not_in_whitelist.

    CLASS-METHODS quote
      IMPORTING
        val        TYPE csequence
      RETURNING
        VALUE(out) TYPE string.

    CLASS-METHODS escape_quotes
      IMPORTING
        val        TYPE csequence
      RETURNING
        VALUE(out) TYPE string.

    CLASS-METHODS escape_xss_xml_html
      IMPORTING
        val        TYPE csequence
      RETURNING
        VALUE(out) TYPE string.

    CLASS-METHODS escape_xss_url
      IMPORTING
        val        TYPE csequence
      RETURNING
        VALUE(out) TYPE string.

    CLASS-METHODS check_column_name
      IMPORTING
        val            TYPE csequence
        strict         TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(val_str) TYPE string
      RAISING
        cx_abap_invalid_name.

    CLASS-METHODS check_variable_name
      IMPORTING
        val            TYPE csequence
        strict         TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(val_str) TYPE string
      RAISING
        cx_abap_invalid_name.

    CLASS-METHODS check_table_or_view_name_str
      IMPORTING
        val               TYPE csequence
        packages          TYPE csequence
        incl_sub_packages TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(val_str)    TYPE string
      RAISING
        cx_abap_not_a_table
        cx_abap_not_in_package.

    CLASS-METHODS escape_quotes_str
      IMPORTING
        val        TYPE csequence
      RETURNING
        VALUE(out) TYPE string.

    CLASS-METHODS check_whitelist_tab
      IMPORTING
        val            TYPE csequence
        whitelist      TYPE string_hashed_table
      RETURNING
        VALUE(val_str) TYPE string
      RAISING
        cx_abap_not_in_whitelist.
ENDCLASS.

CLASS cl_abap_dyn_prg IMPLEMENTATION.
  METHOD check_variable_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD check_column_name.
    DATA lv_check TYPE string.

    val_str = val.
    lv_check = val_str.
    TRANSLATE lv_check TO UPPER CASE.

    IF val_str IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_name.
    ENDIF.

    IF strict = abap_true.
      FIND REGEX '^([A-Z_][A-Z0-9_]*|/[A-Z0-9_]+/[A-Z0-9_]+)$' IN lv_check.
    ELSE.
      FIND REGEX '^([A-Z_][A-Z0-9_]*|/[A-Z0-9_]+/[A-Z0-9_]+)(~([A-Z_][A-Z0-9_]*|/[A-Z0-9_]+/[A-Z0-9_]+))?$' IN lv_check.
    ENDIF.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_name.
    ENDIF.
  ENDMETHOD.

  METHOD check_whitelist_tab.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_quotes_str.
    out = val.
    REPLACE ALL OCCURRENCES OF '`' IN out WITH '``'.
  ENDMETHOD.

  METHOD check_table_or_view_name_str.
    DATA lv_check TYPE string.

    val_str = val.
    lv_check = val_str.
    TRANSLATE lv_check TO UPPER CASE.

    IF val_str IS INITIAL OR strlen( val_str ) > 30.
      RAISE EXCEPTION TYPE cx_abap_not_a_table.
    ENDIF.

    FIND REGEX '^([A-Z_][A-Z0-9_]*|/[A-Z0-9_]+/[A-Z0-9_]+)$' IN lv_check.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_not_a_table.
    ENDIF.
  ENDMETHOD.

  METHOD check_table_name_str.
* allow everything
    val_str = val.
  ENDMETHOD.

  METHOD check_whitelist_str.
* allow everything
    val_str = val.
  ENDMETHOD.

  METHOD quote.
    out = `'` && escape_quotes( val ) && `'`.
  ENDMETHOD.

  METHOD escape_xss_url.
* encodeURIComponent covers most cases; keep '*' unescaped per expected output
    WRITE '@KERNEL out.set(encodeURIComponent(val.get().trimEnd()).replace(/[!''()]/g, c => "%" + c.charCodeAt(0).toString(16)).toLowerCase());'.
  ENDMETHOD.

  METHOD escape_quotes.
    out = val.
    REPLACE ALL OCCURRENCES OF `'` IN out WITH `''`.
  ENDMETHOD.

  METHOD escape_xss_xml_html.
    DATA lv_index TYPE i.
    DATA lv_code  TYPE i.
    DATA lv_hex   TYPE string.

    out = ''.
    DO strlen( val ) TIMES.
      lv_index = sy-index - 1.
      WRITE '@KERNEL lv_code.set(val.get().charCodeAt(lv_index.get()));'.
      IF lv_code = 60. " <
        out = out && '&lt;'.
      ELSEIF lv_code = 62. " >
        out = out && '&gt;'.
      ELSEIF lv_code = 38. " &
        out = out && '&amp;'.
      ELSEIF ( lv_code >= 65 AND lv_code <= 90 ) OR ( lv_code >= 97 AND lv_code <= 122 ) OR ( lv_code >= 48 AND lv_code <= 57 ).
        WRITE '@KERNEL out.set(out.get() + String.fromCharCode(lv_code.get()));'.
      ELSE.
        WRITE '@KERNEL lv_hex.set(lv_code.get().toString(16));'.
        out = out && '&#x' && lv_hex && ';'.
      ENDIF.
    ENDDO.
  ENDMETHOD.

ENDCLASS.
