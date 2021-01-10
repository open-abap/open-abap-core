INTERFACE if_sxml_reader PUBLIC.
  METHODS:
    read_next_node RETURNING VALUE(node) TYPE REF TO if_sxml_node.
ENDINTERFACE.