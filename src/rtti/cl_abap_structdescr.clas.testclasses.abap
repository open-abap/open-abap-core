CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING RAISING cx_static_check.
    METHODS get_ddic_field_list FOR TESTING RAISING cx_static_check.
    METHODS is_ddic_type FOR TESTING RAISING cx_static_check.
    METHODS get_component_type FOR TESTING RAISING cx_static_check.
    METHODS get_component_type_not_found FOR TESTING RAISING cx_static_check.
    METHODS component_type_kind FOR TESTING RAISING cx_static_check.
    METHODS create_empty FOR TESTING RAISING cx_static_check.
    METHODS create_basic FOR TESTING RAISING cx_static_check.
    METHODS nested_boolean1 FOR TESTING RAISING cx_static_check.
    METHODS nested_boolean2 FOR TESTING RAISING cx_static_check.
    METHODS long_name FOR TESTING RAISING cx_static_check.
    METHODS namespaced_name FOR TESTING RAISING cx_static_check.
    METHODS get_included_view1 FOR TESTING RAISING cx_static_check.
    METHODS get_included_view2 FOR TESTING RAISING cx_static_check.
    METHODS get_included_view3 FOR TESTING RAISING cx_static_check.
    METHODS length FOR TESTING RAISING cx_static_check.
    METHODS get_components_include FOR TESTING RAISING cx_static_check.
    METHODS get_symbols FOR TESTING RAISING cx_static_check.
    METHODS two_grouped FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD create_empty.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    TRY.
        cl_abap_structdescr=>create( lt_components ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_struct_attributes.
    ENDTRY.
  ENDMETHOD.

  METHOD create_basic.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    DATA lr_ref        TYPE REF TO data.
    FIELD-SYMBOLS <fs>    TYPE any.
    FIELD-SYMBOLS <field> TYPE any.

    ls_component-name = 'FIELD'.
    ls_component-type = cl_abap_elemdescr=>get_i( ).
    APPEND ls_component TO lt_components.

    lo_struct = cl_abap_structdescr=>create( lt_components ).
    cl_abap_unit_assert=>assert_not_initial( lo_struct ).
    cl_abap_unit_assert=>assert_not_initial( lo_struct->kind ).
    cl_abap_unit_assert=>assert_not_initial( lo_struct->type_kind ).

    CREATE DATA lr_ref TYPE HANDLE lo_struct.
    ASSIGN lr_ref->* TO <fs>.
    ASSIGN COMPONENT 'FIELD' OF STRUCTURE <fs> TO <field>.
    cl_abap_unit_assert=>assert_subrc( ).
    <field> = 2.
  ENDMETHOD.

  METHOD component_type_kind.
    DATA struct TYPE REF TO cl_abap_structdescr.
    DATA components TYPE cl_abap_structdescr=>component_table.
    DATA component LIKE LINE OF components.
    DATA type TYPE REF TO cl_abap_typedescr.
    struct ?= cl_abap_typedescr=>describe_by_name( 'T000' ).
    components = struct->get_components( ).
    READ TABLE components INDEX 1 INTO component.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_not_initial( component-name ).
  ENDMETHOD.

  METHOD is_ddic_type.

    DATA struct TYPE REF TO cl_abap_structdescr.
    DATA type TYPE REF TO cl_abap_typedescr.
    struct ?= cl_abap_typedescr=>describe_by_name( 'T000' ).
    cl_abap_unit_assert=>assert_equals(
      act = struct->is_ddic_type( )
      exp = abap_true ).

  ENDMETHOD.

  METHOD get_component_type.

    DATA struct TYPE REF TO cl_abap_structdescr.
    DATA type TYPE REF TO cl_abap_typedescr.
    struct ?= cl_abap_typedescr=>describe_by_name( 'T000' ).
    type = struct->get_component_type( 'CCCATEGORY' ).
    cl_abap_unit_assert=>assert_equals(
      act = type->kind
      exp = cl_abap_typedescr=>kind_elem ).

  ENDMETHOD.

  METHOD get_component_type_not_found.
    DATA struct TYPE REF TO cl_abap_structdescr.
    DATA type TYPE REF TO cl_abap_typedescr.
    struct ?= cl_abap_typedescr=>describe_by_name( 'T000' ).
    struct->get_component_type(
      EXPORTING
        p_name      = 'NONONONONO'
      RECEIVING
        p_descr_ref = type
      EXCEPTIONS
        component_not_found = 4 ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-subrc
      exp = 4 ).
  ENDMETHOD.

  METHOD get_ddic_field_list.

    DATA struct      TYPE REF TO cl_abap_structdescr.
    DATA lt_ddfields TYPE ddfields.
    DATA ls_ddfields LIKE LINE OF lt_ddfields.

    struct ?= cl_abap_typedescr=>describe_by_name( 'T000' ).
    lt_ddfields = struct->get_ddic_field_list( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_ddfields )
      exp = 4 ).

    READ TABLE lt_ddfields INTO ls_ddfields WITH KEY fieldname = 'MANDT'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfields-keyflag
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_ddfields-leng
      exp = 3 ).

  ENDMETHOD.

  METHOD test01.
    TYPES: BEGIN OF ty_structure,
             field TYPE i,
           END OF ty_structure.

    DATA ls_data  TYPE ty_structure.
    DATA lo_struc TYPE REF TO cl_abap_structdescr.
    DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    DATA ls_comp  LIKE LINE OF lt_comps.

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

  METHOD nested_boolean1.
    TYPES:
      BEGIN OF ty_personalization,
        hide_column TYPE abap_bool,
      END OF ty_personalization,
      BEGIN OF ty_list_report,
        hide_column TYPE ty_personalization-hide_column,
      END OF ty_list_report.

    DATA foo    TYPE ty_list_report.
    DATA struct TYPE REF TO cl_abap_structdescr.
    DATA descr  TYPE REF TO cl_abap_datadescr.

    struct ?= cl_abap_typedescr=>describe_by_data( foo ).
    descr ?= struct->get_component_type( 'HIDE_COLUMN' ).

    cl_abap_unit_assert=>assert_char_cp(
      act = descr->absolute_name
      exp = '*ABAP_BOOL*' ).

    cl_abap_unit_assert=>assert_equals(
      act = descr->get_relative_name( )
      exp = 'ABAP_BOOL' ).
  ENDMETHOD.

  METHOD nested_boolean2.
    TYPES:
      BEGIN OF ty_personalization,
        hide_column TYPE abap_bool,
      END OF ty_personalization,
      BEGIN OF ty_list_report,
        hide_column TYPE ty_personalization-hide_column,
      END OF ty_list_report.

    DATA foo TYPE ty_list_report-hide_column.
    DATA descr TYPE REF TO cl_abap_datadescr.

    descr ?= cl_abap_typedescr=>describe_by_data( foo ).

    cl_abap_unit_assert=>assert_char_cp(
      act = descr->absolute_name
      exp = '*ABAP_BOOL*' ).

    cl_abap_unit_assert=>assert_equals(
      act = descr->get_relative_name( )
      exp = 'ABAP_BOOL' ).
  ENDMETHOD.

  METHOD long_name.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.

    ls_component-name = 'FIELD11111FIELD11111FIELD111112'.
    ls_component-type = cl_abap_elemdescr=>get_i( ).
    APPEND ls_component TO lt_components.

    TRY.
        cl_abap_structdescr=>create( lt_components ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_struct_comp_name.
    ENDTRY.
  ENDMETHOD.

  METHOD namespaced_name.
    DATA: BEGIN OF foo,
            /foo/bar TYPE i,
          END OF foo.
    DATA struct_descr TYPE REF TO cl_abap_structdescr.
    DATA components TYPE abap_component_tab.
    DATA row LIKE LINE OF components.

    struct_descr ?= cl_abap_typedescr=>describe_by_data( foo ).
    components = struct_descr->get_components( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( components )
      exp = 1 ).
    READ TABLE components INDEX 1 INTO row.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = row-name
      exp = '/FOO/BAR' ).
  ENDMETHOD.

  METHOD get_included_view1.

    TYPES: BEGIN OF ty_struc,
             a TYPE string,
           END OF ty_struc.

    TYPES BEGIN OF ty_named_include.
    INCLUDE TYPE ty_struc AS named_with_suffix RENAMING WITH SUFFIX _suf.
    TYPES el TYPE string.
    TYPES END OF ty_named_include.

    DATA ls_data   TYPE ty_named_include.
    DATA lt_comps  TYPE cl_abap_structdescr=>included_view.
    DATA lo_struct TYPE REF TO cl_abap_structdescr.

    lo_struct ?= cl_abap_structdescr=>describe_by_data( ls_data ).
    lt_comps = lo_struct->get_included_view( ).

    READ TABLE lt_comps WITH KEY name = 'A_SUF' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc( ).
    READ TABLE lt_comps WITH KEY name = 'EL' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lines( lt_comps ) ).

  ENDMETHOD.

  METHOD get_included_view2.

    TYPES: BEGIN OF ty_struc,
         a TYPE string,
       END OF ty_struc.

    TYPES BEGIN OF ty_named_include.
    INCLUDE TYPE ty_struc AS named_with_suffix.
    TYPES el TYPE string.
    TYPES END OF ty_named_include.

    DATA ls_data   TYPE ty_named_include.
    DATA lt_comps  TYPE cl_abap_structdescr=>included_view.
    DATA lo_struct TYPE REF TO cl_abap_structdescr.

    lo_struct ?= cl_abap_structdescr=>describe_by_data( ls_data ).
    lt_comps = lo_struct->get_included_view( ).

    READ TABLE lt_comps WITH KEY name = 'A' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc( ).
    READ TABLE lt_comps WITH KEY name = 'EL' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lines( lt_comps ) ).

  ENDMETHOD.

  METHOD get_included_view3.

    TYPES: BEGIN OF ty_struc,
             a TYPE string,
           END OF ty_struc.

    TYPES BEGIN OF ty_named_include.
    INCLUDE TYPE ty_struc.
    TYPES el TYPE string.
    TYPES END OF ty_named_include.

    DATA ls_data   TYPE ty_named_include.
    DATA lt_comps  TYPE cl_abap_structdescr=>included_view.
    DATA lo_struct TYPE REF TO cl_abap_structdescr.

    lo_struct ?= cl_abap_structdescr=>describe_by_data( ls_data ).
    lt_comps = lo_struct->get_included_view( ).

    READ TABLE lt_comps WITH KEY name = 'A' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc( ).
    READ TABLE lt_comps WITH KEY name = 'EL' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lines( lt_comps ) ).

  ENDMETHOD.

  METHOD length.

    TYPES: BEGIN OF ty_struc,
             a TYPE x LENGTH 1,
           END OF ty_struc.

    DATA ls_data   TYPE ty_struc.
    DATA lt_comps  TYPE cl_abap_structdescr=>included_view.
    DATA lo_struct TYPE REF TO cl_abap_structdescr.
    DATA ls_type   LIKE LINE OF lo_struct->components.

    lo_struct ?= cl_abap_structdescr=>describe_by_data( ls_data ).

    READ TABLE lo_struct->components INDEX 1 INTO ls_type.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = ls_type-length ).

  ENDMETHOD.

  METHOD get_components_include.

    TYPES: BEGIN OF ty_struc,
            b TYPE c LENGTH 1,
           END OF ty_struc.

    TYPES BEGIN OF ty_struc_root.
            INCLUDE TYPE ty_struc AS nest RENAMING WITH SUFFIX _n.
    TYPES:
             a TYPE c LENGTH 1,
           END OF ty_struc_root.

    DATA ls_data        TYPE ty_struc_root.
    DATA lo_struct      TYPE REF TO cl_abap_structdescr.
    DATA lt_components  TYPE cl_abap_structdescr=>component_table.

    lo_struct ?= cl_abap_structdescr=>describe_by_data( ls_data ).
    lt_components = lo_struct->get_components( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lines( lt_components ) ).

  ENDMETHOD.

  METHOD get_symbols.

    TYPES: BEGIN OF ty_struc,
            b TYPE c LENGTH 1,
           END OF ty_struc.

    TYPES BEGIN OF ty_struc_root.
          INCLUDE TYPE ty_struc AS nest RENAMING WITH SUFFIX _n.
    TYPES:
             a TYPE c LENGTH 1,
           END OF ty_struc_root.

    DATA ls_data     TYPE ty_struc_root.
    DATA lo_struct   TYPE REF TO cl_abap_structdescr.
    DATA lt_symbols  TYPE cl_abap_structdescr=>symbol_table.

    lo_struct ?= cl_abap_structdescr=>describe_by_data( ls_data ).
    lt_symbols = lo_struct->get_symbols( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = lines( lt_symbols ) ).

    READ TABLE lt_symbols WITH KEY name = 'A' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc(
      exp = 0
      act = sy-subrc ).

    READ TABLE lt_symbols WITH KEY name = 'B_N' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc(
        exp = 0
        act = sy-subrc ).

  ENDMETHOD.

  METHOD two_grouped.

    TYPES: BEGIN OF ty1,
         foo TYPE c LENGTH 2,
       END OF ty1.

    TYPES: BEGIN OF ty2,
         bar TYPE c LENGTH 2,
       END OF ty2.

    TYPES BEGIN OF ty.
    INCLUDE TYPE ty1 AS g1.
    INCLUDE TYPE ty2 AS g2.
    TYPES END OF ty.

    DATA ref TYPE REF TO data.
    DATA data TYPE ty.
    DATA lo_struct TYPE REF TO cl_abap_structdescr.
    FIELD-SYMBOLS <fs> TYPE any.

    lo_struct ?= cl_abap_structdescr=>describe_by_data( data ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'FOO' )->kind
      exp = cl_abap_typedescr=>kind_elem ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'BAR' )->kind
      exp = cl_abap_typedescr=>kind_elem ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'G1' )->kind
      exp = cl_abap_typedescr=>kind_struct ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'G2' )->kind
      exp = cl_abap_typedescr=>kind_struct ).

* pass it through CREATE DATA and check the same again,
    CREATE DATA ref TYPE HANDLE lo_struct.
    ASSIGN ref->* TO <fs>.
    lo_struct ?= cl_abap_structdescr=>describe_by_data( <fs> ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'FOO' )->kind
      exp = cl_abap_typedescr=>kind_elem ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'BAR' )->kind
      exp = cl_abap_typedescr=>kind_elem ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'G1' )->kind
      exp = cl_abap_typedescr=>kind_struct ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_struct->get_component_type( 'G2' )->kind
      exp = cl_abap_typedescr=>kind_struct ).

  ENDMETHOD.

ENDCLASS.