INTERFACE if_ixml_parse_error PUBLIC.

  CONSTANTS co_info TYPE i VALUE 1.
  CONSTANTS co_error TYPE i VALUE 3.

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