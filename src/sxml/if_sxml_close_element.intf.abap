INTERFACE if_sxml_close_element PUBLIC.
  INTERFACES if_sxml_node.

  DATA: BEGIN OF qname,
          name      TYPE string,
          namespace TYPE string,
        END OF qname.
ENDINTERFACE.