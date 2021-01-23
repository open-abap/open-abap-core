INTERFACE if_ixml_parser PUBLIC.
  METHODS parse RETURNING VALUE(subrc) TYPE i.
  METHODS set_normalizing IMPORTING normal TYPE abap_bool.
  METHODS num_errors RETURNING VALUE(errors) TYPE i.
  METHODS add_strip_space_element.
ENDINTERFACE.