INTERFACE if_ixml_parser PUBLIC.
  METHODS parse RETURNING VALUE(subrc) TYPE i.
  METHODS set_normalizing IMPORTING normal TYPE abap_bool.
  METHODS num_errors RETURNING VALUE(errors) TYPE i.
  METHODS add_strip_space_element.
  METHODS get_error
    IMPORTING
      index TYPE i
    RETURNING
      VALUE(error) TYPE REF TO if_ixml_parse_error.
ENDINTERFACE.