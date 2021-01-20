CLASS cl_sxml_string_reader DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING data TYPE xstring
      RETURNING VALUE(reader) TYPE REF TO if_sxml_reader.
ENDCLASS.

CLASS cl_sxml_string_reader IMPLEMENTATION.
  METHOD create.

************* WIP *******************

    DATA lo_json TYPE REF TO lcl_json_parser.
    DATA lt_nodes TYPE lcl_json_parser=>ty_nodes.
    DATA li_node TYPE REF TO if_sxml_node.
    DATA ls_node LIKE LINE OF lt_nodes.

    CREATE OBJECT lo_json.
    lt_nodes = lo_json->parse( cl_abap_codepage=>convert_from( data ) ).

    LOOP AT lt_nodes INTO ls_node.
      WRITE / ls_node-type.
      CREATE OBJECT li_node TYPE lcl_node
        EXPORTING
          iv_type = ls_node-type.
      APPEND li_node TO lt_nodes.
    ENDLOOP.

************* DUMMY IMPLEMENTATION *******************
    " DATA lt_nodes TYPE lcl_reader=>ty_nodes.
    " DATA li_node1 TYPE REF TO if_sxml_node.
    " DATA li_node2 TYPE REF TO if_sxml_node.

    " CREATE OBJECT li_node1 TYPE lcl_node
    "   EXPORTING
    "     iv_type = if_sxml_node=>co_nt_element_open.
    " APPEND li_node1 TO lt_nodes.

    " CREATE OBJECT li_node2 TYPE lcl_node
    "   EXPORTING
    "     iv_type = if_sxml_node=>co_nt_element_close.
    " APPEND li_node2 TO lt_nodes.

    " CREATE OBJECT reader TYPE lcl_reader
    "   EXPORTING
    "     it_nodes = lt_nodes.

  ENDMETHOD.
ENDCLASS.