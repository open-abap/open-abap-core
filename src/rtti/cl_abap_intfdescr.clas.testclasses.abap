CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.
    METHODS get_attribute_type FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.
    DATA descr TYPE REF TO cl_abap_typedescr.
    descr = cl_abap_typedescr=>describe_by_name( 'IF_MESSAGE' ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->kind
      exp = cl_abap_typedescr=>kind_intf ).
  ENDMETHOD.

  METHOD get_attribute_type.
    DATA intfdescr TYPE REF TO cl_abap_intfdescr.
    DATA datadescr TYPE REF TO cl_abap_datadescr.

    intfdescr ?= cl_abap_typedescr=>describe_by_name( 'IF_T100_MESSAGE' ).
    datadescr = intfdescr->get_attribute_type( 'DEFAULT_TEXTID' ).

    cl_abap_unit_assert=>assert_equals(
      act = datadescr->kind
      exp = cl_abap_typedescr=>kind_struct ).
  ENDMETHOD.

ENDCLASS.