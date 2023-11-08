CLASS cl_abap_unit_assert DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      assert_equals
        IMPORTING
          act   TYPE any
          exp   TYPE any
          msg   TYPE csequence OPTIONAL
          tol   TYPE f OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS abort
      IMPORTING
        msg    TYPE csequence OPTIONAL
        detail TYPE csequence OPTIONAL
        quit   TYPE int1 DEFAULT 2 PREFERRED PARAMETER msg.

    CLASS-METHODS
      assert_differs
        IMPORTING
          act   TYPE simple
          exp   TYPE simple
          msg   TYPE csequence OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_number_between
        IMPORTING
          lower  TYPE i
          upper  TYPE i
          number TYPE i
          msg    TYPE csequence OPTIONAL
          quit   TYPE i OPTIONAL
          level  TYPE i OPTIONAL.

    CLASS-METHODS
      assert_not_initial
        IMPORTING
          act   TYPE any
          msg   TYPE csequence OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_initial
        IMPORTING
          act   TYPE any
          msg   TYPE csequence OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      skip
        IMPORTING
          msg    TYPE csequence
          detail TYPE csequence OPTIONAL.

    CLASS-METHODS
      fail
        IMPORTING
          msg    TYPE csequence OPTIONAL
          quit   TYPE i OPTIONAL
          level  TYPE i OPTIONAL
          detail TYPE csequence OPTIONAL
        PREFERRED PARAMETER msg.

    CLASS-METHODS
      assert_subrc
        IMPORTING
          exp   TYPE i DEFAULT 0
          act   TYPE i DEFAULT sy-subrc
          msg   TYPE csequence OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL
        PREFERRED PARAMETER act.

    CLASS-METHODS
      assert_true
        IMPORTING
          act   TYPE abap_bool
          msg   TYPE csequence OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_false
        IMPORTING
          act TYPE abap_bool
          msg TYPE csequence OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_char_cp
        IMPORTING
          act   TYPE clike
          exp   TYPE clike
          msg   TYPE string OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_char_np
        IMPORTING
          act   TYPE clike
          exp   TYPE clike
          msg   TYPE csequence OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_bound
        IMPORTING
          act   TYPE any
          msg   TYPE csequence OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_not_bound
        IMPORTING
          act   TYPE any
          msg   TYPE csequence OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_text_matches
        IMPORTING
          pattern TYPE csequence
          text    TYPE csequence
          msg     TYPE csequence OPTIONAL
          quit    TYPE i OPTIONAL
          level   TYPE i OPTIONAL.

  PRIVATE SECTION.
    CLASS-METHODS
      compare_tables
        IMPORTING
          act TYPE any
          exp TYPE any.

ENDCLASS.

CLASS cl_abap_unit_assert IMPLEMENTATION.

  METHOD compare_tables.

    DATA index    TYPE i.
    DATA type1    TYPE REF TO cl_abap_tabledescr.
    DATA type2    TYPE REF TO cl_abap_tabledescr.
    DATA lv_match TYPE abap_bool.

    FIELD-SYMBOLS <tab1> TYPE INDEX TABLE.
    FIELD-SYMBOLS <row1> TYPE any.
    FIELD-SYMBOLS <tab2> TYPE INDEX TABLE.
    FIELD-SYMBOLS <row2> TYPE any.

    IF lines( act ) <> lines( exp ).
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = |Expected table to contain { lines( exp ) } rows, got { lines( act ) }|.
    ENDIF.

    ASSIGN act TO <tab1>.
    ASSIGN exp TO <tab2>.

    type1 ?= cl_abap_typedescr=>describe_by_data( act ).
    type2 ?= cl_abap_typedescr=>describe_by_data( exp ).
