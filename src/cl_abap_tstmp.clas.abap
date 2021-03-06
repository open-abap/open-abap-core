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
* todo, use string template to output timestamp to ISO?
*    WRITE '@KERNEL console.dir(INPUT.tstmp1.get());'.
*    WRITE '@KERNEL let t1 = Date.parse(INPUT.tstmp1.get());'.
*    WRITE '@KERNEL console.dir(t1);'.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.