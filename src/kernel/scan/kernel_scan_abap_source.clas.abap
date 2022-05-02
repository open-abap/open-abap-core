CLASS kernel_scan_abap_source DEFINITION PUBLIC.
* handling of ABAP statement SCAN ABAP-SOURCE
  PUBLIC SECTION.
    CLASS-METHODS call IMPORTING input TYPE any.
ENDCLASS.

CLASS kernel_scan_abap_source IMPLEMENTATION.

  METHOD call.
    WRITE '@KERNEL console.dir(INPUT);'.
  ENDMETHOD.

ENDCLASS.