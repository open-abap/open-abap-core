CLASS cl_sxml_close_element DEFINITION PUBLIC FINAL.
  PUBLIC SECTION.
    INTERFACES if_sxml_close_element.
    METHODS constructor
      IMPORTING name TYPE string prefix TYPE string OPTIONAL nsuri TYPE string OPTIONAL.
ENDCLASS.

CLASS cl_sxml_close_element IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_element_close.
    if_sxml_close_element~qname-name = name.
    if_sxml_close_element~qname-namespace = nsuri.
  ENDMETHOD.
ENDCLASS.
