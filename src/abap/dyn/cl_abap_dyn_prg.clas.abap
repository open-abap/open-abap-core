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
  METHOD check_whitelist_tab.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_quotes_str.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD check_table_or_view_name_str.
    val_str = val.
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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_xss_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD escape_quotes.
    out = val.
    REPLACE ALL OCCURRENCES OF `'` IN out WITH `''`.
  ENDMETHOD.

  METHOD escape_xss_xml_html.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.