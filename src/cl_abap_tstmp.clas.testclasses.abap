CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS subtract FOR TESTING.
    METHODS add FOR TESTING.
    METHODS subtractsecs FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD subtract.

    CONSTANTS lc_epoch TYPE timestamp VALUE '19700101000000'.
    CONSTANTS lc_time TYPE timestamp VALUE '19710201000000'.
    DATA lv_seconds TYPE i.

    lv_seconds = cl_abap_tstmp=>subtract(
      tstmp1 = lc_time
      tstmp2 = lc_epoch ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_seconds
      exp = 34214400 ).
  ENDMETHOD.

  METHOD add.

    CONSTANTS lc_time TYPE timestamp VALUE '19710201000000'.
    DATA lv_time TYPE timestamp.

    lv_time = cl_abap_tstmp=>add(
      tstmp = lc_time
      secs  = 5000 ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_time
      exp = '19710201012320' ).

  ENDMETHOD.

  METHOD subtractsecs.

    CONSTANTS lc_time TYPE timestamp VALUE '19820201011000'.
    DATA lv_time TYPE timestamp.

    lv_time = cl_abap_tstmp=>subtractsecs(
      tstmp = lc_time
      secs  = 5000 ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_time
      exp = '19820131234640' ).

  ENDMETHOD.

ENDCLASS.