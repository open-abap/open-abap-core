INTERFACE if_sxml_open_element PUBLIC.
  INTERFACES if_sxml_node.

  DATA: BEGIN OF qname,
          name TYPE string,
        END OF qname.

  METHODS get_attributes
    RETURNING
      VALUE(attr) TYPE if_sxml_attribute=>attributes.
ENDINTERFACE.