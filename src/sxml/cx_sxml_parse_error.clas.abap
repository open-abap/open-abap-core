CLASS cx_sxml_parse_error DEFINITION PUBLIC INHERITING FROM cx_sxml_error.
  PUBLIC SECTION.
    METHODS constructor IMPORTING xml_offset TYPE i.
    DATA xml_offset TYPE i.
ENDCLASS.

CLASS cx_sxml_parse_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->xml_offset = xml_offset.
  ENDMETHOD.
ENDCLASS.