*    WRITE '@KERNEL console.dir(type1);'.
    IF type1->table_kind = cl_abap_tabledescr=>tablekind_hashed
        OR type2->table_kind = cl_abap_tabledescr=>tablekind_hashed.
      LOOP AT <tab1> ASSIGNING <row1>.
        lv_match = abap_false.
        LOOP AT <tab2> ASSIGNING <row2>.
          TRY.
              assert_equals(
                act = <row1>
                exp = <row2> ).
              lv_match = abap_true.
              EXIT. " current loop
            CATCH kernel_cx_assert.
          ENDTRY.
        ENDLOOP.
        IF lv_match = abap_false.
          RAISE EXCEPTION TYPE kernel_cx_assert
            EXPORTING
              msg = |Hashed table contents differs|.
        ENDIF.
      ENDLOOP.
    ELSE.
      DO lines( act ) TIMES.
        index = sy-index.
        READ TABLE <tab1> INDEX index ASSIGNING <row1>.
        assert_subrc( ).
        READ TABLE <tab2> INDEX index ASSIGNING <row2>.
        assert_subrc( ).
        assert_equals(
          act = <row1>
          exp = <row2> ).
      ENDDO.
    ENDIF.

  ENDMETHOD.

  METHOD assert_text_matches.
    DATA lv_match TYPE abap_bool.
    lv_match = boolc( contains(
      val   = text
      regex = pattern ) ).
    IF lv_match = abap_false.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          expected = pattern
          actual   = text
          msg      = msg.
    ENDIF.
  ENDMETHOD.

  METHOD abort.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD assert_bound.
    IF act IS NOT BOUND.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = |Expected value to be bound|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_not_bound.
    IF act IS BOUND.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = |Expected value to not be bound|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_char_cp.
    IF act NP exp.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          expected = exp
          actual   = act
          msg      = msg.
    ENDIF.
  ENDMETHOD.

  METHOD assert_char_np.
    IF act CP exp.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = |Actual: { act }|.
    ENDIF.
  ENDMETHOD.

  METHOD fail.
    RAISE EXCEPTION TYPE kernel_cx_assert
      EXPORTING
        msg = msg.
  ENDMETHOD.

  METHOD skip.
    RETURN.
  ENDMETHOD.

  METHOD assert_differs.
    TRY.
        assert_equals(
          act = act
          exp = exp ).
        RAISE EXCEPTION TYPE kernel_cx_assert
          EXPORTING
            msg      = |Expected different values|
            actual   = act
            expected = exp.
      CATCH kernel_cx_assert.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD assert_true.
    IF act <> abap_true.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = |Expected abap_true|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_false.
    IF act <> abap_false.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = |Expected abap_false|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_equals.
    DATA type1  TYPE c LENGTH 1.
    DATA type2  TYPE c LENGTH 1.
    DATA diff   TYPE f.
    DATA lv_exp TYPE string.
    DATA lv_act TYPE string.
    DATA lv_msg TYPE string.

    DESCRIBE FIELD act TYPE type1.
    DESCRIBE FIELD exp TYPE type2.
    " WRITE '@KERNEL console.dir(type1.get());'.
    " WRITE '@KERNEL console.dir(type2.get());'.
    IF type1 CA 'CgyIFPDTXN8'. " basic types
      IF type2 IS NOT INITIAL.
        IF type2 NA 'CgyIFPDTXN8'.
          RAISE EXCEPTION TYPE kernel_cx_assert
            EXPORTING
              msg = |Unexpected types|.
        ENDIF.
      ENDIF.
    ELSEIF type1 IS NOT INITIAL AND type2 IS NOT INITIAL.
* else check the types are identical
      IF type1 <> type2.
        RAISE EXCEPTION TYPE kernel_cx_assert
          EXPORTING
            msg = |Unexpected types|.
      ENDIF.
    ENDIF.

    IF type1 = 'h'.
      compare_tables(
        act = act
        exp = exp ).
    ELSEIF tol IS SUPPLIED.
      diff = exp - act.
*      WRITE '@KERNEL console.dir(tol);'.
*      WRITE '@KERNEL console.dir(diff);'.
      IF diff >= tol.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSEIF type1 = 'l'.
      assert_equals(
        act = act->*
        exp = exp->* ).
    ELSEIF act <> exp.
      lv_act = lcl_dump=>to_string( act ).
      lv_exp = lcl_dump=>to_string( exp ).
      IF msg <> ''.
        lv_msg = msg.
      ELSE.
        lv_msg = |Expected '{ lv_exp }', got '{ lv_act }'|.
      ENDIF.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg      = lv_msg
          actual   = lv_act
          expected = lv_exp.
    ENDIF.
  ENDMETHOD.

  METHOD assert_not_initial.
    DATA lv_msg TYPE string.
    IF act IS INITIAL.
      lv_msg = msg.
      IF lv_msg IS INITIAL.
        lv_msg = |Expected non initial value|.
      ENDIF.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = lv_msg.
    ENDIF.
  ENDMETHOD.

  METHOD assert_initial.
    DATA lv_msg TYPE string.
    IF act IS NOT INITIAL.
      lv_msg = msg.
      IF lv_msg IS INITIAL.
        lv_msg = |Expected initial value|.
      ENDIF.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = lv_msg.
    ENDIF.
  ENDMETHOD.

  METHOD assert_subrc.
    DATA lv_msg TYPE string.
    IF act <> exp.
      lv_msg = msg.
      IF lv_msg IS INITIAL.
        lv_msg = |Expected sy-subrc to equal { exp }, got { act }|.
      ENDIF.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          msg = lv_msg.
    ENDIF.
  ENDMETHOD.

  METHOD assert_number_between.
    IF number < lower OR number > upper.
      RAISE EXCEPTION TYPE kernel_cx_assert.
    ENDIF.
  ENDMETHOD.

ENDCLASS.