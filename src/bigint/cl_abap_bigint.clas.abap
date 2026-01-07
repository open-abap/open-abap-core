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

    METHODS sub
      IMPORTING
        io_bigint        TYPE REF TO cl_abap_bigint
      RETURNING
        VALUE(ro_myself) TYPE REF TO cl_abap_bigint
      RAISING
        cx_sy_ref_is_initial.

    METHODS mul
      IMPORTING
        io_bigint        TYPE REF TO cl_abap_bigint
      RETURNING
        VALUE(ro_myself) TYPE REF TO cl_abap_bigint
      RAISING
        cx_sy_ref_is_initial.

    METHODS mod
      IMPORTING
        io_bigint        TYPE REF TO cl_abap_bigint
      RETURNING
        VALUE(ro_myself) TYPE REF TO cl_abap_bigint
      RAISING
        cx_sy_ref_is_initial
        cx_sy_zerodivide.

    METHODS clone
      RETURNING
        VALUE(ro_bigint) TYPE REF TO cl_abap_bigint.

    METHODS sqrt
      RETURNING
        VALUE(ro_myself) TYPE REF TO cl_abap_bigint
      RAISING
        cx_sy_arg_out_of_domain.

    METHODS is_equal
      IMPORTING
        io_bigint       TYPE REF TO cl_abap_bigint
      RETURNING
        VALUE(rv_equal) TYPE abap_bool
      RAISING
        cx_sy_ref_is_initial.

    METHODS is_larger
      IMPORTING
        io_bigint        TYPE REF TO cl_abap_bigint
      RETURNING
        VALUE(rv_larger) TYPE abap_bool
      RAISING
        cx_sy_ref_is_initial.

  PRIVATE SECTION.
    DATA mv_value TYPE string.

ENDCLASS.

CLASS cl_abap_bigint IMPLEMENTATION.

  METHOD factory_from_int4.
    CREATE OBJECT ro_bigint.
    WRITE '@KERNEL ro_bigint.get().#mv_value.set(BigInt(iv_value.get()).toString());'.
  ENDMETHOD.

  METHOD add_int4.
    ro_myself = me.
    WRITE '@KERNEL this.#mv_value.set((BigInt(this.#mv_value.get() || "0") + BigInt(iv_value.get())).toString());'.
  ENDMETHOD.

  METHOD to_string.
    rv_string = mv_value.
    IF rv_string IS INITIAL.
      rv_string = '0'.
    ENDIF.
  ENDMETHOD.

  METHOD sub.
    IF io_bigint IS INITIAL.
      RAISE EXCEPTION TYPE cx_sy_ref_is_initial.
    ENDIF.

    ro_myself = me.
    WRITE '@KERNEL this.#mv_value.set((BigInt(this.#mv_value.get() || "0") - BigInt(io_bigint.get().#mv_value.get() || "0")).toString());'.
  ENDMETHOD.

  METHOD mul.
    IF io_bigint IS INITIAL.
      RAISE EXCEPTION TYPE cx_sy_ref_is_initial.
    ENDIF.

    ro_myself = me.
    WRITE '@KERNEL this.#mv_value.set((BigInt(this.#mv_value.get() || "0") * BigInt(io_bigint.get().#mv_value.get() || "0")).toString());'.
  ENDMETHOD.

  METHOD mod.
    DATA lv_divisor TYPE string.

    IF io_bigint IS INITIAL.
      RAISE EXCEPTION TYPE cx_sy_ref_is_initial.
    ENDIF.

    lv_divisor = io_bigint->to_string( ).
    IF lv_divisor = '0'.
      RAISE EXCEPTION TYPE cx_sy_zerodivide.
    ENDIF.

    ro_myself = me.
    WRITE '@KERNEL this.#mv_value.set((BigInt(this.#mv_value.get() || "0") % BigInt(lv_divisor.get())).toString());'.
  ENDMETHOD.

  METHOD clone.
    CREATE OBJECT ro_bigint.
    WRITE '@KERNEL ro_bigint.get().#mv_value.set(this.#mv_value.get());'.
  ENDMETHOD.

  METHOD sqrt.
    DATA lv_value TYPE string.
    lv_value = to_string( ).
    IF lv_value CP '-*'.
      RAISE EXCEPTION TYPE cx_sy_arg_out_of_domain.
    ENDIF.

    ro_myself = me.
    WRITE '@KERNEL { const n = BigInt(this.#mv_value.get() || "0"); if (n < 2n) { this.#mv_value.set(n.toString()); } else { let x0 = n; let x1 = (x0 + 1n) >> 1n; while (x1 < x0) { x0 = x1; x1 = (x1 + n / x1) >> 1n; } this.#mv_value.set(x0.toString()); } }'.
  ENDMETHOD.

  METHOD is_equal.
    IF io_bigint IS INITIAL.
      RAISE EXCEPTION TYPE cx_sy_ref_is_initial.
    ENDIF.

    rv_equal = abap_false.
    WRITE '@KERNEL rv_equal.set(BigInt(this.#mv_value.get() || "0") === BigInt(io_bigint.get().#mv_value.get() || "0") ? "X" : "");'.
  ENDMETHOD.

  METHOD is_larger.
    IF io_bigint IS INITIAL.
      RAISE EXCEPTION TYPE cx_sy_ref_is_initial.
    ENDIF.

    rv_larger = abap_false.
    WRITE '@KERNEL rv_larger.set(BigInt(this.#mv_value.get() || "0") > BigInt(io_bigint.get().#mv_value.get() || "0") ? "X" : "");'.
  ENDMETHOD.

ENDCLASS.