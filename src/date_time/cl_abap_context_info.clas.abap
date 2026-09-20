CLASS cl_abap_context_info DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_system_date TYPE d.
    TYPES ty_system_time TYPE t.
    TYPES ty_user_alias TYPE c LENGTH 40.
    TYPES ty_user_name TYPE c LENGTH 12.
    TYPES ty_language_key TYPE c LENGTH 1.

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

ENDCLASS.
