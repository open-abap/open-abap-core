CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS caught_as_dynamic_check FOR TESTING RAISING cx_root.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD caught_as_dynamic_check.

    DATA lv_caught TYPE abap_bool.

    TRY.
        RAISE EXCEPTION TYPE cx_sy_replace_infinite_loop.
      CATCH cx_dynamic_check.
        lv_caught = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      act = lv_caught
      exp = abap_true ).

  ENDMETHOD.

ENDCLASS.
