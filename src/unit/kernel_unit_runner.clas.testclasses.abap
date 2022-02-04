CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS single_method FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD single_method.

    DATA lt_input TYPE kernel_unit_runner=>ty_input.
    DATA ls_input LIKE LINE OF lt_input.
    DATA lt_result TYPE kernel_unit_runner=>ty_result.
    DATA ls_result LIKE LINE OF lt_result.
    FIELD-SYMBOLS <ls_input> LIKE LINE OF lt_input.

    ls_input-class_name     = 'CL_ABAP_UNIT_ASSERT'.
    ls_input-testclass_name = 'LTCL_TEST'.
    ls_input-method_name    = 'INITIAL'.
    APPEND ls_input TO lt_input.

    lt_result = kernel_unit_runner=>run( lt_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_result )
      exp = 1 ).

    READ TABLE lt_result INDEX 1 INTO ls_result.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-class_name
      exp = ls_input-class_name ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-testclass_name
      exp = ls_input-testclass_name ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-method_name
      exp = ls_input-method_name ).

  ENDMETHOD.
ENDCLASS.