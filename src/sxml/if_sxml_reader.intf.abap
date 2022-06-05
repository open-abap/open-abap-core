INTERFACE if_sxml_reader PUBLIC.
  DATA node_type TYPE if_sxml_node=>node_type READ-ONLY.
  DATA name TYPE string READ-ONLY.

  METHODS
    read_next_node
      RETURNING VALUE(node) TYPE REF TO if_sxml_node.

  METHODS
    next_node
      IMPORTING
        value_type TYPE if_sxml_value=>value_type DEFAULT if_sxml_value=>co_vt_text
      RAISING
        cx_sxml_parse_error.

  METHODS
    skip_node
      IMPORTING
        writer TYPE REF TO if_sxml_writer OPTIONAL
      RAISING
        cx_sxml_parse_error.
ENDINTERFACE.