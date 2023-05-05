CLASS ltcl_test_datfm DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS convert_external_to_internal FOR TESTING RAISING cx_static_check.
    METHODS fails_not_gregorian_dot_sep FOR TESTING RAISING cx_static_check.

    DATA christmas_external TYPE string VALUE '24.12.2023'.
    DATA christmas TYPE d VALUE '99991231'.

ENDCLASS.

CLASS ltcl_test_datfm IMPLEMENTATION.

  METHOD convert_external_to_internal.
    DATA date_internal_actual TYPE d.
    DATA gregorian_dot_seperated TYPE c VALUE '1'.

    cl_abap_datfm=>conv_date_ext_to_int( EXPORTING im_datext = christmas_external im_datfmdes = gregorian_dot_seperated
                                         IMPORTING ex_datint = date_internal_actual ).

    cl_abap_unit_assert=>assert_equals( exp = christmas act = date_internal_actual ).

  ENDMETHOD.

  METHOD fails_not_gregorian_dot_sep.
    DATA date_internal TYPE d.
    DATA gregorian_slash_seperated TYPE c VALUE '2'.
    DATA exception TYPE REF TO cx_abap_datfm.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int( im_datext = christmas_external im_datfmdes = gregorian_slash_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.