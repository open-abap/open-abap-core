INTERFACE if_sxml_writer PUBLIC.

  CONSTANTS co_opt_normalizing TYPE i VALUE 1.
  CONSTANTS co_opt_no_empty TYPE i VALUE 2.
  CONSTANTS co_opt_ignore_conv_errros TYPE i VALUE 3.
  CONSTANTS co_opt_linebreaks TYPE i VALUE 4.
  CONSTANTS co_opt_indent TYPE i VALUE 5.
  CONSTANTS co_opt_illegal_char_reject TYPE i VALUE 6.
  CONSTANTS co_opt_illegal_char_replace TYPE i VALUE 7.
  CONSTANTS co_opt_illegal_char_replace_by TYPE i VALUE 8.
  CONSTANTS co_opt_base64_no_lf TYPE i VALUE 9.

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