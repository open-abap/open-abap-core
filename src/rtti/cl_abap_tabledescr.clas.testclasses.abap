CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

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

ENDCLASS.