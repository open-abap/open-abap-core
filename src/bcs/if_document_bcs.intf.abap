INTERFACE if_document_bcs PUBLIC.

  METHODS get_body_part_attributes
    IMPORTING
      im_part              TYPE i
    RETURNING
      VALUE(re_attributes) TYPE bcss_dbpa
    RAISING
      cx_document_bcs.

  METHODS get_body_part_content
    IMPORTING
      im_part           TYPE i
    RETURNING
      VALUE(re_content) TYPE bcss_dbpc
    RAISING
      cx_document_bcs.

ENDINTERFACE.
