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

* todo, for now this only hanles json, but the class is really meant for XML
    CREATE OBJECT lo_json.
    lt_parsed = lo_json->parse( cl_abap_codepage=>convert_from( data ) ).

    LOOP AT lt_parsed INTO ls_parsed.
      CASE ls_parsed-type.
        WHEN if_sxml_node=>co_nt_element_open.
          CREATE OBJECT li_node TYPE lcl_open_node
            EXPORTING
              name = ls_parsed-name.
        WHEN if_sxml_node=>co_nt_element_close.
          CREATE OBJECT li_node TYPE lcl_close_node
            EXPORTING
              name = ls_parsed-name.
        WHEN if_sxml_node=>co_nt_value.
          CREATE OBJECT li_node TYPE lcl_value_node.
        WHEN OTHERS.
          ASSERT 1 = 2.
      ENDCASE.
      APPEND li_node TO lt_nodes.
    ENDLOOP.

    CREATE OBJECT reader TYPE lcl_reader
      EXPORTING
        it_nodes = lt_nodes.

  ENDMETHOD.
ENDCLASS.