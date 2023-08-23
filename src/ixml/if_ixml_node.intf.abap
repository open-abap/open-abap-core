INTERFACE if_ixml_node PUBLIC.
  CONSTANTS:
    co_node_element  TYPE i VALUE 4,
    co_node_text     TYPE i VALUE 16,
    co_node_document TYPE i VALUE 1.

  METHODS:
    append_child IMPORTING new_child TYPE REF TO if_ixml_node,
    get_attributes RETURNING VALUE(map) TYPE REF TO if_ixml_named_node_map,
    get_first_child RETURNING VALUE(node) TYPE REF TO if_ixml_node,
    get_children RETURNING VALUE(val) TYPE REF TO if_ixml_node_list,
    query_interface
      IMPORTING foo         TYPE string
      RETURNING VALUE(rval) TYPE REF TO if_ixml_unknown,
    remove_node,
    get_parent RETURNING VALUE(val) TYPE REF TO if_ixml_node,
    replace_child IMPORTING
      new_child TYPE string
      old_child TYPE string,
    get_name RETURNING VALUE(val) TYPE string,
    get_depth RETURNING VALUE(val) TYPE i,
    is_leaf RETURNING VALUE(val) TYPE abap_bool,
    get_namespace RETURNING VALUE(val) TYPE string,
    get_value RETURNING VALUE(val) TYPE string,
    get_type RETURNING VALUE(val) TYPE string,
    set_name IMPORTING name TYPE string,
    set_namespace_prefix IMPORTING val TYPE string,
    remove_child IMPORTING child TYPE REF TO if_ixml_node,
    set_value IMPORTING value TYPE string.

  METHODS get_next
    RETURNING
      VALUE(rval) TYPE REF TO if_ixml_node.

  METHODS get_namespace_prefix
    RETURNING
      VALUE(rv_prefix) TYPE string.

  METHODS get_namespace_uri
    RETURNING
      VALUE(rval) TYPE string.

  METHODS get_height
    RETURNING
      VALUE(rval) TYPE i.

  METHODS create_filter_name_ns
    IMPORTING
      name        TYPE string
      namespace   TYPE string OPTIONAL
    RETURNING
      VALUE(rval) TYPE REF TO if_ixml_node_filter.

  METHODS get_column
    RETURNING
      VALUE(rval) TYPE i.
ENDINTERFACE.