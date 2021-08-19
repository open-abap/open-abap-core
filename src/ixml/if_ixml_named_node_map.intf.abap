INTERFACE if_ixml_named_node_map PUBLIC.
  METHODS:
    create_iterator
      RETURNING VALUE(iterator) TYPE REF TO if_ixml_node_iterator,
    get_length
      RETURNING VALUE(val) TYPE i,
    get_named_item_ns
      IMPORTING name TYPE string
      RETURNING VALUE(val) TYPE REF TO if_ixml_node,
    get_named_item
      IMPORTING name TYPE string
      RETURNING VALUE(val) TYPE REF TO if_ixml_node,
    set_named_item_ns
      IMPORTING node TYPE REF TO if_ixml_node,
    remove_named_item
      IMPORTING name TYPE string.
ENDINTERFACE.