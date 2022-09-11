CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS integer FOR TESTING RAISING cx_static_check.
    METHODS string FOR TESTING RAISING cx_static_check.
    METHODS abap_bool FOR TESTING RAISING cx_static_check.
    METHODS structure FOR TESTING RAISING cx_static_check.

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

  METHOD string.
    DATA lo_element TYPE REF TO cl_abap_elemdescr.
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
    DATA lo_value_new TYPE REF TO data.
    handle ?= cl_abap_typedescr=>describe_by_data( foo ).
    CREATE DATA lo_value_new TYPE HANDLE handle.
    cl_abap_unit_assert=>assert_bound( lo_value_new ).
  ENDMETHOD.

ENDCLASS.