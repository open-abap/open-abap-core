INTERFACE if_sxml_open_element PUBLIC.
  INTERFACES if_sxml_node.

  DATA: BEGIN OF qname,
          name TYPE string,
        END OF qname.

  METHODS get_attributes
    RETURNING
      VALUE(attr) TYPE if_sxml_attribute=>attributes.

  METHODS set_attribute
    IMPORTING
      name   TYPE string
      nsuri  TYPE string OPTIONAL
      prefix TYPE string OPTIONAL
      value  TYPE string OPTIONAL
    RETURNING
      VALUE(attribute) TYPE REF TO if_sxml_attribute
    RAISING
      cx_sxml_name_error.
ENDINTERFACE.