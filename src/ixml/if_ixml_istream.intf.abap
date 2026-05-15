INTERFACE if_ixml_istream PUBLIC.
  CONSTANTS dtd_allowed    TYPE i VALUE 0.
  CONSTANTS dtd_restricted TYPE i VALUE 1.
  CONSTANTS dtd_prohibited TYPE i VALUE 2.

  INTERFACES if_ixml_stream.

  ALIASES get_encoding FOR if_ixml_stream~get_encoding.

  METHODS close.

  METHODS get_dtd_restriction
    RETURNING
      VALUE(rval) TYPE i.

  METHODS set_dtd_restriction
    IMPORTING
      level TYPE i DEFAULT dtd_restricted.
ENDINTERFACE.