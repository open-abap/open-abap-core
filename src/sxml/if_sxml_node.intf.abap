INTERFACE if_sxml_node PUBLIC.
  TYPES node_type TYPE i.
  DATA type TYPE node_type.
  CONSTANTS co_nt_element_open TYPE node_type VALUE 1.
  CONSTANTS co_nt_element_close TYPE node_type VALUE 2.
  CONSTANTS co_nt_value TYPE node_type VALUE 4.
ENDINTERFACE.