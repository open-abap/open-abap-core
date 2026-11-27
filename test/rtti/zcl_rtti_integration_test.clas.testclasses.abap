CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL CRITICAL DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS ddic_groupname_by_name FOR TESTING RAISING cx_static_check.
    METHODS ddic_groupname_by_data FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD ddic_groupname_by_name.
    DATA lo_struct TYPE REF TO cl_abap_structdescr.
    lo_struct ?= cl_abap_structdescr=>describe_by_name( 'ZTOP' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'FIELDNAME' )->kind
      exp = cl_abap_typedescr=>kind_elem ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'GNAME' )->kind
      exp = cl_abap_typedescr=>kind_struct ).
  ENDMETHOD.

  METHOD ddic_groupname_by_data.
    DATA lo_struct TYPE REF TO cl_abap_structdescr.
    DATA ls_top TYPE ztop.
    lo_struct ?= cl_abap_structdescr=>describe_by_data( ls_top ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'FIELDNAME' )->kind
      exp = cl_abap_typedescr=>kind_elem ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'GNAME' )->kind
      exp = cl_abap_typedescr=>kind_struct ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_ddic_field_list DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS leng_and_fieldtext FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_ddic_field_list IMPLEMENTATION.

  METHOD leng_and_fieldtext.
* LENG is the dictionary length in digits, not the output length
    DATA lo_struct   TYPE REF TO cl_abap_structdescr.
    DATA lt_ddfields TYPE ddfields.
    DATA ls_ddfield  LIKE LINE OF lt_ddfields.

    lo_struct ?= cl_abap_structdescr=>describe_by_name( 'ZDDIC_FIELD_LIST' ).
    lt_ddfields = lo_struct->get_ddic_field_list( ).

    READ TABLE lt_ddfields INTO ls_ddfield WITH KEY fieldname = 'AMOUNT'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfield-datatype
      exp = 'DEC' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfield-leng
      exp = 15 ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfield-decimals
      exp = 2 ).

    READ TABLE lt_ddfields INTO ls_ddfield WITH KEY fieldname = 'STAMP'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfield-rollname
      exp = 'TIMESTAMPL' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfield-leng
      exp = 21 ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfield-fieldtext
      exp = 'UTC Timestamp, long format' ).
  ENDMETHOD.

ENDCLASS.
