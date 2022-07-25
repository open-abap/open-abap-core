CLASS cl_document_bcs DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_document_bcs.

    CLASS-METHODS create_document
      IMPORTING
        i_type    TYPE string
        i_subject TYPE string
        i_text    TYPE any OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO cl_document_bcs
      RAISING
        cx_bcs.

    METHODS add_attachment
      IMPORTING
        i_attachment_type    TYPE string
        i_attachment_subject TYPE string
        i_attachment_size    TYPE i OPTIONAL
        i_att_content_text   TYPE any OPTIONAL
        i_att_content_hex    TYPE any OPTIONAL
        i_attachment_header  TYPE soli_tab OPTIONAL
      RAISING
        cx_bcs.

ENDCLASS.

CLASS cl_document_bcs IMPLEMENTATION.

  METHOD create_document.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD add_attachment.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.