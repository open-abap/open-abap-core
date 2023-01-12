CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_text FOR TESTING RAISING cx_root.

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

ENDCLASS.