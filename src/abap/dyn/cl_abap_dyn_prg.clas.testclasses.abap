CLASS ltcl_dyn_prg DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS escape_quotes1 FOR TESTING RAISING cx_static_check.
    METHODS escape_quotes_str1 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_dyn_prg IMPLEMENTATION.
  METHOD escape_quotes_str1.
    cl_abap_unit_assert=>assert_equals(
      act  = cl_abap_dyn_prg=>escape_quotes_str( 'hello ` world' )
      exp = 'hello `` world' ).
  ENDMETHOD.

  METHOD escape_quotes1.

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>escape_quotes( `hello ' world` )
      exp = `hello '' world` ).

  ENDMETHOD.

ENDCLASS.