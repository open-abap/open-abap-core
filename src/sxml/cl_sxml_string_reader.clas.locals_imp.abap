* JSON specification, https://www.ecma-international.org/publications-and-standards/standards/ecma-404/

CLASS lcl_json_parser DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_node,
            path TYPE string,
            name TYPE string,
            type TYPE string,
            value TYPE string,
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
        iv_path TYPE string
        iv_name TYPE string
        iv_type TYPE string
        iv_value TYPE string.

    METHODS traverse IMPORTING iv_json TYPE string.
    METHODS traverse_object IMPORTING iv_json TYPE string.
    METHODS traverse_basic IMPORTING iv_json TYPE string.
    METHODS traverse_array IMPORTING iv_json TYPE string.

ENDCLASS.

CLASS lcl_json_parser IMPLEMENTATION.

  METHOD parse.
    CLEAR mt_nodes.
    traverse( iv_json ).
    rt_nodes = mt_nodes.
  ENDMETHOD.

  METHOD append.
    DATA ls_node LIKE LINE OF mt_nodes.
    ls_node-path = iv_path.
    ls_node-name = iv_name.
    ls_node-type = iv_type.
    ls_node-value = iv_value.
    APPEND ls_node TO mt_nodes.
  ENDMETHOD.

  METHOD traverse.

    DATA lv_type TYPE string.

* todo, catch parser errors
    WRITE '@KERNEL let parsed = JSON.parse(iv_json.get());'.
    WRITE '@KERNEL lv_type.set(Array.isArray(parsed) ? "array" : typeof parsed);'.

    CASE lv_type.
      WHEN 'object'.
        traverse_object( iv_json ).
      WHEN 'array'.
        traverse_array( iv_json ).
      WHEN 'string' OR 'boolean' OR 'number'.
        traverse_basic( iv_json ).
      WHEN OTHERS.
        ASSERT 2 = 'todo'.
    ENDCASE.

  ENDMETHOD.

  METHOD traverse_basic.
  ENDMETHOD.

  METHOD traverse_array.
  ENDMETHOD.

  METHOD traverse_object.

    DATA lt_keys TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lv_key LIKE LINE OF lt_keys.
    DATA lv_value TYPE string.

    WRITE '@KERNEL let parsed = JSON.parse(iv_json.get());'.
    WRITE '@KERNEL Object.keys(parsed).forEach(k => lt_keys.append(k));'.

    LOOP AT lt_keys INTO lv_key.
      WRITE '@KERNEL lv_value.set(JSON.stringify(parsed[lv_key.get()]));'.
      traverse( lv_value ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_node DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_type TYPE if_sxml_node=>node_type.
    INTERFACES if_sxml_node.
ENDCLASS.

CLASS lcl_node IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = iv_type.
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