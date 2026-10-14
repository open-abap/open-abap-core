CLASS cl_bcs_mail_bodypart DEFINITION PUBLIC ABSTRACT CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ENUM ty_bodyrole,
        main,
        alternative,
        attachment,
      END OF ENUM ty_bodyrole.
    TYPES ty_content_type TYPE c LENGTH 128.

    METHODS is_valid
      IMPORTING
        iv_role            TYPE ty_bodyrole
      RETURNING
        VALUE(rv_is_valid) TYPE abap_bool.

    METHODS get_filename
      RETURNING
        VALUE(rv_filename) TYPE string.

    METHODS set_filename
      IMPORTING
        iv_filename TYPE string.

    METHODS get_content_type
      RETURNING
        VALUE(rv_content_type) TYPE ty_content_type.

    METHODS set_content_type
      IMPORTING
        iv_content_type TYPE ty_content_type.

  PRIVATE SECTION.
    DATA mv_filename TYPE string.
    DATA mv_content_type TYPE ty_content_type.

ENDCLASS.

CLASS cl_bcs_mail_bodypart IMPLEMENTATION.

  METHOD is_valid.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_filename.
    rv_filename = mv_filename.
  ENDMETHOD.

  METHOD set_filename.
    mv_filename = iv_filename.
  ENDMETHOD.

  METHOD get_content_type.
    rv_content_type = mv_content_type.
  ENDMETHOD.

  METHOD set_content_type.
    mv_content_type = iv_content_type.
  ENDMETHOD.

ENDCLASS.
