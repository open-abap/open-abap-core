* JSON specification, https://www.ecma-international.org/publications-and-standards/standards/ecma-404/

CLASS lcl_json_parser DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_node,
             type  TYPE if_sxml_node=>node_type,
             name  TYPE string,
             key   TYPE string,
             value TYPE string,
           END OF ty_node.

    TYPES ty_nodes TYPE STANDARD TABLE OF ty_node WITH DEFAULT KEY.

    METHODS parse
      IMPORTING
        iv_json  TYPE string
        it_nodes TYPE REF TO ty_nodes.

  PRIVATE SECTION.
    DATA mt_nodes TYPE REF TO ty_nodes.

    METHODS append
      IMPORTING
        iv_type  TYPE if_sxml_node=>node_type
        iv_name  TYPE string OPTIONAL
        iv_key   TYPE string OPTIONAL
        iv_value TYPE string OPTIONAL.

    METHODS traverse
      IMPORTING
        iv_json TYPE any
        iv_key  TYPE string OPTIONAL.
    METHODS traverse_object
      IMPORTING
        iv_json TYPE any
        iv_key  TYPE string OPTIONAL.
    METHODS traverse_array
      IMPORTING
        iv_json TYPE any
        iv_key  TYPE string OPTIONAL.

ENDCLASS.

CLASS lcl_json_parser IMPLEMENTATION.

  METHOD parse.

    DATA lv_error         TYPE abap_bool.
    DATA lv_error_message TYPE string.
    DATA lv_xml_offset    TYPE i.
    DATA lv_json          TYPE i.

* Note: iv_json is an object to avoid problems with the ANY importing parameter

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   lv_json = {value: JSON.parse(iv_json.get())};'.
    WRITE '@KERNEL } catch(e) {'.
    WRITE '@KERNEL   lv_error_message.set(e.message);'.
    WRITE '@KERNEL   lv_error.set("X")'.
    WRITE '@KERNEL }'.
    IF lv_error = abap_true.
