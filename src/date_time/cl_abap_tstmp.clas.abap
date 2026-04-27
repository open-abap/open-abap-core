CLASS cl_abap_tstmp DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES operation_mode TYPE c LENGTH 1.
    CONSTANTS:
      op_mode_next TYPE operation_mode VALUE 'N',
      op_mode_before TYPE operation_mode VALUE 'B',
      op_mode_wallclock TYPE operation_mode VALUE 'W'.

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

    CLASS-METHODS make_valid_time
      IMPORTING
        date_in    TYPE d
        time_in    TYPE t
        time_zone  TYPE timezone
        mode       TYPE operation_mode DEFAULT op_mode_wallclock
      EXPORTING
        date_valid TYPE d
        time_valid TYPE t
      RAISING
        cx_parameter_invalid_range
        cx_tstmp_internal_error.

    CLASS-METHODS tstmp2utclong
      IMPORTING
        timestamp      TYPE p
      RETURNING
        VALUE(utclong) TYPE utclong
      RAISING
        cx_parameter_invalid_type
        cx_sy_conversion_no_date_time.
ENDCLASS.

CLASS cl_abap_tstmp IMPLEMENTATION.

  METHOD utclong2tstmp_short.
* wonder if this works?
    timestamp = utclong.
  ENDMETHOD.

  METHOD td_add.

    DATA(td) = add(
      tstmp = |{ date }{ time }|
      secs = secs ).

    CONVERT TIME STAMP td INTO DATE res_date TIME res_time.

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
* todo: this can be done easier and faster, just subtract the two values?
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

  METHOD make_valid_time.
    DATA lv_out TYPE string.

*   --- SAP timezone to IANA mapping ---
    WRITE '@KERNEL const SAP_IANA={"UTC":"UTC","CET":"Europe/Berlin","WET":"Europe/London","EET":"Europe/Helsinki","MSK":"Europe/Moscow","EST":"America/New_York","CST":"America/Chicago","MST":"America/Denver","PST":"America/Los_Angeles","JST":"Asia/Tokyo","AEST":"Australia/Sydney","IST":"Asia/Kolkata","GST":"Asia/Dubai"};'.
    WRITE '@KERNEL const zone=SAP_IANA[time_zone.get().trim()]||time_zone.get().trim()||"UTC";'.
    WRITE '@KERNEL const d=date_in.get(),t=time_in.get(),input=d+t;'.

*   --- Cached Intl formatter (reused by every fmt() call) ---
    WRITE '@KERNEL const fmtr=new Intl.DateTimeFormat("sv",{timeZone:zone,year:"numeric",month:"2-digit",day:"2-digit",hour:"2-digit",minute:"2-digit",second:"2-digit",hour12:false});'.

*   --- Format a UTC-ms value as "YYYYMMDDHHMMSS" in the target zone ---
    WRITE '@KERNEL const fmt=ms=>fmtr.format(new Date(ms)).replace(/[^0-9]/g,"");'.

*   --- Parse "YYYYMMDDHHMMSS" digits into UTC milliseconds ---
    WRITE '@KERNEL const toMs=s=>Date.UTC(+s.slice(0,4),+s.slice(4,6)-1,+s.slice(6,8),+s.slice(8,10),+s.slice(10,12),+s.slice(12,14));'.

*   --- Timezone offset (ms) at a UTC instant, like getTimezoneOffset() but for any zone ---
    WRITE '@KERNEL const off=ms=>toMs(fmt(ms))-ms;'.

*   --- Convert local time string to UTC ms (two-step refinement for DST accuracy) ---
    WRITE '@KERNEL const toUTC=s=>{const ms=toMs(s);return ms-off(ms-off(ms));};'.

*   --- Round-trip check: does this local time actually exist in the zone? ---
    WRITE '@KERNEL const isValid=s=>fmt(toUTC(s))===s;'.

*   --- Add n seconds to a local-time digit string (pure arithmetic) ---
    WRITE '@KERNEL const addSecs=(s,n)=>{const dt=new Date(toMs(s)+n*1000);return String(dt.getUTCFullYear()).padStart(4,"0")+String(dt.getUTCMonth()+1).padStart(2,"0")+String(dt.getUTCDate()).padStart(2,"0")+String(dt.getUTCHours()).padStart(2,"0")+String(dt.getUTCMinutes()).padStart(2,"0")+String(dt.getUTCSeconds()).padStart(2,"0");};'.

    WRITE '@KERNEL let outDate=d,outTime=t;'.
    WRITE '@KERNEL if(!isValid(input)){'.
    WRITE '@KERNEL   const mv=mode.get().trim();'.
    WRITE '@KERNEL   if(mv==="W"){'.
*   --- Wallclock: use the offset from 24 h earlier (safely before the DST change) ---
    WRITE '@KERNEL     const ms=toMs(input),local=fmt(ms-off(ms-86400000));'.
    WRITE '@KERNEL     outDate=local.slice(0,8);outTime=local.slice(8,14);'.
    WRITE '@KERNEL   }else{'.
*   --- Before / Next: walk local time second-by-second until we hit a valid time ---
    WRITE '@KERNEL     const step=mv==="B"?-1:1;let loc=input;'.
    WRITE '@KERNEL     for(let i=0;i<7200;i++){loc=addSecs(loc,step);if(isValid(loc)){outDate=loc.slice(0,8);outTime=loc.slice(8,14);break;}}'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL }'.
    WRITE '@KERNEL lv_out.set(outDate+outTime);'.

    date_valid = lv_out(8).
    time_valid = lv_out+8(6).
  ENDMETHOD.

  METHOD tstmp2utclong.
    WRITE '@KERNEL const str = String(timestamp.get());'.
    WRITE '@KERNEL if (str.length < 14) throw new Error("CX_SY_CONVERSION_NO_DATE_TIME");'.
    WRITE '@KERNEL const iso = str.slice(0,4) + "-" + str.slice(4,6) + "-" + str.slice(6,8) + "T" +'.
    WRITE '@KERNEL              str.slice(8,10) + ":" + str.slice(10,12) + ":" + str.slice(12,14) + "Z";'.
    WRITE '@KERNEL const d = new Date(iso);'.
    WRITE '@KERNEL utclong.value = d.toISOString().replace(/\.\d{3}Z$/, ".0000000");'.
  ENDMETHOD.
ENDCLASS.