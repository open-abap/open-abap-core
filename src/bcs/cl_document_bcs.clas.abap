CLASS cl_document_bcs DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_document_bcs.

    CLASS-METHODS create_document
      IMPORTING
        i_type        TYPE clike
        i_subject     TYPE clike
        i_text        TYPE any OPTIONAL
        i_hex         TYPE any OPTIONAL
        i_length      TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO cl_document_bcs
      RAISING
        cx_bcs.

    METHODS add_attachment
      IMPORTING
        i_attachment_type    TYPE clike
        i_attachment_subject TYPE clike
        i_attachment_size    TYPE any OPTIONAL
        i_att_content_text   TYPE any OPTIONAL
        i_att_content_hex    TYPE any OPTIONAL
        i_attachment_header  TYPE soli_tab OPTIONAL
      RAISING
        cx_bcs.

    CLASS-METHODS xstring_to_solix
      IMPORTING
        ip_xstring      TYPE xstring
      RETURNING
        VALUE(rt_solix) TYPE solix_tab.

    METHODS set_importance
      IMPORTING
        i_importance TYPE any
      RAISING
        cx_os_object_not_found.

    METHODS set_sensitivity
      IMPORTING
        i_sensitivity TYPE any
      RAISING
        cx_os_object_not_found.

    METHODS add_document_as_attachment
      IMPORTING
        im_document TYPE REF TO if_document_bcs
      RAISING
        cx_document_bcs.

ENDCLASS.

CLASS cl_document_bcs IMPLEMENTATION.
  METHOD add_document_as_attachment.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_sensitivity.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_importance.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD xstring_to_solix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD create_document.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD add_attachment.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
