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
      IMPORTING iv_json         TYPE string
      RETURNING VALUE(rt_nodes) TYPE ty_nodes.

    METHODS empty_object FOR TESTING RAISING cx_static_check.
    METHODS empty_array FOR TESTING RAISING cx_static_check.
    METHODS simple_integer FOR TESTING RAISING cx_static_check.
    METHODS simple_true FOR TESTING RAISING cx_static_check.
    METHODS simple_null FOR TESTING RAISING cx_static_check.
    METHODS integer_array FOR TESTING RAISING cx_static_check.
    METHODS key_value FOR TESTING RAISING cx_static_check.
    METHODS key_empty FOR TESTING RAISING cx_static_check.
    METHODS empty_key_has_name_attribute FOR TESTING RAISING cx_static_check.
    METHODS array_element_has_no_attribute FOR TESTING RAISING cx_static_check.
    METHODS two_keys FOR TESTING RAISING cx_static_check.
    METHODS two_array FOR TESTING RAISING cx_static_check.
    METHODS array_with_object FOR TESTING RAISING cx_static_check.
    METHODS object_with_object FOR TESTING RAISING cx_static_check.
    METHODS bad_json_read_next_node FOR TESTING RAISING cx_static_check.
    METHODS bad_json_next_node FOR TESTING RAISING cx_static_check.
    METHODS bad_json_xml_offset FOR TESTING RAISING cx_static_check.
    METHODS next_node FOR TESTING RAISING cx_static_check.
    METHODS skip_node FOR TESTING RAISING cx_static_check.
    METHODS read_next_node FOR TESTING RAISING cx_static_check.
    METHODS read_next_node2 FOR TESTING RAISING cx_static_check.
    METHODS read_next_node3 FOR TESTING RAISING cx_static_check.

