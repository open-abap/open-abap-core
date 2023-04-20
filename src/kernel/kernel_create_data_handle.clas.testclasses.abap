CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS integer FOR TESTING RAISING cx_static_check.
    METHODS packed FOR TESTING RAISING cx_static_check.
    METHODS numeric FOR TESTING RAISING cx_static_check.
    METHODS string FOR TESTING RAISING cx_static_check.
    METHODS abap_bool FOR TESTING RAISING cx_static_check.
    METHODS structure FOR TESTING RAISING cx_static_check.
    METHODS table FOR TESTING RAISING cx_static_check.
    METHODS ref FOR TESTING RAISING cx_static_check.
    METHODS unnamed_type FOR TESTING RAISING cx_static_check.
    METHODS table_table FOR TESTING RAISING cx_static_check.
    METHODS numc4 FOR TESTING RAISING cx_static_check.
    METHODS char5 FOR TESTING RAISING cx_static_check.
    METHODS hex2 FOR TESTING RAISING cx_static_check.
    METHODS reference_table FOR TESTING RAISING cx_static_check.

    METHODS ref_test1 CHANGING foo TYPE REF TO data.
    METHODS ref_test2 FOR TESTING RAISING cx_static_check.

    METHODS method1 FOR TESTING.
    METHODS method2 CHANGING data TYPE data.
    METHODS method3 CHANGING data TYPE data.
    METHODS method4 CHANGING data TYPE data.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD integer.
    DATA lo_element TYPE REF TO cl_abap_elemdescr.
    DATA lo_value_new TYPE REF TO data.
    FIELD-SYMBOLS <fs_value> TYPE simple.

    lo_element = cl_abap_elemdescr=>get_i( ).
    CREATE DATA lo_value_new TYPE HANDLE lo_element.
    ASSIGN lo_value_new->* TO <fs_value>.
    CLEAR <fs_value>.
    <fs_value> = 2.
  ENDMETHOD.

  METHOD packed.
    DATA lo_element   TYPE REF TO cl_abap_elemdescr.
    DATA lo_value_new TYPE REF TO data.
    DATA lv_foo       TYPE p LENGTH 2 DECIMALS 1.
    FIELD-SYMBOLS <fs_value> TYPE simple.

    lo_element ?= cl_abap_typedescr=>describe_by_data( lv_foo ).

    CREATE DATA lo_value_new TYPE HANDLE lo_element.
    ASSIGN lo_value_new->* TO <fs_value>.
    CLEAR <fs_value>.
    <fs_value> = 2.
  ENDMETHOD.

  METHOD string.
    DATA lo_element   TYPE REF TO cl_abap_elemdescr.
    DATA lo_value_new TYPE REF TO data.
    lo_element = cl_abap_elemdescr=>get_string( ).
    CREATE DATA lo_value_new TYPE HANDLE lo_element.
    cl_abap_unit_assert=>assert_bound( lo_value_new ).
  ENDMETHOD.

  METHOD numeric.
    DATA lo_element   TYPE REF TO cl_abap_elemdescr.
    DATA lo_value_new TYPE REF TO data.
    lo_element = cl_abap_elemdescr=>get_n( 2 ).
    CREATE DATA lo_value_new TYPE HANDLE lo_element.
    cl_abap_unit_assert=>assert_bound( lo_value_new ).
  ENDMETHOD.

  METHOD abap_bool.
    DATA foo TYPE abap_bool.
    DATA handle TYPE REF TO cl_abap_typedescr.
    DATA lo_value_new TYPE REF TO data.
    handle = cl_abap_typedescr=>describe_by_data( foo ).
    CREATE DATA lo_value_new TYPE HANDLE handle.
  ENDMETHOD.

  METHOD structure.
    DATA: BEGIN OF foo,
        field1 TYPE string,
        field2 TYPE string,
      END OF foo.
    DATA handle TYPE REF TO cl_abap_datadescr.
    FIELD-SYMBOLS <fs> TYPE any.
    DATA lo_value_new TYPE REF TO data.
    handle ?= cl_abap_typedescr=>describe_by_data( foo ).
    CREATE DATA lo_value_new TYPE HANDLE handle.
    cl_abap_unit_assert=>assert_bound( lo_value_new ).
    ASSIGN lo_value_new->* TO <fs>.
    ASSIGN COMPONENT 'FIELD1' OF STRUCTURE <fs> TO <fs>.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD table.
    DATA foo          TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA handle       TYPE REF TO cl_abap_datadescr.
    DATA lo_value_new TYPE REF TO data.

    handle ?= cl_abap_typedescr=>describe_by_data( foo ).
    CREATE DATA lo_value_new TYPE HANDLE handle.
    cl_abap_unit_assert=>assert_bound( lo_value_new ).
  ENDMETHOD.

  METHOD ref.
    DATA rr_data TYPE REF TO data.
    DATA lo_type TYPE REF TO cl_abap_structdescr.
    DATA lt_comp TYPE cl_abap_structdescr=>component_table.
    DATA row     LIKE LINE OF lt_comp.

    row-name = 'FOO'.
    row-type = cl_abap_refdescr=>get_ref_to_data( ).
    APPEND row TO lt_comp.

    lo_type = cl_abap_structdescr=>create( lt_comp ).
    CREATE DATA rr_data TYPE HANDLE lo_type.
  ENDMETHOD.

  METHOD unnamed_type.
    DATA lo_data  TYPE REF TO data.
    DATA lo_descr TYPE REF TO cl_abap_typedescr.
    DATA lv_foo   TYPE c LENGTH 2.

    lo_descr = cl_abap_typedescr=>describe_by_data( lv_foo ).
