CLASS lcl_attribute DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_attribute.

    METHODS constructor
      IMPORTING
        name   TYPE string
        prefix TYPE string OPTIONAL
        nsuri  TYPE string OPTIONAL
        value  TYPE string OPTIONAL.

  PRIVATE SECTION.
    DATA mv_value TYPE string.
ENDCLASS.

CLASS lcl_attribute IMPLEMENTATION.
  METHOD constructor.
    if_sxml_attribute~qname-name = name.
    if_sxml_attribute~prefix = prefix.
    if_sxml_attribute~qname-namespace = nsuri.
    if_sxml_attribute~value_type = if_sxml_value=>co_vt_text.
    mv_value = value.
  ENDMETHOD.

  METHOD if_sxml_attribute~get_value.
    value = mv_value.
  ENDMETHOD.
ENDCLASS.
