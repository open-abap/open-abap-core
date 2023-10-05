INTERFACE if_ixml_ostream PUBLIC.
  METHODS write_string
    IMPORTING
      string      TYPE string
    RETURNING
      VALUE(rval) TYPE i.

  METHODS get_num_written_raw
    RETURNING
      VALUE(rval) TYPE i.

  METHODS set_encoding
    IMPORTING
      encoding    TYPE REF TO if_ixml_encoding
    RETURNING
      VALUE(rval) TYPE boolean.

  METHODS set_pretty_print
    IMPORTING
      pretty_print TYPE abap_bool DEFAULT abap_true.

  METHODS get_pretty_print
    RETURNING
      VALUE(rval) TYPE boolean.

  METHODS get_indent
    RETURNING
      VALUE(rval) TYPE i.

  METHODS set_indent
    IMPORTING
      indent TYPE i.
ENDINTERFACE.