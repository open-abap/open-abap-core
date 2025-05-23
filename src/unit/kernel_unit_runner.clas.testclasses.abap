CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS setup.
    DATA mv_setup TYPE i.

    METHODS single_method FOR TESTING RAISING cx_static_check.

    METHODS failing_not_for_testing RAISING cx_static_check.
    METHODS single_method_fail FOR TESTING RAISING cx_static_check.

    METHODS failing_not_for_testing_str RAISING cx_static_check.
    METHODS single_method_fail_str FOR TESTING RAISING cx_static_check.

    METHODS failing_not_for_testing_tab RAISING cx_static_check.
    METHODS single_method_fail_tab FOR TESTING RAISING cx_static_check.

    METHODS failing_not_for_testing_obj RAISING cx_static_check.
    METHODS single_method_fail_obj FOR TESTING RAISING cx_static_check.

    METHODS check_setup RAISING cx_static_check.
    METHODS single_method_check_setup FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD check_setup.
* this method is used internally for testing, dont set it FOR TESTING
    cl_abap_unit_assert=>assert_equals(
      act = mv_setup
      exp = 123 ).
  ENDMETHOD.

  METHOD setup.
    mv_setup = 123.
  ENDMETHOD.

  METHOD failing_not_for_testing.
* this method is used internally for testing, dont set it FOR TESTING
    cl_abap_unit_assert=>assert_equals(
      act = 'a'
      exp = 'b' ).
  ENDMETHOD.

  METHOD failing_not_for_testing_str.
* this method is used internally for testing, dont set it FOR TESTING
    cl_abap_unit_assert=>assert_equals(
      act = `sdfds`
      exp = `sdfdsfds` ).
  ENDMETHOD.

  METHOD failing_not_for_testing_tab.
* this method is used internally for testing, dont set it FOR TESTING
    DATA tab1 TYPE string_table.
    DATA tab2 TYPE string_table.
    DATA str TYPE string.
    str = |asdf|.
    INSERT str INTO TABLE tab1.
    cl_abap_unit_assert=>assert_equals(
      act = tab1
      exp = tab2 ).
  ENDMETHOD.

  METHOD failing_not_for_testing_obj.
