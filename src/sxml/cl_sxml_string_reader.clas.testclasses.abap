CLASS ltcl_sxml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_node,
             type TYPE if_sxml_node=>node_type,
           END OF ty_node.

    TYPES ty_nodes TYPE STANDARD TABLE OF ty_node WITH DEFAULT KEY.

    METHODS test1 FOR TESTING.

    METHODS dump_nodes
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rt_nodes) TYPE ty_nodes.

ENDCLASS.

CLASS ltcl_sxml IMPLEMENTATION.

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

    DATA lt_actual TYPE ty_nodes.
    DATA ls_node LIKE LINE OF lt_actual.
    DATA lt_expected TYPE ty_nodes.

    lt_actual = dump_nodes( '{"key1": [2, 34]}' ).

    ls_node-type = if_sxml_node=>co_nt_element_open.
    APPEND ls_node TO lt_expected.

    ls_node-type = if_sxml_node=>co_nt_element_close.
    APPEND ls_node TO lt_expected.

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = lt_expected ).

  ENDMETHOD.

ENDCLASS.