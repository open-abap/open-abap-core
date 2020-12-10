CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: test01 FOR TESTING.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD test01.

    DATA lo_regex TYPE REF TO cl_abap_regex.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    DATA lt_results TYPE match_result_tab.
    DATA ls_result LIKE LINE OF lt_results.

    CREATE OBJECT lo_regex
      EXPORTING
        pattern     = 'aa'
        ignore_case = abap_true.

    lo_matcher = lo_regex->create_matcher( text = 'fooaabar' ).
    lt_results = lo_matcher->find_all( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_results )
      exp = 1 ).

    READ TABLE lt_results INDEX 1 INTO ls_result.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-offset
      exp = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-length
      exp = 2 ).

  ENDMETHOD.

ENDCLASS.