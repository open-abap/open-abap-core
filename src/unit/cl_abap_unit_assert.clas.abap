CLASS cl_abap_unit_assert DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      assert_equals
        IMPORTING
          act   TYPE any
          exp   TYPE any
          msg   TYPE string OPTIONAL
          tol   TYPE f OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_differs
        IMPORTING
          act TYPE string
          exp TYPE string
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_number_between
        IMPORTING
          lower  TYPE i
          upper  TYPE i
          number TYPE i
          msg    TYPE string OPTIONAL
          quit   TYPE i OPTIONAL
          level   TYPE i OPTIONAL.

    CLASS-METHODS
      assert_not_initial
        IMPORTING
          act TYPE any
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_initial
        IMPORTING
          act TYPE any
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      fail
        IMPORTING
          msg TYPE csequence OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL
        PREFERRED PARAMETER msg.

    CLASS-METHODS
      assert_subrc
        IMPORTING
          exp TYPE i DEFAULT 0
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_true
        IMPORTING
          act TYPE abap_bool
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_false
        IMPORTING
          act TYPE abap_bool
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_char_cp
        IMPORTING
          act TYPE clike
          exp TYPE clike
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_bound
        IMPORTING
          act TYPE any
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_not_bound
        IMPORTING
          act TYPE any
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

* temporary feature flag,          
    CLASS-DATA mv_exceptions TYPE abap_bool VALUE abap_false.
ENDCLASS.

CLASS cl_abap_unit_assert IMPLEMENTATION.

  METHOD assert_bound.
    IF mv_exceptions = abap_true.
      IF act IS NOT BOUND.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT act IS BOUND.
    ENDIF.
  ENDMETHOD.

  METHOD assert_not_bound.
    IF mv_exceptions = abap_true.
      IF act IS BOUND.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT act IS NOT BOUND.
    ENDIF.
  ENDMETHOD.

  METHOD assert_char_cp.
    IF mv_exceptions = abap_true.
      IF act NP exp.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT act CP exp.
    ENDIF.
  ENDMETHOD.

  METHOD fail.
    IF mv_exceptions = abap_true.
      RAISE EXCEPTION TYPE kernel_cx_assert.
    ELSE.
      ASSERT 1 = 2.
    ENDIF.
  ENDMETHOD.

  METHOD assert_differs.
    IF mv_exceptions = abap_true.
      IF act = exp.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT act <> exp.
    ENDIF.
  ENDMETHOD.

  METHOD assert_true.
    IF mv_exceptions = abap_true.
      IF act <> abap_true.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT act = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD assert_false.
    IF mv_exceptions = abap_true.
      IF act <> abap_false.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT act = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD assert_equals.
    DATA type1 TYPE c LENGTH 1.
    DATA type2 TYPE c LENGTH 1.
    DATA index TYPE i.
    DATA diff TYPE f.
    FIELD-SYMBOLS <tab1> TYPE INDEX TABLE.
    FIELD-SYMBOLS <row1> TYPE any.
    FIELD-SYMBOLS <tab2> TYPE INDEX TABLE.
    FIELD-SYMBOLS <row2> TYPE any.

    DESCRIBE FIELD act TYPE type1.
    DESCRIBE FIELD exp TYPE type2.
*    WRITE '@KERNEL console.dir(type1.get());'.
*    WRITE '@KERNEL console.dir(type2.get());'.
    IF type1 CA 'CgyIFPDTX'. " basic types
      IF NOT type2 IS INITIAL.
        IF mv_exceptions = abap_true.
          IF type2 NA 'CgyIFPDTX'.
            RAISE EXCEPTION TYPE kernel_cx_assert.
          ENDIF.
        ELSE.
          ASSERT type2 CA 'CgyIFPDTX'.
        ENDIF.
      ENDIF.
    ELSEIF NOT type1 IS INITIAL AND NOT type2 IS INITIAL.
* else check the types are identical      
      IF mv_exceptions = abap_true.
        IF type1 <> type2.
          RAISE EXCEPTION TYPE kernel_cx_assert.
        ENDIF.
      ELSE.
        ASSERT type1 = type2.
      ENDIF.
    ENDIF.

    IF type1 = 'h'.
      ASSERT lines( act ) = lines( exp ).
      ASSIGN act TO <tab1>.
      ASSIGN exp TO <tab2>.
      DO lines( act ) TIMES.
        index = sy-index.
        READ TABLE <tab1> INDEX index ASSIGNING <row1>.
        assert_subrc( ).
        READ TABLE <tab2> INDEX index ASSIGNING <row2>.
        assert_subrc( ).
        assert_equals( act = <row1>
                       exp = <row2> ).
      ENDDO.
    ELSEIF tol IS SUPPLIED.
      diff = exp - act.
*      WRITE '@KERNEL console.dir(tol);'.
*      WRITE '@KERNEL console.dir(diff);'.
      IF mv_exceptions = abap_true.
        IF diff >= tol.
          RAISE EXCEPTION TYPE kernel_cx_assert.
        ENDIF.
      ELSE.
        ASSERT diff < tol.
      ENDIF.
    ELSEIF mv_exceptions = abap_true.
      IF act <> exp.
        RAISE EXCEPTION TYPE kernel_cx_assert
          EXPORTING
            actual   = act
            expected = exp.
      ENDIF.
    ELSE.
      ASSERT act = exp.
    ENDIF.
  ENDMETHOD.

  METHOD assert_not_initial.
    IF mv_exceptions = abap_true.
      IF act IS INITIAL.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT NOT act IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD assert_initial.
    IF mv_exceptions = abap_true.
      IF act IS NOT INITIAL.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT act IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD assert_subrc.
    IF mv_exceptions = abap_true.
      IF sy-subrc <> exp.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT sy-subrc = exp.
    ENDIF.
  ENDMETHOD.

  METHOD assert_number_between.
    IF mv_exceptions = abap_true.
      IF number < lower OR number > upper.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSE.
      ASSERT number >= lower.
      ASSERT number <= upper.
    ENDIF.
  ENDMETHOD.

ENDCLASS.