ENDCLASS.
CLASS ltcl_xml_probe2 DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS error_at IMPORTING xml TYPE string reason TYPE string after_open TYPE abap_bool DEFAULT abap_false.
    METHODS charrefs FOR TESTING RAISING cx_static_check.
    METHODS attribute_values FOR TESTING RAISING cx_static_check.
    METHODS names FOR TESTING RAISING cx_static_check.
    METHODS prefixes FOR TESTING RAISING cx_static_check.
    METHODS duplicates FOR TESTING RAISING cx_static_check.
    METHODS encodings FOR TESTING RAISING cx_static_check.
    METHODS document_edges FOR TESTING RAISING cx_static_check.
    METHODS token_gaps FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_xml_probe2 IMPLEMENTATION.
  METHOD error_at.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA error TYPE REF TO cx_sxml_parse_error.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( xml ) ).
    IF after_open = abap_true.
      reader->next_node( ).
      cl_abap_unit_assert=>assert_equals( act = reader->node_type
                                          exp = if_sxml_node=>co_nt_element_open ).
    ENDIF.
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals( act = error->error_text
                                            exp = reason ).
    ENDTRY.
  ENDMETHOD.

  METHOD charrefs.
    DATA reader TYPE REF TO if_sxml_reader.
    error_at( xml        = '<a>&#x110000;</a>'
              reason     = 'illegal charref value'
              after_open = abap_true ).
    error_at( xml        = '<a>&#xD800;</a>'
              reason     = 'illegal charref value'
              after_open = abap_true ).
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a>&#0;</a>' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->node_type
                                        exp = if_sxml_node=>co_nt_value ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = cl_abap_conv_in_ce=>uccpi( 0 ) ).
  ENDMETHOD.

  METHOD attribute_values.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA xml TYPE string.
    xml = '<a x="1' && cl_abap_char_utilities=>horizontal_tab && '2'
      && cl_abap_char_utilities=>newline && '3" y="&#9;&#10;" z="&quot;&apos;&gt;"/>'.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( xml ) ).
    reader->next_node( ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
      exp                                   = '1' && cl_abap_char_utilities=>horizontal_tab && '2' && cl_abap_char_utilities=>newline && '3' ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
      exp                                   = cl_abap_char_utilities=>horizontal_tab && cl_abap_char_utilities=>newline ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = '"''>' ).
    error_at( xml    = '<a x="a<b"/>'
              reason = 'closing ''"'' expected' ).
  ENDMETHOD.

  METHOD names.
    DATA reader TYPE REF TO if_sxml_reader.
    error_at( xml    = '<1a/>'
              reason = 'invalid character after ''<''' ).
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a.b-c1/>' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = 'a.b-c1' ).
  ENDMETHOD.

  METHOD prefixes.
    DATA reader TYPE REF TO if_sxml_reader.
    error_at( xml    = '<p:a/>'
              reason = 'undeclared namespace prefix' ).
    error_at( xml    = '<a p:x="1"/>'
              reason = 'undeclared namespace prefix' ).
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a xml:lang="en"/>' ) ).
    reader->next_node( ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals( act = reader->prefix
                                        exp = 'xml' ).
    cl_abap_unit_assert=>assert_equals( act = reader->nsuri
                                        exp = 'http://www.w3.org/XML/1998/namespace' ).
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<xml:a/>' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->nsuri
                                        exp = 'http://www.w3.org/XML/1998/namespace' ).
  ENDMETHOD.

  METHOD duplicates.
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to(
      '<a xmlns:p="urn:first" xmlns:p="urn:second" x="1" x="2"/>' ) ).
    reader->next_node( ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = 'x' ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = '1' ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = 'x' ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = '2' ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals( act = reader->node_type
                                        exp = if_sxml_node=>co_nt_final ).
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to(
      '<a xmlns:p="urn:first" xmlns:p="urn:second"><p:b/></a>' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->nsuri
                                        exp = 'urn:second' ).
  ENDMETHOD.

  METHOD encodings.
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( CONV xstring( 'EFBBBF3C612F3E' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = 'a' ).
    reader = cl_sxml_string_reader=>create( CONV xstring( 'FFFE3C0061002F003E00' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = 'a' ).
    reader = cl_sxml_string_reader=>create( CONV xstring( 'FEFF003C0061002F003E' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = 'a' ).
    reader = cl_sxml_string_reader=>create( CONV xstring(
      '3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D2269736F2D383835392D31223F3E3C613EE43C2F613E' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = cl_abap_conv_in_ce=>uccpi( 228 ) ).
  ENDMETHOD.

  METHOD document_edges.
    DATA reader TYPE REF TO if_sxml_reader.
    error_at( xml    = '<!DOCTYPE a><a/>'
              reason = '''<!--'' or ''<![CDATA['' expected' ).
    error_at( xml        = '<a><!--a--b--></a>'
              reason     = '-- in comment'
              after_open = abap_true ).
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<![CDATA[pre]]><a/>tail' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->node_type
                                        exp = if_sxml_node=>co_nt_value ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = '' ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = 'pre' ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = 'a' ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->node_type
                                        exp = if_sxml_node=>co_nt_final ).
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '  <a/>' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = 'a' ).
  ENDMETHOD.

  METHOD token_gaps.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA node TYPE REF TO if_sxml_node.
    DATA close TYPE REF TO if_sxml_close_element.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a x="1">&amp;&lt;&gt;&quot;&apos;</a>' ) ).
    cl_abap_unit_assert=>assert_equals( act = reader->value_type
                                        exp = 0 ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value_type
                                        exp = 0 ).
    reader->next_attribute( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = '&<>"''' ).
    cl_abap_unit_assert=>assert_equals( act = reader->value_type
                                        exp = if_sxml_value=>co_vt_text ).
    node = reader->read_next_node( ).
    close ?= node.
    cl_abap_unit_assert=>assert_equals( act = node->type
                                        exp = if_sxml_node=>co_nt_element_close ).
    cl_abap_unit_assert=>assert_equals( act = close->qname-name
                                        exp = 'a' ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = '&<>"''' ).
  ENDMETHOD.
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
    add_expected( iv_type  = if_sxml_node=>co_nt_value
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
    add_expected( iv_type  = if_sxml_node=>co_nt_value
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
    add_expected( iv_type  = if_sxml_node=>co_nt_value
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
    add_expected( iv_type  = if_sxml_node=>co_nt_value
                  iv_value = 'value1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'str' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'object' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_actual
      exp = mt_expected ).

  ENDMETHOD.

  METHOD empty_key_has_name_attribute.
* "" is a legal JSON key. The member carries a name attribute whose value is
* empty - the attribute has to BE there, otherwise the element is
* indistinguishable from an element of an array and a consumer that reads the
* attribute by index has nothing to read
    DATA li_reader TYPE REF TO if_sxml_reader.
    DATA li_node   TYPE REF TO if_sxml_node.
    DATA li_open   TYPE REF TO if_sxml_open_element.
    DATA lt_attr   TYPE if_sxml_attribute=>attributes.
    DATA li_attr   TYPE REF TO if_sxml_attribute.

    li_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '{"": 1}' ) ).

    li_node = li_reader->read_next_node( ).
    li_node = li_reader->read_next_node( ).
    li_open ?= li_node.

    lt_attr = li_open->get_attributes( ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_attr )
      exp = 1 ).

    READ TABLE lt_attr INDEX 1 INTO li_attr.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = li_attr->qname-name
      exp = 'name' ).
    cl_abap_unit_assert=>assert_initial( li_attr->get_value( ) ).

  ENDMETHOD.

  METHOD array_element_has_no_attribute.
* the other side of the same distinction: an element of an array has no name,
* so it carries no attribute at all
    DATA li_reader TYPE REF TO if_sxml_reader.
    DATA li_node   TYPE REF TO if_sxml_node.
    DATA li_open   TYPE REF TO if_sxml_open_element.

    li_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '[1]' ) ).

    li_node = li_reader->read_next_node( ).
    li_node = li_reader->read_next_node( ).
    li_open ?= li_node.

    cl_abap_unit_assert=>assert_initial( li_open->get_attributes( ) ).

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
    add_expected( iv_type  = if_sxml_node=>co_nt_value
                  iv_value = 'value1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'str' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'str'
                  iv_key  = 'key2' ).
    add_expected( iv_type  = if_sxml_node=>co_nt_value
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
    add_expected( iv_type  = if_sxml_node=>co_nt_value
                  iv_value = '1' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_close
                  iv_name = 'num' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'num' ).
    add_expected( iv_type  = if_sxml_node=>co_nt_value
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
    add_expected( iv_type  = if_sxml_node=>co_nt_value
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
                  iv_key  = 'key' ).
    add_expected( iv_type = if_sxml_node=>co_nt_element_open
                  iv_name = 'str'
                  iv_key  = 'sub' ).
    add_expected( iv_type  = if_sxml_node=>co_nt_value
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

  METHOD read_next_node.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    DATA lo_node   TYPE REF TO if_sxml_node.

    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '{"hello": 2}' ) ).

    lo_node = lo_reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_node->type
      exp = if_sxml_node=>co_nt_element_open ).

    lo_node = lo_reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_node->type
      exp = if_sxml_node=>co_nt_element_open ).

    lo_node = lo_reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_node->type
      exp = if_sxml_node=>co_nt_value ).

    lo_node = lo_reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_node->type
      exp = if_sxml_node=>co_nt_element_close ).

    lo_node = lo_reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_node->type
      exp = if_sxml_node=>co_nt_element_close ).
  ENDMETHOD.

  METHOD read_next_node2.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    DATA lo_node   TYPE REF TO if_sxml_node.

    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '{"hello": 2}' ) ).

    lo_reader->read_next_node( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->node_type
      exp = if_sxml_node=>co_nt_element_open ).
  ENDMETHOD.

  METHOD read_next_node3.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    DATA lo_node   TYPE REF TO if_sxml_node.

    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '{"hello": 2}' ) ).

    lo_reader->read_next_node( ).
    lo_reader->read_next_node( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->node_type
      exp = if_sxml_node=>co_nt_element_open ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_reader->value
      exp = 'hello' ).
  ENDMETHOD.

