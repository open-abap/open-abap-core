CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS single_method FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD single_method.

    DATA lt_input TYPE kernel_unit_runner=>ty_input.
    DATA ls_input LIKE LINE OF lt_input.
    DATA ls_result TYPE kernel_unit_runner=>ty_result.
    DATA ls_list LIKE LINE OF ls_result-list.
    FIELD-SYMBOLS <ls_input> LIKE LINE OF lt_input.

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

    cl_abap_unit_assert=>assert_not_initial( ls_result-json ).
  ENDMETHOD.
ENDCLASS.