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
ENDINTERFACE.