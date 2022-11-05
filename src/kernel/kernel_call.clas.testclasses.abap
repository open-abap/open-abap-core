CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS guid FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD guid.
    DATA hex16 TYPE x LENGTH 16.
    CALL 'RFCControl'
      ID 'CODE' FIELD 'U'
      ID 'UUID' FIELD hex16.
    cl_abap_unit_assert=>assert_not_initial( hex16 ).
  ENDMETHOD.

ENDCLASS.