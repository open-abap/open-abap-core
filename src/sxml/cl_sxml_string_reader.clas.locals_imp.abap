* JSON specification, https://www.ecma-international.org/publications-and-standards/standards/ecma-404/

CLASS lcl_json_parser DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_node,
             type TYPE if_sxml_node=>node_type,
             name TYPE string,
             key TYPE string,
           END OF ty_node.

    TYPES ty_nodes TYPE STANDARD TABLE OF ty_node WITH DEFAULT KEY.

    METHODS
      parse
        IMPORTING iv_json TYPE string
        RETURNING VALUE(rt_nodes) TYPE ty_nodes.

  PRIVATE SECTION.
    DATA mt_nodes TYPE ty_nodes.

    METHODS append
      IMPORTING
        iv_type TYPE if_sxml_node=>node_type
        iv_name TYPE string OPTIONAL
        iv_key TYPE string OPTIONAL.

    METHODS traverse
      IMPORTING
        iv_json TYPE string
        iv_key TYPE string OPTIONAL.
    METHODS traverse_object
      IMPORTING
        iv_json TYPE string
        iv_key TYPE string OPTIONAL.
    METHODS traverse_basic
      IMPORTING
        iv_json TYPE string
        iv_key TYPE string OPTIONAL.
    METHODS traverse_array
      IMPORTING
        iv_json TYPE string
        iv_key TYPE string OPTIONAL.

ENDCLASS.

CLASS lcl_json_parser IMPLEMENTATION.

  METHOD parse.
    CLEAR mt_nodes.
    traverse( iv_json ).
    rt_nodes = mt_nodes.
  ENDMETHOD.

  METHOD append.
    DATA ls_node LIKE LINE OF mt_nodes.
    ls_node-type = iv_type.
    ls_node-name = iv_name.
    ls_node-key = iv_key.
    APPEND ls_node TO mt_nodes.
  ENDMETHOD.

  METHOD traverse.

    DATA lv_type TYPE string.

* todo, catch parser errors
    WRITE '@KERNEL let parsed = JSON.parse(iv_json.get());'.
    WRITE '@KERNEL lv_type.set(Array.isArray(parsed) ? "array" : typeof parsed);'.
    WRITE '@KERNEL if (parsed === null) lv_type.set("null");'.

    CASE lv_type.
      WHEN 'object'.
        traverse_object( iv_json = iv_json iv_key = iv_key ).
      WHEN 'array'.
        traverse_array( iv_json = iv_json iv_key = iv_key ).
      WHEN 'string' OR 'boolean' OR 'number' OR 'null'.
        traverse_basic( iv_json = iv_json iv_key = iv_key ).
      WHEN OTHERS.
        ASSERT 2 = 'todo'.
    ENDCASE.

  ENDMETHOD.

  METHOD traverse_basic.

    DATA lv_type TYPE string.
    WRITE '@KERNEL let parsed = JSON.parse(iv_json.get());'.
    WRITE '@KERNEL lv_type.set(typeof parsed);'.
    WRITE '@KERNEL if (parsed === null) lv_type.set("null");'.
    CASE lv_type.
      WHEN 'string'.
        lv_type = 'str'.
      WHEN 'number'.
        lv_type = 'num'.
      WHEN 'boolean'.
        lv_type = 'bool'.
    ENDCASE.

    append( iv_type = if_sxml_node=>co_nt_element_open
            iv_name = lv_type
            iv_key  = iv_key ).
    IF lv_type <> 'null'.
      append( iv_type = if_sxml_node=>co_nt_value ).
    ENDIF.
    append( iv_type = if_sxml_node=>co_nt_element_close
            iv_name = lv_type ).

  ENDMETHOD.

  METHOD traverse_array.

    DATA lv_value TYPE string.
    DATA lv_length TYPE i.
    DATA lv_index TYPE i.

    WRITE '@KERNEL let parsed = JSON.parse(iv_json.get());'.
    WRITE '@KERNEL lv_length.set(parsed.length);'.

    append( iv_type = if_sxml_node=>co_nt_element_open
            iv_name = 'array'
            iv_key  = iv_key ).

    DO lv_length TIMES.
      lv_index = sy-index - 1.
      WRITE '@KERNEL lv_value.set(JSON.stringify(parsed[lv_index.get()]));'.
      traverse( lv_value ).
    ENDDO.

    append( iv_type = if_sxml_node=>co_nt_element_close
            iv_name = 'array' ).

  ENDMETHOD.

  METHOD traverse_object.

    DATA lt_keys TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lv_key LIKE LINE OF lt_keys.
    DATA lv_value TYPE string.

    WRITE '@KERNEL let parsed = JSON.parse(iv_json.get());'.
    WRITE '@KERNEL Object.keys(parsed).forEach(k => lt_keys.append(k));'.

    append( iv_type = if_sxml_node=>co_nt_element_open
            iv_name = 'object'
            iv_key  = iv_key ).

    LOOP AT lt_keys INTO lv_key.
      WRITE '@KERNEL lv_value.set(JSON.stringify(parsed[lv_key.get()]));'.
      traverse( iv_json = lv_value
                iv_key  = lv_key ).
    ENDLOOP.

    append( iv_type = if_sxml_node=>co_nt_element_close
            iv_name = 'object' ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_attribute DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_attribute.

    METHODS constructor
      IMPORTING
        name TYPE string
        value TYPE string
        value_type TYPE if_sxml_value=>value_type.

  PRIVATE SECTION.
    DATA mv_value TYPE string.
    DATA mv_value_type TYPE i.
ENDCLASS.

CLASS lcl_attribute IMPLEMENTATION.
  METHOD constructor.
    if_sxml_attribute~qname-name = name.
    mv_value = value.
    mv_value_type = mv_value_type.
  ENDMETHOD.

  METHOD if_sxml_attribute~get_value.
    value = mv_value.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_open_node DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_open_element.
    METHODS constructor
      IMPORTING
        name TYPE string
        attributes TYPE if_sxml_attribute=>attributes.
  PRIVATE SECTION.
    DATA mt_attributes TYPE if_sxml_attribute=>attributes.
ENDCLASS.

CLASS lcl_open_node IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_element_open.
    if_sxml_open_element~qname-name = name.
    mt_attributes = attributes.
  ENDMETHOD.

  METHOD if_sxml_open_element~get_attributes.
    attr = mt_attributes.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_close_node DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_close_element.
    METHODS constructor
      IMPORTING name TYPE string.
ENDCLASS.

CLASS lcl_close_node IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_element_close.
    if_sxml_close_element~qname-name = name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_value_node DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_value_node.
    METHODS constructor.
ENDCLASS.

CLASS lcl_value_node IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_value.
  ENDMETHOD.

  METHOD if_sxml_value_node~get_value.
* todo
  ENDMETHOD.
ENDCLASS.

CLASS lcl_reader DEFINITION.
  PUBLIC SECTION.
    TYPES ty_nodes TYPE STANDARD TABLE OF REF TO if_sxml_node WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING
        it_nodes TYPE ty_nodes.
    INTERFACES if_sxml_reader.
  PRIVATE SECTION.
    DATA mt_nodes TYPE ty_nodes.
    DATA mv_pointer TYPE i.
ENDCLASS.

CLASS lcl_reader IMPLEMENTATION.
  METHOD constructor.
    mt_nodes = it_nodes.
    mv_pointer = 1.
  ENDMETHOD.

  METHOD if_sxml_reader~read_next_node.
    READ TABLE mt_nodes INDEX mv_pointer INTO node.
    mv_pointer = mv_pointer + 1.
  ENDMETHOD.
ENDCLASS.