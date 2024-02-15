INTERFACE if_sxml_value PUBLIC.

  TYPES value_type TYPE i.
  CONSTANTS co_vt_text TYPE value_type VALUE 2.

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