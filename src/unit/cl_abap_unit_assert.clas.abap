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
          level  TYPE i OPTIONAL.

    CLASS-METHODS
      assert_not_initial
        IMPORTING
          act   TYPE any
          msg   TYPE string OPTIONAL
          quit  TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_initial
        IMPORTING
          act   TYPE any
          msg   TYPE string OPTIONAL
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

ENDCLASS.

CLASS cl_abap_unit_assert IMPLEMENTATION.

  METHOD assert_bound.
    IF act IS NOT BOUND.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message = |Expected value to be bound|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_not_bound.
    IF act IS BOUND.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message = |Expected value to not be bound|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_char_cp.
    IF act NP exp.
      RAISE EXCEPTION TYPE kernel_cx_assert.
    ENDIF.
  ENDMETHOD.

  METHOD fail.
    RAISE EXCEPTION TYPE kernel_cx_assert.
  ENDMETHOD.

  METHOD skip.
    RETURN.
  ENDMETHOD.

  METHOD assert_differs.
    IF act = exp.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message = |Expected different values|
          act     = act
          exp     = exp.
    ENDIF.
  ENDMETHOD.

  METHOD assert_true.
    IF act <> abap_true.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message = |Expected abap_true|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_false.
    IF act <> abap_false.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message = |Expected abap_false|.
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
    IF type1 CA 'CgyIFPDTXN'. " basic types
      IF NOT type2 IS INITIAL.
        IF type2 NA 'CgyIFPDTXN'.
          RAISE EXCEPTION TYPE kernel_cx_assert
            EXPORTING
              message = |Unexpected types|.
        ENDIF.
      ENDIF.
    ELSEIF NOT type1 IS INITIAL AND NOT type2 IS INITIAL.
* else check the types are identical
      IF type1 <> type2.
        RAISE EXCEPTION TYPE kernel_cx_assert
          EXPORTING
            message = |Unexpected types|.
      ENDIF.
    ENDIF.

    IF type1 = 'h'.
      IF lines( act ) <> lines( exp ).
        RAISE EXCEPTION TYPE kernel_cx_assert
          EXPORTING
            message = |Expected table to contain '{ lines( exp ) }' rows , got '{ lines( act ) }'|.
      ENDIF.
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
      IF diff >= tol.
        RAISE EXCEPTION TYPE kernel_cx_assert.
      ENDIF.
    ELSEIF act <> exp.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message  = |Expected '{ exp }', got '{ act }'|
          actual   = act
          expected = exp.
    ENDIF.
  ENDMETHOD.

  METHOD assert_not_initial.
    IF act IS INITIAL.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message = |Expected non initial value|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_initial.
    IF act IS NOT INITIAL.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message = |Expected initial value|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_subrc.
    IF sy-subrc <> exp.
      RAISE EXCEPTION TYPE kernel_cx_assert
        EXPORTING
          message = |Expected sy-subrc to equal { exp }, got { sy-subrc }|.
    ENDIF.
  ENDMETHOD.

  METHOD assert_number_between.
    IF number < lower OR number > upper.
      RAISE EXCEPTION TYPE kernel_cx_assert.
    ENDIF.
  ENDMETHOD.

ENDCLASS.