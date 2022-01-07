CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS subtract FOR TESTING RAISING cx_static_check.
    METHODS add FOR TESTING RAISING cx_static_check.
    METHODS subtractsecs FOR TESTING RAISING cx_static_check.
    METHODS move FOR TESTING RAISING cx_static_check.
    METHODS systemtstmp_syst2utc FOR TESTING RAISING cx_static_check.

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

  METHOD move.

    DATA lv_timestamp TYPE timestampl.
    DATA rv_result TYPE timestamp.
    DATA lv_str1 TYPE string.
    DATA lv_str2 TYPE string.

    GET TIME STAMP FIELD lv_timestamp.

    cl_abap_tstmp=>move(
      EXPORTING
        tstmp_src = lv_timestamp
      IMPORTING
        tstmp_tgt = rv_result ).

    lv_str1 = |{ lv_timestamp }|.
    lv_str2 = |{ rv_result }|.

    cl_abap_unit_assert=>assert_equals(
      act = lv_str1(13)
      exp = lv_str2(13) ).

  ENDMETHOD.

  METHOD systemtstmp_syst2utc.

    DATA lv_timestamp TYPE timestamp.

    cl_abap_tstmp=>systemtstmp_syst2utc(
      EXPORTING
        syst_date = '20220101'
        syst_time = '112233'
      IMPORTING
        utc_tstmp = lv_timestamp ).
    
    cl_abap_unit_assert=>assert_equals(
      act = lv_timestamp
      exp = 20220101112233 ).

  ENDMETHOD.

ENDCLASS.