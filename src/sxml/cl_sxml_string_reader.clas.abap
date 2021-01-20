CLASS cl_sxml_string_reader DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING data TYPE xstring
      RETURNING VALUE(reader) TYPE REF TO if_sxml_reader.
ENDCLASS.

CLASS cl_sxml_string_reader IMPLEMENTATION.
  METHOD create.

    DATA lo_json TYPE REF TO lcl_json_parser.
    DATA lt_parsed TYPE lcl_json_parser=>ty_nodes.
    DATA ls_parsed LIKE LINE OF lt_parsed.
    DATA li_node TYPE REF TO if_sxml_node.
    DATA lt_nodes TYPE lcl_reader=>ty_nodes.

    CREATE OBJECT lo_json.
    lt_parsed = lo_json->parse( cl_abap_codepage=>convert_from( data ) ).

    LOOP AT lt_parsed INTO ls_parsed.
      CREATE OBJECT li_node TYPE lcl_node
        EXPORTING
          iv_type = ls_parsed-type.
      APPEND li_node TO lt_nodes.
    ENDLOOP.

    CREATE OBJECT reader TYPE lcl_reader
      EXPORTING
        it_nodes = lt_nodes.

  ENDMETHOD.
ENDCLASS.