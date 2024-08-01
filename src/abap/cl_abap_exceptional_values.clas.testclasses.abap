CLASS ltcl_exceptional_values DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS max_integer FOR TESTING RAISING cx_static_check.
    METHODS min_integer FOR TESTING RAISING cx_static_check.

    METHODS max_packed1 FOR TESTING RAISING cx_static_check.
    METHODS max_packed2 FOR TESTING RAISING cx_static_check.
    METHODS max_packed3 FOR TESTING RAISING cx_static_check.
    METHODS max_packed4 FOR TESTING RAISING cx_static_check.
    METHODS min_packed FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_exceptional_values IMPLEMENTATION.

  METHOD max_packed1.
    DATA max TYPE p LENGTH 3 DECIMALS 1.
    DATA ref TYPE REF TO data.
    FIELD-SYMBOLS <field> TYPE any.
    ref = cl_abap_exceptional_values=>get_max_value( max ).
    ASSIGN ref->* TO <field>.

    cl_abap_unit_assert=>assert_equals(
      act = <field>
      exp = '9999.9' ).
  ENDMETHOD.

  METHOD max_packed2.
    DATA max TYPE p LENGTH 7 DECIMALS 3.
    DATA ref TYPE REF TO data.
    FIELD-SYMBOLS <field> TYPE any.
    ref = cl_abap_exceptional_values=>get_max_value( max ).
    ASSIGN ref->* TO <field>.

    cl_abap_unit_assert=>assert_equals(
      act = <field>
      exp = '9999999999.999' ).
  ENDMETHOD.

  METHOD max_packed3.
    DATA foo TYPE p LENGTH 4 DECIMALS 1.
    DATA ref TYPE REF TO data.
    FIELD-SYMBOLS <field> TYPE any.
    ref = cl_abap_exceptional_values=>get_max_value( foo ).
    ASSIGN ref->* TO <field>.

    cl_abap_unit_assert=>assert_equals(
      act = <field>
      exp = '999999.9' ).
  ENDMETHOD.

  METHOD max_packed4.
    DATA foo TYPE p LENGTH 9 DECIMALS 5.
    DATA ref TYPE REF TO data.
    FIELD-SYMBOLS <field> TYPE any.
    ref = cl_abap_exceptional_values=>get_max_value( foo ).
    ASSIGN ref->* TO <field>.

    cl_abap_unit_assert=>assert_equals(
      act = <field>
      exp = '999999999999.99999' ).
  ENDMETHOD.

  METHOD min_packed.
    DATA max TYPE p LENGTH 3 DECIMALS 1.
    DATA ref TYPE REF TO data.
    FIELD-SYMBOLS <field> TYPE any.
    ref = cl_abap_exceptional_values=>get_min_value( max ).
    ASSIGN ref->* TO <field>.

    cl_abap_unit_assert=>assert_equals(
      act = <field>
      exp = '-9999.9' ).
  ENDMETHOD.

  METHOD max_integer.
    DATA int TYPE i.
    DATA ref TYPE REF TO data.
    DATA val TYPE string.
    DATA max TYPE string.
    FIELD-SYMBOLS <max> TYPE any.
    ref = cl_abap_exceptional_values=>get_max_value( int ).
    ASSIGN ref->* TO <max>.
    max = <max>.
    ASSERT <max> = cl_abap_math=>max_int4.
  ENDMETHOD.

  METHOD min_integer.
    DATA int TYPE i.
    DATA ref TYPE REF TO data.
    DATA val TYPE string.
    DATA min TYPE string.
    FIELD-SYMBOLS <min> TYPE any.
    ref = cl_abap_exceptional_values=>get_min_value( int ).
    ASSIGN ref->* TO <min>.
    min = <min>.
    ASSERT <min> = cl_abap_math=>min_int4.
  ENDMETHOD.

ENDCLASS.