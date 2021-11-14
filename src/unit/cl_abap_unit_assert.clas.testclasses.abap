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
    METHODS cp1 FOR TESTING RAISING cx_static_check.
    METHODS cp2 FOR TESTING RAISING cx_static_check.
    METHODS char_eq_string FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

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
    cl_abap_unit_assert=>assert_differs( act = 1 exp = 2 ).
  ENDMETHOD.

  METHOD char_eq_string.
    DATA lv_char TYPE c LENGTH 10.
    DATA lv_string TYPE string.
    lv_char = 'hello'.
    lv_string = 'hello'.
    cl_abap_unit_assert=>assert_equals( act = lv_char exp = lv_string ).
  ENDMETHOD.

ENDCLASS.