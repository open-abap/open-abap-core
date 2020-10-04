CLASS cl_abap_unit_assert DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS
      assert_equals
        IMPORTING
          act TYPE string
          exp TYPE string
          msg TYPE string OPTIONAL.

    CLASS-METHODS
      assert_not_initial
        IMPORTING
          act TYPE string.
ENDCLASS.

CLASS cl_abap_unit_assert IMPLEMENTATION.
  METHOD assert_equals.
    ASSERT act = exp.
  ENDMETHOD.
  METHOD assert_not_initial.
    ASSERT NOT act IS INITIAL.
  ENDMETHOD.
ENDCLASS.