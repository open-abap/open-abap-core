CLASS ltcl_conv_in DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS convert FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_conv_in IMPLEMENTATION.

  METHOD convert.

    DATA lv_xstr  TYPE xstring.
    DATA instance TYPE REF TO if_abap_conv_in.
    DATA char     TYPE c LENGTH 2.

    lv_xstr = '0041'.

    instance = cl_abap_conv_codepage=>create_in( codepage = 'UTF-16' ).

    CONCATENATE lv_xstr+1(1) lv_xstr(1) INTO lv_xstr IN BYTE MODE.

    char = instance->convert( source = lv_xstr ).

    cl_abap_unit_assert=>assert_equals(
      act = char
      exp = 'A ' ).

  ENDMETHOD.

ENDCLASS.