ENDCLASS.
CLASS ltcl_xml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS concrete_nodes FOR TESTING RAISING cx_static_check.
    METHODS node_accessors FOR TESTING RAISING cx_static_check.
    METHODS tokens FOR TESTING RAISING cx_static_check.
    METHODS namespaces FOR TESTING RAISING cx_static_check.
    METHODS errors FOR TESTING RAISING cx_static_check.
    METHODS skip FOR TESTING RAISING cx_static_check.
    METHODS whitespace FOR TESTING RAISING cx_static_check.
    METHODS nested_namespaces FOR TESTING RAISING cx_static_check.
    METHODS scale FOR TESTING RAISING cx_static_check.
    METHODS scale10 FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_xml IMPLEMENTATION.
  METHOD node_accessors.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA node TYPE REF TO if_sxml_node.
    DATA open TYPE REF TO if_sxml_open_element.
    DATA close TYPE REF TO if_sxml_close_element.
    DATA value TYPE REF TO if_sxml_value_node.
    DATA attribute_value TYPE REF TO if_sxml_value.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to(
      '<p:a xmlns:p="urn:p" p:x="A&amp;B" empty="">&#65;</p:a>' ) ).
    node = reader->read_next_node( ).
    open ?= node.
    cl_abap_unit_assert=>assert_equals(
      act = open->qname-name
      exp = 'a' ).
    cl_abap_unit_assert=>assert_equals(
      act = open->qname-namespace
      exp = 'urn:p' ).
    cl_abap_unit_assert=>assert_equals(
      act = open->prefix
      exp = 'p' ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( open->get_attributes( ) )
      exp = 2 ).
    attribute_value = open->get_attribute_value(
      name  = 'x'
      nsuri = 'urn:p' ).
    cl_abap_unit_assert=>assert_bound( attribute_value ).
    cl_abap_unit_assert=>assert_equals(
      act = attribute_value->type
      exp = if_sxml_value=>co_vt_text ).
    cl_abap_unit_assert=>assert_equals(
      act = attribute_value->get_value( )
      exp = 'A&B' ).
    cl_abap_unit_assert=>assert_equals(
      act = attribute_value->get_value_raw( )
      exp = cl_abap_codepage=>convert_to( 'A&B' ) ).
    attribute_value = open->get_attribute_value( name = 'empty' ).
    cl_abap_unit_assert=>assert_bound( attribute_value ).
    cl_abap_unit_assert=>assert_initial( attribute_value->get_value( ) ).
    attribute_value = open->get_attribute_value( name = 'x' ).
    cl_abap_unit_assert=>assert_initial( attribute_value ).
    node = reader->read_next_node( ).
    value ?= node.
    cl_abap_unit_assert=>assert_equals(
      act = value->get_value( )
      exp = 'A' ).
    cl_abap_unit_assert=>assert_equals(
      act = value->get_value_raw( )
      exp = cl_abap_codepage=>convert_to( 'A' ) ).
    node = reader->read_next_node( ).
    close ?= node.
    cl_abap_unit_assert=>assert_equals(
      act = close->qname-name
      exp = 'a' ).
    cl_abap_unit_assert=>assert_equals(
      act = close->qname-namespace
      exp = 'urn:p' ).
  ENDMETHOD.

  METHOD concrete_nodes.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA node TYPE REF TO if_sxml_node.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to(
      '<?xml version="1.0"?><c><?task run?>text</c>' ) ).
    node = reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_classdescr=>get_class_name( node )
      exp = '\CLASS=CL_SXML_OPEN_ELEMENT' ).
    node = reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_classdescr=>get_class_name( node )
      exp = '\CLASS=CL_SXML_VALUE' ).
    node = reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_classdescr=>get_class_name( node )
      exp = '\CLASS=CL_SXML_CLOSE_ELEMENT' ).
    node = reader->read_next_node( ).
    cl_abap_unit_assert=>assert_initial( node ).

    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<c></c>' ) ).
    node = reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_classdescr=>get_class_name( node )
      exp = '\CLASS=CL_SXML_OPEN_ELEMENT' ).
    node = reader->read_next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_classdescr=>get_class_name( node )
      exp = '\CLASS=CL_SXML_CLOSE_ELEMENT' ).
    node = reader->read_next_node( ).
    cl_abap_unit_assert=>assert_initial( node ).
  ENDMETHOD.

  METHOD tokens.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA node TYPE REF TO if_sxml_node.
    DATA value TYPE REF TO if_sxml_value_node.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to(
      '<?xml version="1.0"?><!--c--><a x="&amp;">t&amp;<![CDATA[<raw>&]]><b/></a><ignored/>' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->name
      exp = 'a' ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->value
      exp = '&' ).
    node = reader->read_next_node( ).
    value ?= node.
    cl_abap_unit_assert=>assert_equals(
      act = value->get_value( )
      exp = 't&' ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->value
      exp = '<raw>&' ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->name
      exp = 'b' ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->node_type
      exp = if_sxml_node=>co_nt_element_close ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->node_type
      exp = if_sxml_node=>co_nt_final ).
  ENDMETHOD.

  METHOD namespaces.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA node TYPE REF TO if_sxml_node.
    DATA open TYPE REF TO if_sxml_open_element.
    DATA attr TYPE REF TO if_sxml_attribute.
    DATA attrs TYPE if_sxml_attribute=>attributes.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to(
      '<a xmlns="urn:a" xmlns:n="urn:n"><n:b n:z="&#65;&#x42;">  </n:b></a>' ) ).
    node = reader->read_next_node( ).
    open ?= node.
    cl_abap_unit_assert=>assert_equals(
      act = open->qname-namespace
      exp = 'urn:a' ).
    node = reader->read_next_node( ).
    open ?= node.
    attrs = open->get_attributes( ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( attrs )
      exp = 1 ).
    READ TABLE attrs INDEX 1 INTO attr.
    cl_abap_unit_assert=>assert_equals(
      act = attr->get_value( )
      exp = 'AB' ).
    cl_abap_unit_assert=>assert_equals(
      act = attr->qname-namespace
      exp = 'urn:n' ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->prefix
      exp = 'n' ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->nsuri
      exp = 'urn:n' ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->name
      exp = 'z' ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->prefix
      exp = 'n' ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->nsuri
      exp = 'urn:n' ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->value
      exp = 'AB' ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = strlen( reader->value )
      exp = 2 ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->nsuri
      exp = 'urn:n' ).
    cl_abap_unit_assert=>assert_equals(
      act = strlen( reader->value )
      exp = 2 ).
  ENDMETHOD.

  METHOD errors.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA error TYPE REF TO cx_sxml_parse_error.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a><b></a>' ) ).
    reader->next_node( ).
    reader->next_node( ).
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals(
          act = error->error_text
          exp = 'document not wellformed' ).
        cl_abap_unit_assert=>assert_equals(
          act = error->get_text( )
          exp = 'Error while parsing an XML stream: document not wellformed.' ).
    ENDTRY.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a>&bad;</a>' ) ).
    reader->next_node( ).
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals(
          act = error->error_text
          exp = 'unresolveable entity reference in content' ).
    ENDTRY.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a x=bad/>' ) ).
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals(
          act = error->error_text
          exp = 'opening ''"'' or '''''' expected' ).
    ENDTRY.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a>' ) ).
    reader->next_node( ).
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals(
          act = error->error_text
          exp = '<EOF> reached' ).
    ENDTRY.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '' ) ).
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals(
          act = error->error_text
          exp = 'BOM / charset detection failed' ).
    ENDTRY.
  ENDMETHOD.

  METHOD whitespace.
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a><b/>  <c/></a>' ) ).
    reader->next_node( ).
    reader->next_node( ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->name
      exp = 'c' ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->node_type
      exp = if_sxml_node=>co_nt_element_open ).
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a><b/>  </a>' ) ).
    reader->next_node( ).
    reader->next_node( ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->node_type
      exp = if_sxml_node=>co_nt_element_close ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->name
      exp = 'a' ).
  ENDMETHOD.

  METHOD nested_namespaces.
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to(
      '<r xmlns:n="urn:outer"><n:a xmlns:n="urn:inner" x=''v''/><n:b/></r>' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->nsuri
      exp = 'urn:inner' ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->name
      exp = 'x' ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->nsuri
      exp = '' ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->nsuri
      exp = 'urn:outer' ).
  ENDMETHOD.

  METHOD skip.
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( '<a><b><c/></b><d/></a>' ) ).
    reader->next_node( ).
    reader->next_node( ).
    reader->skip_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->name
      exp = 'b' ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->node_type
      exp = if_sxml_node=>co_nt_element_close ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->name
      exp = 'd' ).
  ENDMETHOD.

  METHOD scale.
    DATA xml TYPE string.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA count TYPE i.
    xml = '<a>'.
    DO 2000 TIMES.
      xml = xml && '<b>12345678</b>'.
    ENDDO.
    xml = xml && '</a>'.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( xml ) ).
    DO.
      reader->next_node( ).
      IF reader->node_type = if_sxml_node=>co_nt_final.
        EXIT.
      ENDIF.
      count = count + 1.
    ENDDO.
    cl_abap_unit_assert=>assert_equals(
      act = count
      exp = 6002 ).
  ENDMETHOD.

  METHOD scale10.
    DATA xml TYPE string.
    DATA reader TYPE REF TO if_sxml_reader.
    xml = '<r>' && repeat( val = 'a'
                           occ = 65536 ) && '</r>'.
    reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( xml ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = strlen( reader->value )
      exp = 65536 ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals(
      act = reader->node_type
      exp = if_sxml_node=>co_nt_element_close ).
  ENDMETHOD.
ENDCLASS.

* A UTF-8 document with characters outside ASCII, given in hex so the source
* stays ASCII: e acute C3A9, euro E282AC, U+1F600 F09F9880. Expected values
* and offsets measured on a system: offsets count bytes.
CLASS ltcl_xml_utf8 DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS text IMPORTING hex TYPE xstring RETURNING VALUE(text) TYPE string.
    METHODS everywhere FOR TESTING RAISING cx_static_check.
    METHODS entity_and_four_bytes FOR TESTING RAISING cx_static_check.
    METHODS lower_case_declaration FOR TESTING RAISING cx_static_check.
    METHODS close_offset_in_bytes FOR TESTING RAISING cx_static_check.
    METHODS attribute_lt_offset FOR TESTING RAISING cx_static_check.
    METHODS invalid_bytes FOR TESTING RAISING cx_static_check.
    METHODS cut_sequence FOR TESTING RAISING cx_static_check.
    METHODS value_of IMPORTING xml TYPE xstring RETURNING VALUE(value) TYPE string
      RAISING cx_sxml_parse_error.
ENDCLASS.

CLASS ltcl_xml_utf8 IMPLEMENTATION.
  METHOD text.
    text = cl_abap_codepage=>convert_from( hex ).
  ENDMETHOD.

  METHOD everywhere.
    " <a(e) x(e)="(e)(euro)"><b>(e)(euro)</b><c><![CDATA[(e)]]]]></c><!--(e)--></a(e)>
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( CONV xstring(
      '3C61C3A92078C3A93D22C3A9E282AC223E3C623EC3A9E282AC3C2F623E3C633E3C215B43444154415BC3A95D5D5D5D3E3C2F633E3C212D2DC3A92D2D3E3C2F61C3A93E' ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = text( '61C3A9' ) ).
    reader->next_attribute( ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = text( '78C3A9' ) ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = text( 'C3A9E282AC' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = text( 'C3A9E282AC' ) ).
    reader->next_node( ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = text( 'C3A95D5D' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->node_type
                                        exp = if_sxml_node=>co_nt_element_close ).
    cl_abap_unit_assert=>assert_equals( act = reader->name
                                        exp = text( '61C3A9' ) ).
  ENDMETHOD.

  METHOD entity_and_four_bytes.
    " <a>(e)&amp;(U+1F600)</a>
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( CONV xstring( '3C613EC3A926616D703BF09F98803C2F613E' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = text( 'C3A926F09F9880' ) ).
  ENDMETHOD.

  METHOD lower_case_declaration.
    " <?xml version="1.0" encoding="utf-8"?><a>(U+1F600)</a>
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( CONV xstring(
      '3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574662D38223F3E3C613EF09F98803C2F613E' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = text( 'F09F9880' ) ).
  ENDMETHOD.

  METHOD close_offset_in_bytes.
    " <a>(e)(euro)</b>: the value, then the close tag that does not match,
    " reported at the byte where it starts
    DATA reader TYPE REF TO if_sxml_reader.
    DATA error TYPE REF TO cx_sxml_parse_error.
    reader = cl_sxml_string_reader=>create( CONV xstring( '3C613EC3A9E282AC3C2F623E' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = text( 'C3A9E282AC' ) ).
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals( act = error->xml_offset
                                            exp = 8 ).
        cl_abap_unit_assert=>assert_equals( act = error->error_text
                                            exp = 'document not wellformed' ).
    ENDTRY.
  ENDMETHOD.

  METHOD attribute_lt_offset.
    " <a x="(e)(e)<"/>: reported at the start of the value
    DATA reader TYPE REF TO if_sxml_reader.
    DATA error TYPE REF TO cx_sxml_parse_error.
    reader = cl_sxml_string_reader=>create( CONV xstring( '3C6120783D22C3A9C3A93C222F3E' ) ).
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals( act = error->xml_offset
                                            exp = 6 ).
    ENDTRY.
  ENDMETHOD.

  METHOD invalid_bytes.
    " <a>FF</a>: not an error, the byte reads as U+FFFD; in a comment it is
    " not read at all (measured on a system, also the cases below)
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( CONV xstring( '3C613EFF3C2F613E' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->value
                                        exp = cl_abap_conv_in_ce=>uccpi( 65533 ) ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->node_type
                                        exp = if_sxml_node=>co_nt_element_close ).
    reader = cl_sxml_string_reader=>create( CONV xstring( '3C613E3C212D2DFF2D2D3E3C2F613E' ) ).
    reader->next_node( ).
    reader->next_node( ).
    cl_abap_unit_assert=>assert_equals( act = reader->node_type
                                        exp = if_sxml_node=>co_nt_element_close ).
    " a lone continuation byte: one U+FFFD; the overlong C0 AF: one; a lead
    " byte and one continuation before more text: two
    cl_abap_unit_assert=>assert_equals( act = value_of( '3C613E80613C2F613E' )
                                        exp = cl_abap_conv_in_ce=>uccpi( 65533 ) && 'a' ).
    cl_abap_unit_assert=>assert_equals( act = value_of( '3C613EC0AF613C2F613E' )
                                        exp = cl_abap_conv_in_ce=>uccpi( 65533 ) && 'a' ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( '3C613EE282613C2F613E' )
      exp = cl_abap_conv_in_ce=>uccpi( 65533 ) && cl_abap_conv_in_ce=>uccpi( 65533 ) && 'a' ).
  ENDMETHOD.

  METHOD value_of.
    DATA reader TYPE REF TO if_sxml_reader.
    reader = cl_sxml_string_reader=>create( xml ).
    reader->next_node( ).
    reader->next_node( ).
    value = reader->value.
  ENDMETHOD.

  METHOD cut_sequence.
    " a sequence cut off by the markup after it: an error at that markup
    DATA reader TYPE REF TO if_sxml_reader.
    DATA error TYPE REF TO cx_sxml_parse_error.
    reader = cl_sxml_string_reader=>create( CONV xstring( '3C613EE2823C2F613E' ) ).
    reader->next_node( ).
    TRY.
        reader->next_node( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sxml_parse_error INTO error.
        cl_abap_unit_assert=>assert_equals( act = error->xml_offset
                                            exp = 5 ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
