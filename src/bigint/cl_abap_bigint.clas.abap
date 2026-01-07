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

    METHODS to_string
      RETURNING
        VALUE(rv_string) TYPE string.

    DATA mv_value TYPE string.

  PRIVATE SECTION.

ENDCLASS.

CLASS cl_abap_bigint IMPLEMENTATION.

  METHOD factory_from_int4.
    CREATE OBJECT ro_bigint.
    WRITE '@KERNEL ro_bigint.get().mv_value.set(BigInt(iv_value.get()).toString());'.
  ENDMETHOD.

  METHOD add_int4.
    ro_myself = me.
    WRITE '@KERNEL this.mv_value.set((BigInt(this.mv_value.get() || "0") + BigInt(iv_value.get())).toString());'.
  ENDMETHOD.

  METHOD to_string.
    rv_string = mv_value.
    IF rv_string IS INITIAL.
      rv_string = '0'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.