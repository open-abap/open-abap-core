CLASS cx_sxml_parse_error DEFINITION PUBLIC INHERITING FROM cx_sxml_error.
  PUBLIC SECTION.
    METHODS constructor IMPORTING xml_offset TYPE i.
    METHODS if_message~get_text REDEFINITION.
    CONSTANTS kernel_parser TYPE sotr_conc VALUE '00000000000000000000000000000000'.

    DATA error_text TYPE string.
    DATA rawstring  TYPE string.
    DATA xml_offset TYPE i.
    DATA rc         TYPE i.
ENDCLASS.

CLASS cx_sxml_parse_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->xml_offset = xml_offset.
  ENDMETHOD.

  METHOD if_message~get_text.
    IF rawstring IS INITIAL.
      result = super->if_message~get_text( ).
    ELSE.
      result = rawstring.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
