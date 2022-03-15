INTERFACE if_sxml_writer PUBLIC.

  METHODS open_element
    IMPORTING
      name   TYPE string
      nsuri  TYPE string OPTIONAL
      prefix TYPE string OPTIONAL
    RAISING
      cx_sxml_state_error
      cx_sxml_name_error.

  METHODS close_element
    RAISING
      cx_sxml_state_error.

  METHODS write_attribute
    IMPORTING
      name   TYPE string
      nsuri  TYPE string OPTIONAL
      prefix TYPE string OPTIONAL
      value  TYPE string OPTIONAL
    RAISING
      cx_sxml_state_error
      cx_sxml_name_error.

  METHODS write_value
    IMPORTING
      value TYPE string
    RAISING
      cx_sxml_state_error.

  METHODS set_option
    IMPORTING
      option TYPE i
      value  TYPE abap_bool DEFAULT abap_true.

ENDINTERFACE.