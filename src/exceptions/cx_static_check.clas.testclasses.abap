CLASS lcx_error2 DEFINITION INHERITING FROM cx_static_check.
ENDCLASS.

CLASS lcx_error2 IMPLEMENTATION.
ENDCLASS.

******************************

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test2 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test2.

    DATA lx_error TYPE REF TO cx_root.
    DATA lv_act   TYPE string.

    TRY.
        RAISE EXCEPTION TYPE lcx_error2.
      CATCH cx_root INTO lx_error.
        lv_act = lx_error->get_text( ).
        ASSERT lv_act IS NOT INITIAL.
        cl_abap_unit_assert=>assert_equals(
          act = lv_act
          exp = 'An exception was raised.' ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.