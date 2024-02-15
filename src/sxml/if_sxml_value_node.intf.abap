INTERFACE if_sxml_value_node PUBLIC.
  INTERFACES if_sxml_node.

  METHODS get_value
    RETURNING
      VALUE(value) TYPE string.

  METHODS get_value_raw
    RETURNING
      VALUE(value) TYPE xstring.

  METHODS set_value
    IMPORTING
      value TYPE string.

  METHODS set_value_raw
    IMPORTING
      value TYPE xstring.

ENDINTERFACE.