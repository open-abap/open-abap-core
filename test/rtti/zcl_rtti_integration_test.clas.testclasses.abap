CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

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