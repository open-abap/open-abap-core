CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test1.
    cl_abap_unit_assert=>assert_not_initial( cl_abap_random=>create( )->int( ) ).
  ENDMETHOD.

ENDCLASS.