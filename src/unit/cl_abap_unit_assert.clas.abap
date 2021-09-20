CLASS cl_abap_unit_assert DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      assert_equals
        IMPORTING
          act TYPE any
          exp TYPE any
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
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
          act TYPE string
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

    CLASS-METHODS
      assert_not_bound
        IMPORTING
          act TYPE string
          msg TYPE string OPTIONAL
          quit TYPE i OPTIONAL
          level TYPE i OPTIONAL.

ENDCLASS.

CLASS cl_abap_unit_assert IMPLEMENTATION.

  METHOD assert_bound.
    ASSERT act IS BOUND.
  ENDMETHOD.

  METHOD assert_not_bound.
    ASSERT act IS NOT BOUND.
  ENDMETHOD.

  METHOD assert_char_cp.
    ASSERT act CP exp.
  ENDMETHOD.

  METHOD fail.
    ASSERT 1 = 2.
  ENDMETHOD.

  METHOD assert_differs.
    ASSERT act <> exp.
  ENDMETHOD.

  METHOD assert_true.
    ASSERT act = abap_true.
  ENDMETHOD.

  METHOD assert_false.
    ASSERT act = abap_false.
  ENDMETHOD.

  METHOD assert_equals.
    DATA type1 TYPE c LENGTH 1.
    DATA type2 TYPE c LENGTH 1.
    DATA index TYPE i.
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
        ASSERT type2 CA 'CgyIFPDTX'.
      ENDIF.
    ELSEIF NOT type1 IS INITIAL AND NOT type2 IS INITIAL.
      ASSERT type1 = type2.
    ENDIF.

    IF type1 = 'h'.
      ASSERT lines( act ) = lines( exp ).
      ASSIGN act TO <tab1>.
      ASSIGN exp TO <tab2>.
      DO lines( act ) TIMES.
        index = sy-index.
        READ TABLE <tab1> INDEX index ASSIGNING <row1>.
        ASSERT sy-subrc = 0.
        READ TABLE <tab2> INDEX index ASSIGNING <row2>.
        ASSERT sy-subrc = 0.
        assert_equals( act = <row1>
                       exp = <row2> ).
      ENDDO.
    ELSE.
      ASSERT act = exp.
    ENDIF.
  ENDMETHOD.

  METHOD assert_not_initial.
    ASSERT NOT act IS INITIAL.
  ENDMETHOD.

  METHOD assert_initial.
    ASSERT act IS INITIAL.
  ENDMETHOD.

  METHOD assert_subrc.
    ASSERT sy-subrc = exp.
  ENDMETHOD.

ENDCLASS.