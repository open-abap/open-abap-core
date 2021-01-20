CLASS ltcl_sxml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_node,
             type TYPE if_sxml_node=>node_type,
           END OF ty_node.

    TYPES ty_nodes TYPE STANDARD TABLE OF ty_node WITH DEFAULT KEY.

    DATA mt_expected TYPE ty_nodes.

    METHODS setup.
    METHODS add_expected_type
      IMPORTING iv_type TYPE if_sxml_node=>node_type.
    METHODS dump_nodes
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rt_nodes) TYPE ty_nodes.

    METHODS test1 FOR TESTING.
    METHODS test2 FOR TESTING.

ENDCLASS.

CLASS ltcl_sxml IMPLEMENTATION.

  METHOD setup.
    CLEAR mt_expected.
  ENDMETHOD.

  METHOD add_expected_type.
    DATA ls_expected LIKE LINE OF mt_expected.
    ls_expected-type = iv_type.
    APPEND ls_expected TO mt_expected.
  ENDMETHOD.

  METHOD dump_nodes.

    DATA li_node TYPE REF TO if_sxml_node.
    DATA li_reader TYPE REF TO if_sxml_reader.
    DATA ls_node TYPE ty_node.

    li_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( iv_json ) ).
    cl_abap_unit_assert=>assert_not_initial( li_reader ).

    DO.
      li_node = li_reader->read_next_node( ).
      IF li_node IS INITIAL.
        EXIT.
      ENDIF.
      CLEAR ls_node.
      ls_node-type = li_node->type.
      APPEND ls_node TO rt_nodes.
    ENDDO.

  ENDMETHOD.

  METHOD test1.

    DATA lt_actual1 TYPE ty_nodes.
    DATA lt_actual2 TYPE ty_nodes.

    lt_actual1 = dump_nodes( '{}' ).
    lt_actual2 = dump_nodes( '[]' ).

    add_expected_type( if_sxml_node=>co_nt_element_open ).
    add_expected_type( if_sxml_node=>co_nt_element_close ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual1
      exp = mt_expected ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual2
      exp = mt_expected ).

  ENDMETHOD.

  METHOD test2.

  ENDMETHOD.

ENDCLASS.