* todo,
*    CREATE DATA lo_data TYPE (lo_descr->absolute_name).
  ENDMETHOD.

  METHOD table_table.
    DATA lr_ref TYPE REF TO data.
    DATA lo_descr TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS <fs> TYPE ANY TABLE.

    lo_descr = cl_abap_tabledescr=>create( cl_abap_elemdescr=>get_i( ) ).
    CREATE DATA lr_ref TYPE HANDLE lo_descr.
    ASSIGN lr_ref->* TO <fs>.
    INSERT 2 INTO TABLE <fs>.
    ASSERT lines( <fs> ) = 1.
  ENDMETHOD.

  METHOD numc4.
    DATA data    TYPE n LENGTH 4.
    DATA lr_ref  TYPE REF TO data.
    DATA type    TYPE REF TO cl_abap_elemdescr.
    DATA lv_text TYPE c LENGTH 50.

    FIELD-SYMBOLS <fs> TYPE any.

    type ?= cl_abap_typedescr=>describe_by_data( data ).
    CREATE DATA lr_ref TYPE HANDLE type.
    ASSIGN lr_ref->* TO <fs>.
    <fs> = 1.
    WRITE <fs> TO lv_text.
    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = '0001' ).
  ENDMETHOD.

  METHOD char5.
    DATA data    TYPE c LENGTH 5.
    DATA lr_ref  TYPE REF TO data.
    DATA type    TYPE REF TO cl_abap_elemdescr.
    DATA lv_text TYPE c LENGTH 50.
    FIELD-SYMBOLS <fs> TYPE any.

    type ?= cl_abap_typedescr=>describe_by_data( data ).
    CREATE DATA lr_ref TYPE HANDLE type.
    ASSIGN lr_ref->* TO <fs>.
    <fs> = 'hello world'.
    WRITE <fs> TO lv_text.
    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = 'hello' ).
  ENDMETHOD.

  METHOD hex2.
    DATA data    TYPE x LENGTH 2.
    DATA lr_ref  TYPE REF TO data.
    DATA type    TYPE REF TO cl_abap_elemdescr.
    DATA lv_text TYPE c LENGTH 50.
    FIELD-SYMBOLS <fs> TYPE any.

    type ?= cl_abap_typedescr=>describe_by_data( data ).
    CREATE DATA lr_ref TYPE HANDLE type.
    ASSIGN lr_ref->* TO <fs>.
    <fs> = '1122334455'.
    WRITE <fs> TO lv_text.
    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = '1122' ).
  ENDMETHOD.

  METHOD reference_table.

    DATA: BEGIN OF ls_data,
            table TYPE REF TO data,
          END OF ls_data.

    DATA: ls_comp_descr   TYPE abap_componentdescr,
          lt_comp_descr   TYPE abap_component_tab,
          lo_table_descr  TYPE REF TO cl_abap_tabledescr,
          lo_struct_descr TYPE REF TO cl_abap_structdescr.

    FIELD-SYMBOLS <fs> TYPE any.

    ls_comp_descr-name = `FIELD1`.
    ls_comp_descr-type = cl_abap_elemdescr=>get_string( ).
    INSERT ls_comp_descr INTO TABLE lt_comp_descr.

    lo_struct_descr = cl_abap_structdescr=>create( lt_comp_descr ).
    lo_table_descr  = cl_abap_tabledescr=>create( lo_struct_descr ).
    CREATE DATA ls_data-table TYPE HANDLE lo_table_descr.

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_typedescr=>describe_by_data_ref( ls_data-table )->type_kind
      exp = cl_abap_typedescr=>typekind_table ).

    ASSIGN ls_data-table->* TO <fs>.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_typedescr=>describe_by_data( <fs> )->type_kind
      exp = cl_abap_typedescr=>typekind_table ).

  ENDMETHOD.

  METHOD ref_test1.
    DATA handle TYPE REF TO cl_abap_elemdescr.
    handle = cl_abap_elemdescr=>get_string( ).
    CREATE DATA foo TYPE HANDLE handle.
  ENDMETHOD.

  METHOD ref_test2.
    DATA bar TYPE REF TO data.
    FIELD-SYMBOLS <any> TYPE any.
    ref_test1( CHANGING foo = bar ).
    ASSIGN bar->* TO <any>.
    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = '' ).
  ENDMETHOD.

  METHOD method1.
    DATA lr_actual TYPE REF TO data.
    FIELD-SYMBOLS <any> TYPE any.

    method2( CHANGING data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'OSYSTEM' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD method2.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    FIELD-SYMBOLS <any> TYPE any.

    CLEAR ls_component.
    ls_component-name = 'OSYSTEM'.
    ls_component-type = cl_abap_refdescr=>get_ref_to_data( ).
    APPEND ls_component TO lt_components.
    lo_struct = cl_abap_structdescr=>create( lt_components ).
    CREATE DATA data TYPE HANDLE lo_struct.

    ASSIGN data->* TO <any>.

    method3( CHANGING data = <any> ).
  ENDMETHOD.

  METHOD method3.
    FIELD-SYMBOLS <any> TYPE any.
    ASSIGN COMPONENT 'OSYSTEM' OF STRUCTURE data TO <any>.

    method4( CHANGING data = <any> ).
  ENDMETHOD.

  METHOD method4.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    FIELD-SYMBOLS <any> TYPE any.

    CLEAR ls_component.
    ls_component-name = 'ID'.
    ls_component-type = cl_abap_refdescr=>get_ref_to_data( ).
    APPEND ls_component TO lt_components.
    lo_struct = cl_abap_structdescr=>create( lt_components ).
    CREATE DATA data TYPE HANDLE lo_struct.
  ENDMETHOD.

ENDCLASS.