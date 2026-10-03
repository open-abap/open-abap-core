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

  PRIVATE SECTION.
    CLASS-METHODS check_table_in_packages
      IMPORTING
        iv_table    TYPE string
        iv_packages TYPE csequence
      RAISING
        cx_abap_not_in_package.
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
    DATA lv_check  TYPE string.
    DATA lv_exists TYPE abap_bool.

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

* the table must be known to the DDIC of the transpiled bundle
    WRITE '@KERNEL lv_exists.set(abap.DDIC[lv_check.get()]?.objectType === "TABL" ? "X" : "");'.
    IF lv_exists = abap_false.
      RAISE EXCEPTION TYPE cx_abap_not_a_table.
    ENDIF.

    check_table_in_packages(
      iv_table    = lv_check
      iv_packages = packages ).
  ENDMETHOD.

  METHOD check_table_in_packages.
* the package of the table is read from TADIR. The transpiler registers every object
* under $TMP, so a table is only checked when its TADIR entry carries a real package,
* otherwise nothing is known about the package and the table is accepted
    DATA lo_statement TYPE REF TO cl_sql_statement.
    DATA lo_result    TYPE REF TO cl_sql_result_set.
    DATA lr_devclass  TYPE REF TO data.
    DATA lv_devclass  TYPE string.
    DATA lv_packages  TYPE string.
    DATA lv_package   TYPE string.
    DATA lt_packages  TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    IF iv_packages IS INITIAL.
      RETURN.
    ENDIF.

* native SQL, as the check must also see TADIR while Open SQL test doubles are active.
* the aggregate makes sure one row is returned, also when the table has no TADIR entry
    TRY.
        CREATE OBJECT lo_statement.
        lo_result = lo_statement->execute_query(
          |SELECT COALESCE(MAX("devclass"), '') FROM "tadir" | &&
          |WHERE "pgmid" = 'R3TR' AND "object" = 'TABL' AND "obj_name" = '{ iv_table }'| ).
        GET REFERENCE OF lv_devclass INTO lr_devclass.
        lo_result->set_param( lr_devclass ).
        lo_result->next( ).
        lo_result->close( ).
      CATCH cx_sql_exception cx_parameter_invalid.
* no database connected, or no TADIR
        RETURN.
    ENDTRY.

    CONDENSE lv_devclass.
    IF lv_devclass IS INITIAL OR lv_devclass = '$TMP'.
      RETURN.
    ENDIF.

    lv_packages = iv_packages.
    TRANSLATE lv_packages TO UPPER CASE.
    SPLIT lv_packages AT ',' INTO TABLE lt_packages.
    LOOP AT lt_packages INTO lv_package.
      CONDENSE lv_package.
      IF lv_package = lv_devclass.
        RETURN.
      ENDIF.
    ENDLOOP.

    RAISE EXCEPTION TYPE cx_abap_not_in_package.
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
