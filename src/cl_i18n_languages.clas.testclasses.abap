CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PUBLIC SECTION.
    METHODS sap1_to_sap2_e FOR TESTING RAISING cx_root.
    METHODS sap1_to_sap2_d FOR TESTING RAISING cx_root.
    METHODS sap1_to_sap2_k FOR TESTING RAISING cx_root.

    METHODS sap2_to_iso_en FOR TESTING RAISING cx_root.
    METHODS sap2_to_iso_de FOR TESTING RAISING cx_root.
    METHODS sap2_to_iso_da FOR TESTING RAISING cx_root.
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

  METHOD sap2_to_iso_en.
    DATA lv_iso TYPE string.
    DATA lv_country TYPE string.

    cl_i18n_languages=>sap2_to_iso639_1(
      EXPORTING
        im_lang_sap2   = 'EN'
      IMPORTING
        ex_lang_iso639 = lv_iso
        ex_country     = lv_country ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_iso
      exp = 'en' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_country
      exp = 'US' ).
  ENDMETHOD.

  METHOD sap2_to_iso_de.
    DATA lv_iso TYPE string.
    DATA lv_country TYPE string.

    cl_i18n_languages=>sap2_to_iso639_1(
      EXPORTING
        im_lang_sap2   = 'DE'
      IMPORTING
        ex_lang_iso639 = lv_iso
        ex_country     = lv_country ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_iso
      exp = 'de' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_country
      exp = 'DE' ).
  ENDMETHOD.

  METHOD sap2_to_iso_da.
    DATA lv_iso TYPE string.
    DATA lv_country TYPE string.

    cl_i18n_languages=>sap2_to_iso639_1(
      EXPORTING
        im_lang_sap2   = 'DA'
      IMPORTING
        ex_lang_iso639 = lv_iso
        ex_country     = lv_country ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_iso
      exp = 'da' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_country
      exp = '' ).
  ENDMETHOD.
ENDCLASS.