CLASS cl_sxml_value DEFINITION PUBLIC FINAL.
  PUBLIC SECTION.
    INTERFACES if_sxml_value_node.
    INTERFACES if_sxml_value.
    METHODS constructor IMPORTING value TYPE string.
  PRIVATE SECTION.
    DATA mv_value TYPE string.
ENDCLASS.

CLASS cl_sxml_value IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_value.
    mv_value = value.
    if_sxml_value~type = if_sxml_value=>co_vt_text.
  ENDMETHOD.

  METHOD if_sxml_value_node~get_value_raw.
    value = cl_abap_codepage=>convert_to( mv_value ).
  ENDMETHOD.

  METHOD if_sxml_value_node~set_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_value_node~set_value_raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_value_node~get_value.
    value = mv_value.
  ENDMETHOD.

  METHOD if_sxml_value~get_value.
    value = mv_value.
  ENDMETHOD.

  METHOD if_sxml_value~get_value_raw.
    value = cl_abap_codepage=>convert_to( mv_value ).
  ENDMETHOD.

  METHOD if_sxml_value~set_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_value~set_value_raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
