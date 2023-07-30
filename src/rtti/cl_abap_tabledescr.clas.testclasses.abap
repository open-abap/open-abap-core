CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS string_table FOR TESTING RAISING cx_static_check.
    METHODS has_unique_key1 FOR TESTING RAISING cx_static_check.
    METHODS has_unique_key2 FOR TESTING RAISING cx_static_check.
    METHODS get_with_keys FOR TESTING RAISING cx_static_check.
    METHODS keydefkind_user FOR TESTING RAISING cx_static_check.
    METHODS keydefkind_default FOR TESTING RAISING cx_static_check.
    METHODS keydefkind_tableline FOR TESTING RAISING cx_static_check.
    METHODS tablekind_hashed FOR TESTING RAISING cx_static_check.
    METHODS get_with_keys_prim FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD string_table.
    DATA tab TYPE string_table.
* just test it doesnt dump,
    cl_abap_typedescr=>describe_by_data( tab ).
  ENDMETHOD.

  METHOD get_with_keys.
    DATA lo_table TYPE REF TO cl_abap_tabledescr.
    DATA lt_keys  TYPE abap_table_keydescr_tab.
    DATA ls_key   LIKE LINE OF lt_keys.
    DATA lr_ref   TYPE REF TO data.

    FIELD-SYMBOLS <tab> TYPE ANY TABLE.

    ls_key-access_kind = cl_abap_tabledescr=>tablekind_std.
    ls_key-key_kind    = cl_abap_tabledescr=>keydefkind_default.
    ls_key-is_primary  = abap_true.
    APPEND ls_key TO lt_keys.

    lo_table = cl_abap_tabledescr=>get_with_keys(
      p_line_type = cl_abap_elemdescr=>get_i( )
      p_keys      = lt_keys ).

    cl_abap_unit_assert=>assert_not_initial( lo_table ).
    cl_abap_unit_assert=>assert_not_initial( lo_table->kind ).
    cl_abap_unit_assert=>assert_not_initial( lo_table->type_kind ).

    CREATE DATA lr_ref TYPE HANDLE lo_table.
    ASSIGN lr_ref->* TO <tab>.
    INSERT 2 INTO TABLE <tab>.
  ENDMETHOD.

  METHOD test1.

    DATA tab TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA type TYPE REF TO cl_abap_tabledescr.
    DATA row TYPE REF TO cl_abap_typedescr.

    type ?= cl_abap_typedescr=>describe_by_data( tab ).
    row = type->get_table_line_type( ).

    cl_abap_unit_assert=>assert_not_initial( row ).
*    WRITE '@KERNEL console.dir(row);'.
    cl_abap_unit_assert=>assert_equals(
      act = row->type_kind
      exp = cl_abap_typedescr=>typekind_int ).

  ENDMETHOD.

  METHOD has_unique_key1.
    DATA tab TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA tabledescr TYPE REF TO cl_abap_tabledescr.
    tabledescr ?= cl_abap_tabledescr=>describe_by_data( tab ).
    cl_abap_unit_assert=>assert_equals(
      act = tabledescr->has_unique_key
      exp = abap_false ).
  ENDMETHOD.

  METHOD has_unique_key2.
    DATA tab TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.
    DATA tabledescr TYPE REF TO cl_abap_tabledescr.
    tabledescr ?= cl_abap_tabledescr=>describe_by_data( tab ).
    cl_abap_unit_assert=>assert_equals(
      act = tabledescr->has_unique_key
      exp = abap_true ).
  ENDMETHOD.

  METHOD keydefkind_user.
    TYPES: BEGIN OF ts_field,
         name  TYPE string,
         value TYPE string,
       END OF ts_field.
    DATA lt_fields TYPE SORTED TABLE OF ts_field WITH UNIQUE KEY name.
    DATA table_descr TYPE REF TO cl_abap_tabledescr.

    table_descr ?= cl_abap_typedescr=>describe_by_data( lt_fields ).

    cl_abap_unit_assert=>assert_equals(
      act = table_descr->key_defkind
      exp = cl_abap_tabledescr=>keydefkind_user ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( table_descr->key )
      exp = 1 ).
  ENDMETHOD.

  METHOD keydefkind_default.
    TYPES: BEGIN OF ts_field,
             name  TYPE string,
             value TYPE string,
           END OF ts_field.
    DATA lt_fields TYPE STANDARD TABLE OF ts_field WITH DEFAULT KEY.
    DATA table_descr TYPE REF TO cl_abap_tabledescr.

    table_descr ?= cl_abap_typedescr=>describe_by_data( lt_fields ).

    cl_abap_unit_assert=>assert_equals(
      act = table_descr->key_defkind
      exp = cl_abap_tabledescr=>keydefkind_default ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( table_descr->key )
      exp = 2 ).
  ENDMETHOD.

  METHOD keydefkind_tableline.
    DATA tab TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.

    DATA table_descr TYPE REF TO cl_abap_tabledescr.

    table_descr ?= cl_abap_typedescr=>describe_by_data( tab ).

    cl_abap_unit_assert=>assert_equals(
      act = table_descr->key_defkind
      exp = cl_abap_tabledescr=>keydefkind_tableline ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( table_descr->key )
      exp = 1 ).
  ENDMETHOD.

  METHOD tablekind_hashed.
    DATA tab TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.
    DATA table_descr TYPE REF TO cl_abap_tabledescr.
    table_descr ?= cl_abap_typedescr=>describe_by_data( tab ).
    cl_abap_unit_assert=>assert_equals(
      act = table_descr->table_kind
      exp = cl_abap_tabledescr=>tablekind_hashed ).
  ENDMETHOD.

  METHOD get_with_keys_prim.

    DATA lr_data  TYPE REF TO data.
    DATA lo_type  TYPE REF TO cl_abap_datadescr.
    DATA lo_table TYPE REF TO cl_abap_tabledescr.
    DATA lt_keys  TYPE abap_table_keydescr_tab.
    DATA ls_row   TYPE t100.

    FIELD-SYMBOLS <ls_key>       LIKE LINE OF lt_keys.
    FIELD-SYMBOLS <ls_component> LIKE LINE OF <ls_key>-components.
    FIELD-SYMBOLS <lt_tab>       TYPE ANY TABLE.
    FIELD-SYMBOLS <ls_row>       TYPE any.

    APPEND INITIAL LINE TO lt_keys ASSIGNING <ls_key>.
    <ls_key>-access_kind = cl_abap_tabledescr=>tablekind_sorted.
    <ls_key>-key_kind    = cl_abap_tabledescr=>keydefkind_user.
    <ls_key>-is_primary  = abap_true.
    <ls_key>-is_unique   = abap_true.

    APPEND INITIAL LINE TO <ls_key>-components ASSIGNING <ls_component>.
    <ls_component>-name = 'SPRSL'.

    lo_type ?= cl_abap_structdescr=>describe_by_name( 'T100' ).

    lo_table = cl_abap_tabledescr=>get_with_keys(
      p_line_type = lo_type
      p_keys      = lt_keys ).

    CREATE DATA lr_data TYPE HANDLE lo_table.
    ASSIGN lr_data->* TO <lt_tab>.

    INSERT ls_row INTO TABLE <lt_tab>.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE <lt_tab> ASSIGNING <ls_row> FROM ls_row.
    cl_abap_unit_assert=>assert_subrc( ).

  ENDMETHOD.

ENDCLASS.