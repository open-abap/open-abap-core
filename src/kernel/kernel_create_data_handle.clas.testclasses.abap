CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS integer FOR TESTING RAISING cx_static_check.
    METHODS packed FOR TESTING RAISING cx_static_check.
    METHODS string FOR TESTING RAISING cx_static_check.
    METHODS abap_bool FOR TESTING RAISING cx_static_check.
    METHODS structure FOR TESTING RAISING cx_static_check.
    METHODS table FOR TESTING RAISING cx_static_check.
    METHODS ref FOR TESTING RAISING cx_static_check.

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

ENDCLASS.