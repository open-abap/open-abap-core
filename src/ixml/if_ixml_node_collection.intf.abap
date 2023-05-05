INTERFACE if_ixml_node_collection PUBLIC.
  METHODS create_iterator
    RETURNING
      VALUE(rval) TYPE REF TO if_ixml_node_iterator.
ENDINTERFACE.