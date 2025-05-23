CLASS cl_abap_tstmp DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS subtract
      IMPORTING
        tstmp1        TYPE p
        tstmp2        TYPE p
      RETURNING
        VALUE(r_secs) TYPE i.

    CLASS-METHODS add
      IMPORTING
        tstmp       TYPE p
        secs        TYPE numeric
      RETURNING
        VALUE(time) TYPE timestamp.

    CLASS-METHODS subtractsecs
      IMPORTING
        tstmp       TYPE p
        secs        TYPE numeric
      RETURNING
        VALUE(time) TYPE timestamp.

    CLASS-METHODS td_add
      IMPORTING
        date     TYPE d
        time     TYPE t
        secs     TYPE numeric
      EXPORTING
        res_date TYPE d
        res_time TYPE t.

    CLASS-METHODS move
      IMPORTING
        tstmp_src TYPE p
      EXPORTING
        tstmp_tgt TYPE p.

    CLASS-METHODS systemtstmp_syst2utc
      IMPORTING
        syst_date TYPE d
        syst_time TYPE t
      EXPORTING
        utc_tstmp TYPE p
      RAISING
        cx_parameter_invalid_range.

    CLASS-METHODS move_to_short
      IMPORTING
        tstmp_src        TYPE tzntstmpl
      RETURNING
        VALUE(tstmp_out) TYPE tzntstmps
      RAISING
        cx_parameter_invalid_type
        cx_parameter_invalid_range.

    CLASS-METHODS td_subtract
      IMPORTING
        date1    TYPE d
        time1    TYPE t
        date2    TYPE d
        time2    TYPE t
      EXPORTING
        res_secs TYPE numeric
      RAISING
        cx_parameter_invalid_type
        cx_parameter_invalid_range.

    CLASS-METHODS systemtstmp_utc2syst
      IMPORTING
        utc_tstmp TYPE timestamp
      EXPORTING
        syst_date TYPE d
        syst_time TYPE t
      RAISING
        cx_parameter_invalid_range.

    CLASS-METHODS utclong2tstmp_short
      IMPORTING
        utclong          TYPE utclong
      RETURNING
        VALUE(timestamp) TYPE timestamp
      RAISING
        cx_sy_conversion_no_date_time.
ENDCLASS.

CLASS cl_abap_tstmp IMPLEMENTATION.

  METHOD utclong2tstmp_short.
* wonder if this works?
    timestamp = utclong.
  ENDMETHOD.

  METHOD td_add.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD systemtstmp_utc2syst.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD move.
* todo, this is most likely wrong, but will also work in some cases
* todo, input is generic packed? which is unknown to abaplint
    tstmp_tgt = tstmp_src.
  ENDMETHOD.

  METHOD systemtstmp_syst2utc.
* system timezone is always UTC for open-abap, so no conversion needed
    IF syst_date IS INITIAL.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range.
    ENDIF.

    utc_tstmp = |{ syst_date }{ syst_time }|.
  ENDMETHOD.

  METHOD subtract.
    DATA str      TYPE string.
    DATA lv_dummy TYPE string.
    str = |{ tstmp1 TIMESTAMP = ISO }|.
    IF str CA ','.
      SPLIT str AT ',' INTO str lv_dummy.
    ENDIF.
    WRITE '@KERNEL let t1 = Date.parse(str.get());'.
    str = |{ tstmp2 TIMESTAMP = ISO }|.
    IF str CA ','.
      SPLIT str AT ',' INTO str lv_dummy.
    ENDIF.
    WRITE '@KERNEL let t2 = Date.parse(str.get());'.
    WRITE '@KERNEL r_secs.set((t1 - t2)/1000);'.
  ENDMETHOD.

  METHOD add.
    DATA str      TYPE string.
    DATA lv_dummy TYPE string.
    str = |{ tstmp TIMESTAMP = ISO }|.
    IF str CA ','.
      SPLIT str AT ',' INTO str lv_dummy.
    ENDIF.
    WRITE '@KERNEL let t1 = new Date(Date.parse(str.get() + "Z"));'.
    WRITE '@KERNEL t1.setSeconds( t1.getSeconds() + secs.get() );'.
    WRITE '@KERNEL time.set(t1.toISOString().slice(0, 19).replace(/-/g, "").replace(/:/g, "").replace("T", ""));'.
  ENDMETHOD.

  METHOD subtractsecs.
    DATA lv_secs TYPE i.
    lv_secs = secs * -1.
    time = add(
      tstmp = tstmp
      secs  = lv_secs ).
  ENDMETHOD.

  METHOD move_to_short.
    move(
      EXPORTING
        tstmp_src = tstmp_src
      IMPORTING
        tstmp_tgt = tstmp_out ).
  ENDMETHOD.

  METHOD td_subtract.
    DATA lv_stamp1 TYPE timestamp.
    DATA lv_stamp2 TYPE timestamp.

    CONVERT DATE date1 TIME time1 INTO TIME STAMP lv_stamp1.
    CONVERT DATE date2 TIME time2 INTO TIME STAMP lv_stamp2.

    res_secs = subtract(
      tstmp1 = lv_stamp1
      tstmp2 = lv_stamp2 ).
  ENDMETHOD.
ENDCLASS.