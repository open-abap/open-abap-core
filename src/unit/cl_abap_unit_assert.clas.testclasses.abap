CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS initial FOR TESTING RAISING cx_static_check.
    METHODS initial_ref FOR TESTING RAISING cx_static_check.
    METHODS initial_numbers FOR TESTING RAISING cx_static_check.
    METHODS initial_date FOR TESTING RAISING cx_static_check.
    METHODS initial_hex FOR TESTING RAISING cx_static_check.
    METHODS equals FOR TESTING RAISING cx_static_check.
    METHODS equals_table FOR TESTING RAISING cx_static_check.
    METHODS equals_tol FOR TESTING RAISING cx_static_check.
    METHODS differs FOR TESTING RAISING cx_static_check.
    METHODS differs_nested FOR TESTING RAISING cx_static_check.
    METHODS cp1 FOR TESTING RAISING cx_static_check.
    METHODS cp2 FOR TESTING RAISING cx_static_check.
    METHODS char_eq_string FOR TESTING RAISING cx_static_check.
    METHODS decfloat34_eq FOR TESTING RAISING cx_static_check.
    METHODS decfloat34_ne FOR TESTING RAISING cx_static_check.
    METHODS numc_eq FOR TESTING RAISING cx_static_check.
    METHODS char_n_pack FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD char_n_pack.
    TYPES total TYPE p LENGTH 3 DECIMALS 2.
    DATA val TYPE total.
    val = '15.2'.
    cl_abap_unit_assert=>assert_equals(
      exp = '15.2'
      act = val ).
  ENDMETHOD.

  METHOD equals_tol.
    CONSTANTS pi TYPE f VALUE '3.14159265359'.
    DATA degrees TYPE f.
    DATA radians TYPE f.
    degrees = 180.
    radians = ( degrees * pi ) / 180.
    cl_abap_unit_assert=>assert_equals(
      exp = pi
      act = radians
      tol = `0.000000000000001` ).
  ENDMETHOD.

  METHOD cp1.
    cl_abap_unit_assert=>assert_char_cp(
      act = 'foobar'
      exp = '*oo*' ).
  ENDMETHOD.

  METHOD cp2.
    cl_abap_unit_assert=>assert_char_cp(
      act = |hello\nfoobar\nmoo|
      exp = '*oo*' ).
  ENDMETHOD.

  METHOD initial_numbers.
    DATA foo TYPE i.
    DATA bar TYPE f.
    cl_abap_unit_assert=>assert_equals(
      act = foo
      exp = bar ).
  ENDMETHOD.

  METHOD initial_hex.
    DATA var1 TYPE x LENGTH 2.
    DATA var2 TYPE c LENGTH 4.
    var1 = '0000'.
    var2 = '0000'.
    cl_abap_unit_assert=>assert_equals(
      act = var1
      exp = var2 ).
  ENDMETHOD.

  METHOD initial_date.
    DATA var1 TYPE d.
    var1 = ''.
    cl_abap_unit_assert=>assert_equals(
      act = var1
      exp = '' ).
  ENDMETHOD.

  METHOD initial.

    DATA foo TYPE string.
    cl_abap_unit_assert=>assert_initial( foo ).
    foo = 'abc'.
    cl_abap_unit_assert=>assert_not_initial( foo ).

  ENDMETHOD.

  METHOD initial_ref.

    DATA unit TYPE REF TO cl_abap_unit_assert.
    cl_abap_unit_assert=>assert_initial( unit ).
    CREATE OBJECT unit.
    cl_abap_unit_assert=>assert_not_initial( unit ).

  ENDMETHOD.

  METHOD equals.
    DATA bar TYPE i.
    cl_abap_unit_assert=>assert_equals( act = bar exp = bar ).
    bar = 2.
    cl_abap_unit_assert=>assert_equals( act = bar exp = bar ).

    cl_abap_unit_assert=>assert_equals( act = 2 exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = 'hello' exp = 'hello' ).
  ENDMETHOD.

  METHOD equals_table.
    DATA lt_tab1 TYPE string_table.
    DATA lt_tab2 TYPE string_table.
    APPEND 'foo' TO lt_tab1.
    APPEND 'foo' TO lt_tab2.
    cl_abap_unit_assert=>assert_equals( act = lt_tab1 exp = lt_tab2 ).
  ENDMETHOD.

  METHOD differs.
    cl_abap_unit_assert=>assert_differs(
      act = 1
      exp = 2 ).
  ENDMETHOD.

  METHOD differs_nested.
    TYPES: BEGIN OF ty_row1,
             field TYPE i,
           END OF ty_row1.
    TYPES: BEGIN OF ty_row2,
             field TYPE i,
             sub TYPE STANDARD TABLE OF ty_row1 WITH DEFAULT KEY,
           END OF ty_row2.
    DATA lt_act TYPE STANDARD TABLE OF ty_row2 WITH DEFAULT KEY.
    DATA lt_exp TYPE STANDARD TABLE OF ty_row2 WITH DEFAULT KEY.
    DATA ls_row2 TYPE ty_row2.

    ls_row2-field = 1.
    APPEND ls_row2 TO lt_act.
    ls_row2-field = 2.
    APPEND ls_row2 TO lt_exp.

    cl_abap_unit_assert=>assert_differs(
      act = lt_act
      exp = lt_exp ).
  ENDMETHOD.

  METHOD char_eq_string.
    DATA lv_char TYPE c LENGTH 10.
    DATA lv_string TYPE string.
    lv_char = 'hello'.
    lv_string = 'hello'.
    cl_abap_unit_assert=>assert_equals(
      act = lv_char
      exp = lv_string ).
  ENDMETHOD.

  METHOD decfloat34_eq.
    DATA d1 TYPE decfloat34.
    DATA d2 TYPE decfloat34.
    d1 = 1.
    d2 = 1.
    cl_abap_unit_assert=>assert_equals(
      act = d1
      exp = d2 ).
  ENDMETHOD.

  METHOD decfloat34_ne.
    DATA d1 TYPE decfloat34.
    DATA d2 TYPE decfloat34.
    d1 = 1.
    d2 = 2.
    cl_abap_unit_assert=>assert_differs(
      act = d1
      exp = d2 ).
  ENDMETHOD.

  METHOD numc_eq.
    DATA lv_num TYPE n LENGTH 10.
    lv_num = 1.
    cl_abap_unit_assert=>assert_equals(
      exp = '0000000001'
      act = lv_num ).
  ENDMETHOD.

ENDCLASS.