CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test1.

    CONSTANTS lc_epoch TYPE timestamp VALUE '19700101000000'.
    CONSTANTS lc_time TYPE timestamp VALUE '19710201000000'.
    DATA lv_seconds TYPE i.

    " todo
    " lv_seconds = cl_abap_tstmp=>subtract(
    "   tstmp1 = lc_time
    "   tstmp2 = lc_epoch ).

    " cl_abap_unit_assert=>assert_equals(
    "   act = lv_seconds
    "   exp = 34214400 ).
  ENDMETHOD.

ENDCLASS.