* NodeJS 16 will set the postion, but NodeJS 20 does not
      FIND REGEX ' position (\d+)' IN lv_error_message SUBMATCHES lv_xml_offset.
      RAISE EXCEPTION TYPE cx_sxml_parse_error
        EXPORTING
          xml_offset = lv_xml_offset.
    ENDIF.

    mt_nodes = it_nodes.
    CLEAR mt_nodes->*.
    traverse( lv_json ).
  ENDMETHOD.

  METHOD append.
    DATA ls_node LIKE LINE OF mt_nodes->*.
    ls_node-type = iv_type.
    ls_node-name = iv_name.
    ls_node-key = iv_key.
    ls_node-value = iv_value.
    APPEND ls_node TO mt_nodes->*.
  ENDMETHOD.

  METHOD traverse.

    DATA lv_type TYPE string.

    WRITE '@KERNEL lv_type.set(Array.isArray(iv_json.value) ? "array" : typeof iv_json.value);'.
    WRITE '@KERNEL if (iv_json.value === null) lv_type.set("null");'.

    CASE lv_type.
      WHEN 'object'.
        traverse_object( iv_json = iv_json iv_key = iv_key ).
      WHEN 'array'.
        traverse_array( iv_json = iv_json iv_key = iv_key ).
      WHEN 'string' OR 'boolean' OR 'number' OR 'null'.
        WRITE '@KERNEL iv_json = iv_json.value + "";'.

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
          append( iv_type  = if_sxml_node=>co_nt_value
                  iv_value = iv_json ).
        ENDIF.
        append( iv_type = if_sxml_node=>co_nt_element_close
                iv_name = lv_type ).
      WHEN OTHERS.
        ASSERT 2 = 'todo'.
    ENDCASE.

  ENDMETHOD.


  METHOD traverse_array.

    DATA lv_value  TYPE string.
    DATA lv_length TYPE i.
    DATA lv_index  TYPE i.

    WRITE '@KERNEL let parsed = iv_json.value;'.
    WRITE '@KERNEL lv_length.set(parsed.length);'.

    append( iv_type = if_sxml_node=>co_nt_element_open
            iv_name = 'array'
            iv_key  = iv_key ).

    DO lv_length TIMES.
      lv_index = sy-index - 1.
      WRITE '@KERNEL lv_value = {value: parsed[lv_index.get()]};'.
      traverse( lv_value ).
    ENDDO.

    append( iv_type = if_sxml_node=>co_nt_element_close
            iv_name = 'array' ).

  ENDMETHOD.

  METHOD traverse_object.

    DATA lv_key   TYPE string.
    DATA lv_value TYPE string.

    WRITE '@KERNEL let parsed = iv_json.value;'.

    append( iv_type = if_sxml_node=>co_nt_element_open
            iv_name = 'object'
            iv_key  = iv_key ).

    WRITE '@KERNEL for (const k of Object.keys(parsed)) {'.
    WRITE '@KERNEL   lv_key.set(k);'.
    WRITE '@KERNEL   lv_value = {value: parsed[k]};'.
    traverse( iv_json = lv_value
              iv_key  = lv_key ).
    WRITE '@KERNEL };'.

    append( iv_type = if_sxml_node=>co_nt_element_close
            iv_name = 'object' ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_attribute DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_attribute.

    METHODS constructor
      IMPORTING
        name       TYPE string
        value      TYPE string
        value_type TYPE if_sxml_value=>value_type.

  PRIVATE SECTION.
    DATA mv_value TYPE string.
ENDCLASS.

CLASS lcl_attribute IMPLEMENTATION.
  METHOD constructor.
    if_sxml_attribute~qname-name = name.
    if_sxml_attribute~value_type = value_type.
    mv_value = value.
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
        name       TYPE string
        attributes TYPE if_sxml_attribute=>attributes OPTIONAL.
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

  METHOD if_sxml_open_element~set_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_attributes.
    ASSERT 1 = 'todo'.
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
    METHODS constructor
      IMPORTING
        value TYPE string.
  PRIVATE SECTION.
    DATA mv_value TYPE string.
ENDCLASS.

CLASS lcl_value_node IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_value.
    mv_value = value.
  ENDMETHOD.

  METHOD if_sxml_value_node~get_value.
    val = mv_value.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_reader DEFINITION.
  PUBLIC SECTION.
    TYPES ty_nodes TYPE STANDARD TABLE OF REF TO if_sxml_node WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING
        iv_json TYPE string.
    INTERFACES if_sxml_reader.
  PRIVATE SECTION.
    METHODS initialize.
    DATA mv_json    TYPE string.
    DATA mt_nodes   TYPE ty_nodes.
    DATA mv_pointer TYPE i.
    DATA mv_initialized TYPE abap_bool.
ENDCLASS.

CLASS lcl_reader IMPLEMENTATION.
  METHOD if_sxml_reader~get_nsuri_by_prefix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~get_prefix_by_nsuri.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~get_nsbindings.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~get_path.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD constructor.
    mv_json = iv_json.
    mv_initialized = abap_false.
  ENDMETHOD.

  METHOD if_sxml_reader~set_option.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD initialize.

    DATA lo_json       TYPE REF TO lcl_json_parser.
    DATA lt_parsed     TYPE REF TO lcl_json_parser=>ty_nodes.
    DATA li_node       TYPE REF TO if_sxml_node.
    DATA lt_attributes TYPE if_sxml_attribute=>attributes.
    DATA li_attribute  TYPE REF TO if_sxml_attribute.

    FIELD-SYMBOLS <ls_parsed> TYPE lcl_json_parser=>ty_node.

    ASSERT mv_initialized = abap_false.
    mv_initialized = abap_true.

* todo: for now this only handles json, but the class is really meant for XML
    CREATE OBJECT lo_json.
    CREATE DATA lt_parsed.
    lo_json->parse(
      iv_json  = mv_json
      it_nodes = lt_parsed ).
    CLEAR lo_json. " release memory

    LOOP AT lt_parsed->* ASSIGNING <ls_parsed>.
      CASE <ls_parsed>-type.
        WHEN if_sxml_node=>co_nt_element_open.
          CLEAR lt_attributes.
          IF <ls_parsed>-key IS NOT INITIAL.
            CREATE OBJECT li_attribute TYPE lcl_attribute
              EXPORTING
                name       = 'name'
                value      = <ls_parsed>-key
                value_type = if_sxml_value=>co_vt_text.
            APPEND li_attribute TO lt_attributes.
          ENDIF.

          CREATE OBJECT li_node TYPE lcl_open_node
            EXPORTING
              name       = <ls_parsed>-name
              attributes = lt_attributes.
        WHEN if_sxml_node=>co_nt_element_close.
          CREATE OBJECT li_node TYPE lcl_close_node
            EXPORTING
              name = <ls_parsed>-name.
        WHEN if_sxml_node=>co_nt_value.
          CREATE OBJECT li_node TYPE lcl_value_node
            EXPORTING
              value = <ls_parsed>-value.
        WHEN OTHERS.
          ASSERT 1 = 2.
      ENDCASE.
      APPEND li_node TO mt_nodes.
    ENDLOOP.

    CLEAR mv_json.
    mv_pointer = 1.
  ENDMETHOD.

  METHOD if_sxml_reader~next_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~next_node.
    if_sxml_reader~read_next_node( ).
  ENDMETHOD.

  METHOD if_sxml_reader~skip_node.
* huh, what should this method do?
  ENDMETHOD.

  METHOD if_sxml_reader~read_next_node.
    DATA open  TYPE REF TO if_sxml_open_element.
    DATA close TYPE REF TO if_sxml_close_element.
    DATA value TYPE REF TO if_sxml_value_node.
    DATA attr  TYPE REF TO if_sxml_attribute.
    DATA attrs TYPE if_sxml_attribute=>attributes.

    IF mv_initialized = abap_false.
      initialize( ).
    ENDIF.
    READ TABLE mt_nodes INDEX mv_pointer INTO node.
    mv_pointer = mv_pointer + 1.

    IF node IS NOT INITIAL.
      if_sxml_reader~node_type = node->type.

      CASE if_sxml_reader~node_type.
        WHEN if_sxml_node=>co_nt_element_open.
          open ?= node.
          if_sxml_reader~name = open->qname-name.

          attrs = open->get_attributes( ).
          READ TABLE attrs INDEX 1 INTO attr.
          IF sy-subrc = 0.
            if_sxml_reader~value = attr->get_value( ).
          ENDIF.
        WHEN if_sxml_node=>co_nt_element_close.
          close ?= node.
          if_sxml_reader~name = close->qname-name.
          CLEAR if_sxml_reader~value.
        WHEN if_sxml_node=>co_nt_value.
          value ?= node.
          if_sxml_reader~value = value->get_value( ).
        WHEN OTHERS.
          CLEAR if_sxml_reader~name.
      ENDCASE.
    ENDIF.
  ENDMETHOD.
ENDCLASS.