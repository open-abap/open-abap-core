CLASS cl_bcs_mail_textpart DEFINITION PUBLIC INHERITING FROM cl_bcs_mail_bodypart FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create_instance
      IMPORTING
        iv_content         TYPE string OPTIONAL
        iv_content_type    TYPE ty_content_type OPTIONAL
        iv_filename        TYPE string OPTIONAL
      RETURNING
        VALUE(ro_instance) TYPE REF TO cl_bcs_mail_textpart.

    CLASS-METHODS create_text_plain
      IMPORTING
        iv_content         TYPE string
        iv_filename        TYPE string OPTIONAL
      RETURNING
        VALUE(ro_instance) TYPE REF TO cl_bcs_mail_textpart.

    CLASS-METHODS create_text_html
      IMPORTING
        iv_content         TYPE string
        iv_filename        TYPE string OPTIONAL
      RETURNING
        VALUE(ro_instance) TYPE REF TO cl_bcs_mail_textpart.

    METHODS set_content
      IMPORTING
        iv_content TYPE string.

    METHODS get_content
      RETURNING
        VALUE(rv_content) TYPE string.

    METHODS is_valid REDEFINITION.

  PRIVATE SECTION.
    DATA mv_content TYPE string.

ENDCLASS.

CLASS cl_bcs_mail_textpart IMPLEMENTATION.

  METHOD create_instance.
    CREATE OBJECT ro_instance.
    ro_instance->set_content( iv_content ).
    ro_instance->set_content_type( iv_content_type ).
    ro_instance->set_filename( iv_filename ).
  ENDMETHOD.

  METHOD create_text_plain.
    ro_instance = create_instance(
      iv_content      = iv_content
      iv_content_type = 'text/plain'
      iv_filename     = iv_filename ).
  ENDMETHOD.

  METHOD create_text_html.
    ro_instance = create_instance(
      iv_content      = iv_content
      iv_content_type = 'text/html'
      iv_filename     = iv_filename ).
  ENDMETHOD.

  METHOD set_content.
    mv_content = iv_content.
  ENDMETHOD.

  METHOD get_content.
    rv_content = mv_content.
  ENDMETHOD.

  METHOD is_valid.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
