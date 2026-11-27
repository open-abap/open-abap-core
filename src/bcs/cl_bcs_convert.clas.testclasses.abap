CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS empty FOR TESTING.
    METHODS boundaries FOR TESTING.
    METHODS string_to_xstring FOR TESTING RAISING cx_bcs.
    METHODS string_to_xstring_bom FOR TESTING RAISING cx_bcs.
    METHODS xtab_to_xstring FOR TESTING.
    METHODS xtab_to_xstring_size FOR TESTING.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD empty.
    DATA lv_input TYPE xstring.
    cl_abap_unit_assert=>assert_equals(
      act = lines( cl_bcs_convert=>xstring_to_solix( lv_input ) )
      exp = 0 ).
  ENDMETHOD.

  METHOD boundaries.
    DATA lv_input TYPE xstring.
    DATA lv_byte TYPE x LENGTH 1.
    DATA lv_size TYPE i.
    DATA lt_sizes TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA lt_result TYPE solix_tab.
    DATA ls_row TYPE solix.
    DATA lv_actual TYPE xstring.
    DATA lv_expected TYPE xstring.
    DATA lv_zero TYPE x LENGTH 1.
    DATA lv_rows TYPE i.

    APPEND 1 TO lt_sizes.
    APPEND 254 TO lt_sizes.
    APPEND 255 TO lt_sizes.
    APPEND 256 TO lt_sizes.
    APPEND 510 TO lt_sizes.
    APPEND 511 TO lt_sizes.
    LOOP AT lt_sizes INTO lv_size.
      CLEAR lv_input.
      DO lv_size TIMES.
        lv_byte = sy-index MOD 256.
        CONCATENATE lv_input lv_byte INTO lv_input IN BYTE MODE.
      ENDDO.
      lt_result = cl_bcs_convert=>xstring_to_solix( lv_input ).
      lv_rows = ( lv_size + 254 ) DIV 255.
      cl_abap_unit_assert=>assert_equals( act = lines( lt_result )
                                          exp = lv_rows ).
      CLEAR lv_actual.
      LOOP AT lt_result INTO ls_row.
        CONCATENATE lv_actual ls_row-line INTO lv_actual IN BYTE MODE.
      ENDLOOP.
      lv_expected = lv_input.
      WHILE xstrlen( lv_expected ) < lv_rows * 255.
        CONCATENATE lv_expected lv_zero INTO lv_expected IN BYTE MODE.
      ENDWHILE.
      cl_abap_unit_assert=>assert_equals( act = lv_actual
                                          exp = lv_expected ).
    ENDLOOP.
  ENDMETHOD.

  METHOD string_to_xstring.
    DATA lv_utf8 TYPE xstring.
    DATA lv_string TYPE string.

    lv_utf8 = '41C3A4'.
    lv_string = cl_abap_conv_codepage=>create_in( )->convert( lv_utf8 ).

    cl_abap_unit_assert=>assert_equals(
      act = cl_bcs_convert=>string_to_xstring( lv_string )
      exp = lv_utf8 ).
  ENDMETHOD.

  METHOD string_to_xstring_bom.
    cl_abap_unit_assert=>assert_equals(
      act = cl_bcs_convert=>string_to_xstring( iv_string  = `A`
                                               iv_add_bom = abap_true )
      exp = 'EFBBBF41' ).
  ENDMETHOD.

  METHOD xtab_to_xstring.
    DATA lt_solix TYPE solix_tab.
    DATA ls_solix TYPE solix.
    DATA ls_first TYPE solix.
    DATA lv_expected TYPE xstring.

    ls_first-line = 'AABB'.
    APPEND ls_first TO lt_solix.
    ls_solix-line = 'CCDD'.
    APPEND ls_solix TO lt_solix.

    CONCATENATE ls_first-line ls_solix-line INTO lv_expected IN BYTE MODE.

    cl_abap_unit_assert=>assert_equals(
      act = cl_bcs_convert=>xtab_to_xstring( lt_solix )
      exp = lv_expected ).
  ENDMETHOD.

  METHOD xtab_to_xstring_size.
    DATA lt_solix TYPE solix_tab.
    DATA ls_solix TYPE solix.

    ls_solix-line = 'AABB'.
    APPEND ls_solix TO lt_solix.
    ls_solix-line = 'CCDD'.
    APPEND ls_solix TO lt_solix.

    cl_abap_unit_assert=>assert_equals(
      act = cl_bcs_convert=>xtab_to_xstring( it_xtab = lt_solix
                                             iv_size = 3 )
      exp = 'AABB00' ).
  ENDMETHOD.
ENDCLASS.
