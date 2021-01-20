CLASS cl_sxml_string_reader DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING data TYPE xstring
      RETURNING VALUE(reader) TYPE REF TO if_sxml_reader.
ENDCLASS.

CLASS cl_sxml_string_reader IMPLEMENTATION.
  METHOD create.

    DATA lo_json TYPE REF TO lcl_json_parser.
    CREATE OBJECT lo_json.
    lo_json->parse( cl_abap_codepage=>convert_from( data ) ).

********************************

    DATA lt_nodes TYPE lcl_reader=>ty_nodes.
    DATA li_node1 TYPE REF TO if_sxml_node.
    DATA li_node2 TYPE REF TO if_sxml_node.

    CREATE OBJECT li_node1 TYPE lcl_node
      EXPORTING
        iv_type = if_sxml_node=>co_nt_element_open.
    APPEND li_node1 TO lt_nodes.

    CREATE OBJECT li_node2 TYPE lcl_node
      EXPORTING
        iv_type = if_sxml_node=>co_nt_element_close.
    APPEND li_node2 TO lt_nodes.

    CREATE OBJECT reader TYPE lcl_reader
      EXPORTING
        it_nodes = lt_nodes.
  ENDMETHOD.
ENDCLASS.