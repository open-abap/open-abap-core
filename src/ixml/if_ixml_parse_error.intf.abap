INTERFACE if_ixml_parse_error PUBLIC.
  METHODS get_reason
    RETURNING
      VALUE(reason) TYPE string.
  METHODS get_line
    RETURNING
      VALUE(line) TYPE i.
  METHODS get_column
    RETURNING
      VALUE(column) TYPE i.
ENDINTERFACE.