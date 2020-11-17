CLASS cl_abap_unit_assert DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      assert_equals
        IMPORTING
          act TYPE any
          exp TYPE any
          msg TYPE string OPTIONAL.

    CLASS-METHODS
      assert_differs
        IMPORTING
          act TYPE string
          exp TYPE string.

    CLASS-METHODS
      assert_not_initial
        IMPORTING
          act TYPE any.

    CLASS-METHODS
      assert_initial
        IMPORTING
          act TYPE any.

    CLASS-METHODS
      fail.

    CLASS-METHODS
      assert_subrc
        IMPORTING
          exp TYPE i DEFAULT 0.
ENDCLASS.

CLASS cl_abap_unit_assert IMPLEMENTATION.

  METHOD fail.
    ASSERT 1 = 2.
  ENDMETHOD.

  METHOD assert_differs.
    ASSERT act <> exp.
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
    ASSERT type1 = type2.

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