* this method is used internally for testing, dont set it FOR TESTING
    TYPES: BEGIN OF ty,
             field TYPE i,
           END OF ty.
    DATA tab1 TYPE STANDARD TABLE OF ty WITH DEFAULT KEY.
    DATA tab2 TYPE STANDARD TABLE OF ty WITH DEFAULT KEY.
    DATA row LIKE LINE OF tab1.
    row-field = 1.
    INSERT row INTO TABLE tab1.
    row-field = 2.
    INSERT row INTO TABLE tab2.
    cl_abap_unit_assert=>assert_equals(
      act = tab1
      exp = tab2 ).
  ENDMETHOD.

  METHOD single_method_fail_str.
    DATA lt_input  TYPE kernel_unit_runner=>ty_input.
    DATA ls_input  LIKE LINE OF lt_input.
    DATA ls_result TYPE kernel_unit_runner=>ty_result.

    ls_input-class_name     = 'KERNEL_UNIT_RUNNER'.
    ls_input-testclass_name = 'LTCL_TEST'.
    ls_input-method_name    = 'FAILING_NOT_FOR_TESTING_STR'.
    APPEND ls_input TO lt_input.

    ls_result = kernel_unit_runner=>run( lt_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( ls_result-list )
      exp = 1 ).
  ENDMETHOD.

  METHOD single_method_fail_tab.
    DATA lt_input  TYPE kernel_unit_runner=>ty_input.
    DATA ls_input  LIKE LINE OF lt_input.
    DATA ls_result TYPE kernel_unit_runner=>ty_result.

    ls_input-class_name     = 'KERNEL_UNIT_RUNNER'.
    ls_input-testclass_name = 'LTCL_TEST'.
    ls_input-method_name    = 'FAILING_NOT_FOR_TESTING_TAB'.
    APPEND ls_input TO lt_input.

    ls_result = kernel_unit_runner=>run( lt_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( ls_result-list )
      exp = 1 ).
  ENDMETHOD.

  METHOD single_method_check_setup.
    DATA lt_input  TYPE kernel_unit_runner=>ty_input.
    DATA ls_input  LIKE LINE OF lt_input.
    DATA ls_result TYPE kernel_unit_runner=>ty_result.
    DATA ls_list   LIKE LINE OF ls_result-list.

    ls_input-class_name     = 'KERNEL_UNIT_RUNNER'.
    ls_input-testclass_name = 'LTCL_TEST'.
    ls_input-method_name    = 'CHECK_SETUP'.
    APPEND ls_input TO lt_input.

    ls_result = kernel_unit_runner=>run( lt_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( ls_result-list )
      exp = 1 ).
    READ TABLE ls_result-list INDEX 1 INTO ls_list.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_list-status
      exp = kernel_unit_runner=>gc_status-success ).
  ENDMETHOD.

  METHOD single_method_fail_obj.
    DATA lt_input  TYPE kernel_unit_runner=>ty_input.
    DATA ls_input  LIKE LINE OF lt_input.
    DATA ls_result TYPE kernel_unit_runner=>ty_result.
    DATA ls_list   LIKE LINE OF ls_result-list.

    ls_input-class_name     = 'KERNEL_UNIT_RUNNER'.
    ls_input-testclass_name = 'LTCL_TEST'.
    ls_input-method_name    = 'FAILING_NOT_FOR_TESTING_OBJ'.
    APPEND ls_input TO lt_input.

    ls_result = kernel_unit_runner=>run( lt_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( ls_result-list )
      exp = 1 ).
    READ TABLE ls_result-list INDEX 1 INTO ls_list.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_char_np(
      act = ls_list-message
      exp = '*object Object*' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_list-message
      exp = '*field*' ).
  ENDMETHOD.

  METHOD single_method_fail.
    DATA lt_input  TYPE kernel_unit_runner=>ty_input.
    DATA ls_input  LIKE LINE OF lt_input.
    DATA ls_result TYPE kernel_unit_runner=>ty_result.
    DATA ls_list   LIKE LINE OF ls_result-list.

    ls_input-class_name     = 'KERNEL_UNIT_RUNNER'.
    ls_input-testclass_name = 'LTCL_TEST'.
    ls_input-method_name    = 'FAILING_NOT_FOR_TESTING'.
    APPEND ls_input TO lt_input.

    ls_result = kernel_unit_runner=>run( lt_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( ls_result-list )
      exp = 1 ).
    READ TABLE ls_result-list INDEX 1 INTO ls_list.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_list-status
      exp = kernel_unit_runner=>gc_status-failed ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_list-js_location
      exp = '*failing_not_for_testing*' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_list-actual
      exp = 'a' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-json
      exp = |*"Expected 'b', got 'a'"*| ).
*    WRITE / ls_result-json.
  ENDMETHOD.

  METHOD single_method.
    DATA lt_input  TYPE kernel_unit_runner=>ty_input.
    DATA ls_input  LIKE LINE OF lt_input.
    DATA ls_result TYPE kernel_unit_runner=>ty_result.
    DATA ls_list   LIKE LINE OF ls_result-list.

    ls_input-class_name     = 'CL_ABAP_UNIT_ASSERT'.
    ls_input-testclass_name = 'LTCL_TEST'.
    ls_input-method_name    = 'INITIAL'.
    APPEND ls_input TO lt_input.

    ls_result = kernel_unit_runner=>run( lt_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( ls_result-list )
      exp = 1 ).

    READ TABLE ls_result-list INDEX 1 INTO ls_list.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_list-class_name
      exp = ls_input-class_name ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_list-testclass_name
      exp = ls_input-testclass_name ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_list-method_name
      exp = ls_input-method_name ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_list-status
      exp = kernel_unit_runner=>gc_status-success ).

    cl_abap_unit_assert=>assert_not_initial( ls_result-json ).
  ENDMETHOD.
ENDCLASS.