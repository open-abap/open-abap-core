CLASS cl_bcs_mail_binarypart DEFINITION PUBLIC INHERITING FROM cl_bcs_mail_bodypart FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create_instance
      IMPORTING
        iv_content         TYPE xstring OPTIONAL
        iv_content_type    TYPE ty_content_type OPTIONAL
        iv_filename        TYPE string OPTIONAL
      RETURNING
        VALUE(ro_instance) TYPE REF TO cl_bcs_mail_binarypart.

    METHODS set_content
      IMPORTING
        iv_content TYPE xstring.

    METHODS get_content
      RETURNING
        VALUE(rv_content) TYPE xstring.

    METHODS is_valid REDEFINITION.

  PRIVATE SECTION.
    DATA mv_content TYPE xstring.

ENDCLASS.

CLASS cl_bcs_mail_binarypart IMPLEMENTATION.

  METHOD create_instance.
    CREATE OBJECT ro_instance.
    ro_instance->set_content( iv_content ).
    ro_instance->set_content_type( iv_content_type ).
    ro_instance->set_filename( iv_filename ).
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
