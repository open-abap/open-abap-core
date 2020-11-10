CLASS cl_abap_unit_assert DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      assert_equals
        IMPORTING
          act TYPE string
          exp TYPE string
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
      assert_subrc
        IMPORTING
          exp TYPE i DEFAULT 0.
ENDCLASS.

CLASS cl_abap_unit_assert IMPLEMENTATION.

  METHOD assert_differs.
    ASSERT act <> exp.
  ENDMETHOD.

  METHOD assert_equals.
    ASSERT act = exp.
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