CLASS ltcl_json DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_node,
             type  TYPE if_sxml_node=>node_type,
             name  TYPE string,
             key   TYPE string,
             value TYPE string,
           END OF ty_node.

    TYPES ty_nodes TYPE STANDARD TABLE OF ty_node WITH DEFAULT KEY.

    DATA mt_expected TYPE ty_nodes.

    METHODS setup.
    METHODS add_expected
      IMPORTING
        iv_type  TYPE if_sxml_node=>node_type
        iv_name  TYPE string OPTIONAL
        iv_key   TYPE string OPTIONAL
        iv_value TYPE string OPTIONAL.
    METHODS dump_nodes
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rt_nodes) TYPE ty_nodes.

    METHODS empty_object FOR TESTING.
    METHODS empty_array FOR TESTING.
    METHODS simple_integer FOR TESTING.
    METHODS simple_true FOR TESTING.
    METHODS simple_null FOR TESTING.
    METHODS integer_array FOR TESTING.
    METHODS key_value FOR TESTING.
    METHODS key_empty FOR TESTING.
    METHODS two_keys FOR TESTING.
    METHODS two_array FOR TESTING.
    METHODS array_with_object FOR TESTING.
    METHODS object_with_object FOR TESTING.
    METHODS bad_json_read_next_node FOR TESTING.
    METHODS bad_json_next_node FOR TESTING.
    METHODS bad_json_xml_offset FOR TESTING.
    METHODS next_node FOR TESTING.
    METHODS skip_node FOR TESTING.

ENDCLASS.

CLASS ltcl_json IMPLEMENTATION.

  METHOD setup.
    CLEAR mt_expected.
  ENDMETHOD.

  METHOD add_expected.
    DATA ls_expected LIKE LINE OF mt_expected.
    ls_expected-type  = iv_type.
    ls_expected-name  = iv_name.
    ls_expected-key   = iv_key.
    ls_expected-value = iv_value.
    APPEND ls_expected TO mt_expected.
  ENDMETHOD.

  METHOD dump_nodes.

    DATA li_node TYPE REF TO if_sxml_node.
    DATA li_close TYPE REF TO if_sxml_close_element.
    DATA li_open TYPE REF TO if_sxml_open_element.
    DATA li_reader TYPE REF TO if_sxml_reader.
    DATA ls_node TYPE ty_node.
    DATA lt_attributes TYPE if_sxml_attribute=>attributes.
    DATA li_attribute TYPE REF TO if_sxml_attribute.
    DATA li_value TYPE REF TO if_sxml_value_node.

    li_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( iv_json ) ).
    cl_abap_unit_assert=>assert_not_initial( li_reader ).

    DO.
      li_node = li_reader->read_next_node( ).
      IF li_node IS INITIAL.
        EXIT.
      ENDIF.

      CLEAR ls_node.
      ls_node-type = li_node->type.

      CASE li_node->type.
        WHEN if_sxml_node=>co_nt_element_open.
          li_open ?= li_node.
          ls_node-name = li_open->qname-name.

          lt_attributes = li_open->get_attributes( ).
          LOOP AT lt_attributes INTO li_attribute.
            ls_node-key = li_attribute->get_value( ).
          ENDLOOP.

        WHEN if_sxml_node=>co_nt_element_close.
          li_close ?= li_node.
          ls_node-name = li_close->qname-name.

        WHEN if_sxml_node=>co_nt_value.
          li_value ?= li_node.
          ls_node-value = li_value->get_value( ).
      ENDCASE.

      APPEND ls_node TO rt_nodes.
    ENDDO.

  ENDMETHOD.

  METHOD empty_object.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '{}' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'object' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'object' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD empty_array.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '[]' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'array' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'array' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD simple_integer.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '2' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'num' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = '2' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'num' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD simple_true.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( 'true' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'bool' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = 'true' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'bool' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD simple_null.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( 'null' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'null' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'null' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD integer_array.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '[2]' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'array' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'num' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = '2' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'num' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'array' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD key_value.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '{"key1": "value1"}' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'object' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'str'
                  iv_key  = 'key1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = 'value1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'str' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'object' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD key_empty.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '{"key1": []}' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'object' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'array'
                  iv_key  = 'key1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'array' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'object' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD two_keys.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '{"key1": "value1", "key2": "value2"}' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'object' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'str'
                  iv_key  = 'key1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = 'value1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'str' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'str'
                  iv_key  = 'key2' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = 'value2' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'str' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'object' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD two_array.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '[1, 2]' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'array' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'num' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = '1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'num' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'num' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = '2' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'num' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'array' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD array_with_object.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '[{"key": "value"}]' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'array' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'object' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'str'
                  iv_key  = 'key' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = 'value' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'str' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'object' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'array' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD object_with_object.

    DATA lt_actual TYPE ty_nodes.

    lt_actual = dump_nodes( '{"key": {"sub": "value"}}' ).

    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'object' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'object'
                  iv_key = 'key' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'str'
                  iv_key = 'sub' ).
    add_expected( iv_type = if_sxml_node=>co_nt_value
                  iv_value = 'value' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'str' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'object' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'object' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD bad_json_xml_offset.
    DATA lv_json TYPE string.
    DATA lo_node TYPE REF TO if_sxml_node.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    DATA cx TYPE REF TO cx_sxml_parse_error.

    lv_json = '{' && cl_abap_char_utilities=>newline
      && '"ok": "abc",' && cl_abap_char_utilities=>newline
      && '"error"' && cl_abap_char_utilities=>newline
      && '}'.
    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( lv_json ) ).
    TRY.
        DO.
          lo_node = lo_reader->read_next_node( ).
          IF lo_node IS NOT BOUND.
            EXIT.
          ENDIF.
        ENDDO.
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO cx.
* NodeJS 16 will set the postion, but NodeJS 20 does not
        " cl_abap_unit_assert=>assert_equals(
        "   act = cx->xml_offset
        "   exp = 23 ).
    ENDTRY.
  ENDMETHOD.

  METHOD bad_json_read_next_node.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( 'moo, hello world' ) ).
    TRY.
        lo_reader->read_next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error.
* ok, expected
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD bad_json_next_node.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( 'moo, hello world' ) ).
    TRY.
        lo_reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error.
* ok, expected
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD next_node.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '{"hello": 2}' ) ).

    lo_reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->node_type
      exp = if_sxml_node=>co_nt_element_open ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->name
      exp = 'object' ).

    lo_reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->node_type
      exp = if_sxml_node=>co_nt_element_open ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->name
      exp = 'num' ).
  ENDMETHOD.

  METHOD skip_node.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '{"hello": 2}' ) ).

    lo_reader->skip_node( ).

    lo_reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->node_type
      exp = if_sxml_node=>co_nt_element_open ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->name
      exp = 'object' ).
  ENDMETHOD.

ENDCLASS.