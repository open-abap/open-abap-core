INTERFACE if_ixml_encoding PUBLIC.
  CONSTANTS co_none            TYPE i VALUE 0.
  CONSTANTS co_big_endian      TYPE i VALUE 1.
  CONSTANTS co_platform_endian TYPE i VALUE 4.

  METHODS get_byte_order
    RETURNING
      VALUE(rval) TYPE i.

  METHODS get_character_set
    RETURNING
      VALUE(rval) TYPE string.
ENDINTERFACE.