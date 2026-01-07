CLASS cl_abap_bigint DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.

    CLASS-METHODS factory_from_int4
      IMPORTING
        iv_value         TYPE i DEFAULT 0
      RETURNING
        VALUE(ro_bigint) TYPE REF TO cl_abap_bigint.

    METHODS add_int4
      IMPORTING
        iv_value         TYPE i
      RETURNING
        VALUE(ro_myself) TYPE REF TO cl_abap_bigint.

ENDCLASS.

CLASS cl_abap_bigint IMPLEMENTATION.

ENDCLASS.