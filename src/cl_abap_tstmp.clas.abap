CLASS cl_abap_tstmp DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS subtract
      IMPORTING
        tstmp1 TYPE p
        tstmp2 TYPE p
      RETURNING
        VALUE(r_secs) TYPE i.
ENDCLASS.

CLASS cl_abap_tstmp IMPLEMENTATION.
  METHOD subtract.
    DATA str TYPE string.
    str = |{ tstmp1 TIMESTAMP = ISO }|.
    WRITE '@KERNEL let t1 = Date.parse(str.get());'.
    str = |{ tstmp2 TIMESTAMP = ISO }|.
    WRITE '@KERNEL let t2 = Date.parse(str.get());'.
    WRITE '@KERNEL r_secs.set((t1 - t2)/1000);'.
  ENDMETHOD.
ENDCLASS.