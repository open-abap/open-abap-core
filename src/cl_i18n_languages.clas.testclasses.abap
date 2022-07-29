CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PUBLIC SECTION.
    METHODS sap1_to_sap2_e FOR TESTING RAISING cx_root.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD sap1_to_sap2_e.
    cl_abap_unit_assert=>assert_equals(
      act = cl_i18n_languages=>sap1_to_sap2( 'E' )
      exp = 'EN' ).
  ENDMETHOD.

ENDCLASS.