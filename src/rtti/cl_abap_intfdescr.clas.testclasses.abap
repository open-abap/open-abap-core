CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.
    DATA descr TYPE REF TO cl_abap_typedescr.
    descr = cl_abap_typedescr=>describe_by_name( 'IF_MESSAGE' ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->kind
      exp = cl_abap_typedescr=>kind_intf ).
  ENDMETHOD.

ENDCLASS.