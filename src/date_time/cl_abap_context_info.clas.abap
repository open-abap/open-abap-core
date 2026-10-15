CLASS cl_abap_context_info DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_system_date TYPE d.
    TYPES ty_system_time TYPE t.
    TYPES ty_user_alias TYPE c LENGTH 40.
    TYPES ty_user_name TYPE c LENGTH 12.
    TYPES ty_language_key TYPE c LENGTH 1.
    TYPES ty_language_iso_code TYPE laiso.

    CLASS-METHODS get_system_date
      RETURNING
        VALUE(rv_date) TYPE ty_system_date.

    CLASS-METHODS get_system_time
      RETURNING
        VALUE(rv_time) TYPE ty_system_time.

    CLASS-METHODS get_user_alias
      RETURNING
        VALUE(rv_alias) TYPE ty_user_alias.

    CLASS-METHODS get_user_time_zone
      IMPORTING
        iv_buser           TYPE clike OPTIONAL
      RETURNING
        VALUE(rv_timezone) TYPE timezone.

    CLASS-METHODS get_user_technical_name
      RETURNING
        VALUE(rv_technical_name) TYPE string.

    CLASS-METHODS get_user_language_abap_format
      IMPORTING
        iv_buser           TYPE ty_user_name OPTIONAL
      RETURNING
        VALUE(rv_language) TYPE ty_language_key
      RAISING
        cx_abap_context_info_error.

    CLASS-METHODS get_user_language_iso_format
      IMPORTING
        iv_buser           TYPE ty_user_name OPTIONAL
      RETURNING
        VALUE(rv_language) TYPE ty_language_iso_code
      RAISING
        cx_abap_context_info_error.

    CLASS-METHODS get_user_formatted_name
      IMPORTING
        iv_buser                 TYPE ty_user_name OPTIONAL
      RETURNING
        VALUE(rv_formatted_name) TYPE string
      RAISING
        cx_abap_context_info_error.

ENDCLASS.

CLASS cl_abap_context_info IMPLEMENTATION.
  METHOD get_user_technical_name.
    rv_technical_name = sy-uname.
  ENDMETHOD.

  METHOD get_user_time_zone.
    rv_timezone = 'UTC'.
  ENDMETHOD.

  METHOD get_system_date.
    rv_date = sy-datum.
  ENDMETHOD.

  METHOD get_system_time.
    rv_time = sy-uzeit.
  ENDMETHOD.

  METHOD get_user_alias.
    rv_alias = sy-uname.
  ENDMETHOD.

  METHOD get_user_language_abap_format.
    rv_language = sy-langu.
  ENDMETHOD.

  METHOD get_user_language_iso_format.
    cl_i18n_languages=>sap1_to_sap2(
      EXPORTING
        im_lang_sap1  = sy-langu
      RECEIVING
        re_lang_sap2  = rv_language
      EXCEPTIONS
        no_assignment = 1
        OTHERS        = 2 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_context_info_error.
    ENDIF.
  ENDMETHOD.

  METHOD get_user_formatted_name.
* there is no user master record, the user name is all there is
    rv_formatted_name = sy-uname.
  ENDMETHOD.

ENDCLASS.
