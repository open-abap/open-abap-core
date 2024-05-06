INTERFACE if_sxml_reader PUBLIC.

  DATA node_type  TYPE if_sxml_node=>node_type READ-ONLY.
  DATA name       TYPE string READ-ONLY.
  DATA value_type TYPE if_sxml_value=>value_type READ-ONLY.
  DATA value      TYPE string READ-ONLY.
  DATA value_raw  TYPE xstring READ-ONLY.

  CONSTANTS co_opt_normalizing TYPE i VALUE 1.
  CONSTANTS co_opt_keep_whitespace TYPE i VALUE 2.
  CONSTANTS co_opt_asxml TYPE i VALUE 3.
  CONSTANTS co_opt_sep_member TYPE i VALUE 4.

  METHODS
    read_next_node
      RETURNING VALUE(node) TYPE REF TO if_sxml_node.

  METHODS next_node
    IMPORTING
      value_type TYPE if_sxml_value=>value_type DEFAULT if_sxml_value=>co_vt_text
    RAISING
      cx_sxml_parse_error.

  METHODS next_attribute
    IMPORTING
      value_type TYPE if_sxml_value=>value_type OPTIONAL.

  METHODS skip_node
    IMPORTING
      writer TYPE REF TO if_sxml_writer OPTIONAL
    RAISING
      cx_sxml_parse_error.

  METHODS set_option
    IMPORTING
      option TYPE i
      value  TYPE abap_bool DEFAULT abap_true.

  METHODS get_nsuri_by_prefix
    IMPORTING
      !prefix      TYPE string
    RETURNING
      VALUE(nsuri) TYPE string.

  METHODS get_prefix_by_nsuri
    IMPORTING
      !nsuri        TYPE string
    RETURNING
      VALUE(prefix) TYPE string.

  METHODS get_nsbindings
    RETURNING
      VALUE(nsbindings) TYPE if_sxml_named=>nsbindings.

  METHODS get_path
    RETURNING
      VALUE(path) TYPE if_sxml_named=>path.

  METHODS current_node.

  METHODS read_current_node
    RETURNING
      VALUE(node) TYPE REF TO if_sxml_node.

ENDINTERFACE.