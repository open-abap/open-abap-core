CLASS cl_abap_message_digest DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS calculate_hash_for_raw
      IMPORTING
        if_algorithm   TYPE string DEFAULT 'SHA1'
        if_data        TYPE xstring
      EXPORTING
        ef_hashxstring TYPE xstring
      RAISING
        cx_abap_message_digest.
ENDCLASS.

CLASS cl_abap_message_digest IMPLEMENTATION.
  METHOD calculate_hash_for_raw.

  ENDMETHOD.
ENDCLASS.