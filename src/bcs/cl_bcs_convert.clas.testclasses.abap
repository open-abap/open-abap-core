CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS empty FOR TESTING.
    METHODS boundaries FOR TESTING.
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
ENDCLASS.
