CLASS ltcl_sxml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_sxml IMPLEMENTATION.

  METHOD test1.

    DATA li_reader TYPE REF TO if_sxml_reader.
    DATA li_node TYPE REF TO if_sxml_node.
    DATA lt_types TYPE STANDARD TABLE OF i.
    DATA lt_expected TYPE STANDARD TABLE OF i.

    li_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '{}' ) ).
    cl_abap_unit_assert=>assert_not_initial( li_reader ).

    li_node = li_reader->read_next_node( ).
    APPEND li_node->type TO lt_types.

    li_node = li_reader->read_next_node( ).
    APPEND li_node->type TO lt_types.

    li_node = li_reader->read_next_node( ).
    cl_abap_unit_assert=>assert_initial( li_node ).

    APPEND if_sxml_node=>co_nt_element_open TO lt_expected.
    APPEND if_sxml_node=>co_nt_element_close TO lt_expected.

    cl_abap_unit_assert=>assert_equals(
      act = lt_types
      exp = lt_expected ).

  ENDMETHOD.

ENDCLASS.