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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_attributes.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
