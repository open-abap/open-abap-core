INTERFACE if_sxml_open_element PUBLIC.
  INTERFACES if_sxml_node.

  DATA: BEGIN OF qname,
          name      TYPE string,
          namespace TYPE string,
        END OF qname.

  DATA prefix TYPE string READ-ONLY.

  METHODS get_attributes
    RETURNING
      VALUE(attr) TYPE if_sxml_attribute=>attributes.

  METHODS set_attribute
    IMPORTING
      name             TYPE string
      nsuri            TYPE string OPTIONAL
      prefix           TYPE string OPTIONAL
      value            TYPE string OPTIONAL
    RETURNING
      VALUE(attribute) TYPE REF TO if_sxml_attribute
    RAISING
      cx_sxml_name_error.

  METHODS set_attributes
    IMPORTING
      attributes TYPE if_sxml_attribute=>attributes
    RAISING
      cx_sxml_name_error.

  METHODS set_prefix
    IMPORTING
      prefix TYPE string OPTIONAL.

  METHODS get_attribute_value
    IMPORTING
      !name        TYPE string
      !nsuri       TYPE string OPTIONAL
    RETURNING
      VALUE(value) TYPE REF TO if_sxml_value.
ENDINTERFACE.