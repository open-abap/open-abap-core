CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.
    METHODS get_attribute_type FOR TESTING RAISING cx_static_check.
    METHODS attributes FOR TESTING RAISING cx_static_check.

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

  METHOD attributes.
    DATA lo_intfdescr TYPE REF TO cl_abap_intfdescr.
    DATA ls_row TYPE abap_attrdescr.

    lo_intfdescr ?= cl_abap_intfdescr=>describe_by_name( 'IF_T100_MESSAGE' ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_intfdescr->attributes )
      exp = 2 ).

    LOOP AT lo_intfdescr->attributes INTO ls_row.
      CASE sy-tabix.
        WHEN 1.
          cl_abap_unit_assert=>assert_equals(
            act = ls_row-name
            exp = 'DEFAULT_TEXTID' ).
          cl_abap_unit_assert=>assert_equals(
            act = ls_row-is_constant
            exp = abap_true ).
          cl_abap_unit_assert=>assert_equals(
            act = ls_row-visibility
            exp = cl_abap_intfdescr=>public ).
        WHEN 2.
          cl_abap_unit_assert=>assert_equals(
            act = ls_row-name
            exp = 'T100KEY' ).
          cl_abap_unit_assert=>assert_equals(
            act = ls_row-is_constant
            exp = abap_false ).
          cl_abap_unit_assert=>assert_equals(
            act = ls_row-visibility
            exp = cl_abap_intfdescr=>public ).
        WHEN OTHERS.
          ASSERT 1 = 2.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.