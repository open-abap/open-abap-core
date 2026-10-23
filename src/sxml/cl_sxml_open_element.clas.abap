CLASS cl_sxml_open_element DEFINITION PUBLIC FINAL.
  PUBLIC SECTION.
    INTERFACES if_sxml_open_element.
    METHODS constructor
      IMPORTING
        name       TYPE string
        prefix     TYPE string OPTIONAL
        nsuri      TYPE string OPTIONAL
        attributes TYPE if_sxml_attribute=>attributes OPTIONAL.
  PRIVATE SECTION.
    DATA mt_attributes TYPE if_sxml_attribute=>attributes.
ENDCLASS.

CLASS cl_sxml_open_element IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_element_open.
    if_sxml_open_element~qname-name = name.
    if_sxml_open_element~prefix = prefix.
    if_sxml_open_element~qname-namespace = nsuri.
    mt_attributes = attributes.
  ENDMETHOD.

  METHOD if_sxml_open_element~get_attribute_value.
    DATA attribute TYPE REF TO if_sxml_attribute.
    LOOP AT mt_attributes INTO attribute.
      IF attribute->qname-name = name AND attribute->qname-namespace = nsuri.
        CREATE OBJECT value TYPE cl_sxml_value
          EXPORTING
            value = attribute->get_value( ).
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_sxml_open_element~get_attributes.
    attr = mt_attributes.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_prefix.
    if_sxml_open_element~prefix = prefix.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_attribute.
* an attribute set twice keeps its position and takes the new value
    DATA lv_index TYPE i.
    DATA li_existing TYPE REF TO if_sxml_attribute.
    CREATE OBJECT attribute TYPE lcl_attribute
      EXPORTING
        name   = name
        prefix = prefix
        nsuri  = nsuri
        value  = value.
    LOOP AT mt_attributes INTO li_existing.
      lv_index = sy-tabix.
      IF li_existing->qname-name = name AND li_existing->qname-namespace = nsuri.
        MODIFY mt_attributes INDEX lv_index FROM attribute.
        RETURN.
      ENDIF.
    ENDLOOP.
    APPEND attribute TO mt_attributes.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_attributes.
    DATA li_attribute TYPE REF TO if_sxml_attribute.
    LOOP AT attributes INTO li_attribute.
      if_sxml_open_element~set_attribute( name   = li_attribute->qname-name
                                          nsuri  = li_attribute->qname-namespace
                                          prefix = li_attribute->prefix
                                          value  = li_attribute->get_value( ) ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
