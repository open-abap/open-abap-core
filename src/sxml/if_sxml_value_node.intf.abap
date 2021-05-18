INTERFACE if_sxml_value_node PUBLIC.
  INTERFACES if_sxml_node.
  METHODS get_value RETURNING VALUE(val) TYPE string.
ENDINTERFACE.