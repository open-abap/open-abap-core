INTERFACE if_sxml_attribute PUBLIC.
  TYPES attributes TYPE STANDARD TABLE OF REF TO if_sxml_attribute WITH DEFAULT KEY.
  DATA: BEGIN OF qname,
          name TYPE string,
        END OF qname.
  DATA value_type TYPE if_sxml_value=>value_type.
  METHODS get_value RETURNING VALUE(value) TYPE string.
ENDINTERFACE.