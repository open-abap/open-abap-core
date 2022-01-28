CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING RAISING cx_static_check.
    METHODS get_ddic_field_list FOR TESTING RAISING cx_static_check.
    METHODS get_component_type FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_component_type.

    DATA struct TYPE REF TO cl_abap_structdescr.
    DATA type TYPE REF TO cl_abap_typedescr.
    struct ?= cl_abap_typedescr=>describe_by_name( 'T000' ).
    type = struct->get_component_type( 'CCCATEGORY' ).
    cl_abap_unit_assert=>assert_equals(
      act = type->kind
      exp = cl_abap_typedescr=>kind_elem ).

  ENDMETHOD.

  METHOD get_ddic_field_list.
  
    DATA struct TYPE REF TO cl_abap_structdescr.
    DATA lt_ddfields TYPE ddfields.
    DATA ls_ddfields LIKE LINE OF lt_ddfields.

    struct ?= cl_abap_typedescr=>describe_by_name( 'T000' ).
    lt_ddfields = struct->get_ddic_field_list( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_ddfields )
      exp = 3 ).

    READ TABLE lt_ddfields INTO ls_ddfields WITH KEY fieldname = 'MANDT'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfields-keyflag
      exp = abap_true ).
      
  ENDMETHOD.


  METHOD test01.

    TYPES: BEGIN OF ty_structure,
             field TYPE i,
           END OF ty_structure.

    DATA ls_data TYPE ty_structure.
    DATA lo_struc TYPE REF TO cl_abap_structdescr.
    DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    DATA ls_comp LIKE LINE OF lt_comps.

    lo_struc ?= cl_abap_structdescr=>describe_by_data( ls_data ).
    lt_comps = lo_struc->get_components( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_comps )
      exp = 1 ).

    READ TABLE lt_comps INDEX 1 INTO ls_comp.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_comp-name
      exp = 'FIELD' ).

    cl_abap_unit_assert=>assert_not_initial( ls_comp-type ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_comp-type->type_kind
      exp = cl_abap_typedescr=>typekind_int ).

  ENDMETHOD.

ENDCLASS.