CLASS ltcl_conv_in DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.
    METHODS test2 FOR TESTING.

ENDCLASS.

CLASS ltcl_conv_in IMPLEMENTATION.

  METHOD test1.
    DATA conv TYPE REF TO cl_abap_conv_in_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_in_ce=>create( 'UTF-8' ).
    conv->convert(
      EXPORTING input = '616263'
      IMPORTING data = data ).
    cl_abap_unit_assert=>assert_equals(
      act = data
      exp = 'abc' ).
  ENDMETHOD.

  METHOD test2.

    DATA lv_xstring TYPE xstring.
    DATA lv_len TYPE i.
    DATA lo_obj TYPE REF TO cl_abap_conv_in_ce.
    DATA lv_string TYPE string.

    lv_xstring = '30303334'.

    lo_obj = cl_abap_conv_in_ce=>create(
        input    = lv_xstring
        encoding = 'UTF-8' ).
    lv_len = xstrlen( lv_xstring ).

    TRY.
        lo_obj->read( EXPORTING n    = lv_len
                      IMPORTING data = lv_string ).
      CATCH cx_sy_conversion_codepage.
        cl_abap_unit_assert=>fail( ).
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      act = lv_string
      exp = '0034' ).

  ENDMETHOD.

ENDCLASS.