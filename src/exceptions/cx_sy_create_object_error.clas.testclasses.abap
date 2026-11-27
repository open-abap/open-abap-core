CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_text FOR TESTING RAISING cx_root.
    METHODS get_text_names_the_class FOR TESTING RAISING cx_root.
    METHODS get_text_without_a_name FOR TESTING RAISING cx_root.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_text.

    DATA lo_foo   TYPE REF TO object.
    DATA lx_error TYPE REF TO cx_sy_create_object_error.

    TRY.
        CREATE OBJECT lo_foo TYPE ('ASDF').
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_create_object_error INTO lx_error.
        cl_abap_unit_assert=>assert_char_cp(
          act = lx_error->get_text( )
          exp = 'The object could not be created*' ).
    ENDTRY.

  ENDMETHOD.

  METHOD get_text_names_the_class.

    DATA lo_foo   TYPE REF TO object.
    DATA lv_name  TYPE string.
    DATA lx_error TYPE REF TO cx_sy_create_object_error.

    lv_name = 'ZCL_DOES_NOT_EXIST'.
    TRY.
        CREATE OBJECT lo_foo TYPE (lv_name).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_create_object_error INTO lx_error.
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->get_text( )
          exp = 'The object could not be created: The class ZCL_DOES_NOT_EXIST does not exist.' ).
    ENDTRY.

  ENDMETHOD.

  METHOD get_text_without_a_name.

    DATA lx_error TYPE REF TO cx_sy_create_object_error.

    CREATE OBJECT lx_error.
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->get_text( )
      exp = 'The object could not be created: The class ??? does not exist.' ).

  ENDMETHOD.

ENDCLASS.
