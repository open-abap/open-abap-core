CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PUBLIC SECTION.
    METHODS sap1_to_sap2_e FOR TESTING RAISING cx_root.
    METHODS sap1_to_sap2_d FOR TESTING RAISING cx_root.
    METHODS sap1_to_sap2_k FOR TESTING RAISING cx_root.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD sap1_to_sap2_e.
    cl_abap_unit_assert=>assert_equals(
      act = cl_i18n_languages=>sap1_to_sap2( 'E' )
      exp = 'EN' ).
  ENDMETHOD.

  METHOD sap1_to_sap2_d.
    cl_abap_unit_assert=>assert_equals(
      act = cl_i18n_languages=>sap1_to_sap2( 'D' )
      exp = 'DE' ).
  ENDMETHOD.

  METHOD sap1_to_sap2_k.
    cl_abap_unit_assert=>assert_equals(
      act = cl_i18n_languages=>sap1_to_sap2( 'K' )
      exp = 'DA' ).
  ENDMETHOD.

ENDCLASS.