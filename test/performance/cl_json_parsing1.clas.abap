CLASS cl_json_parsing1 DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run.
ENDCLASS.

CLASS cl_json_parsing1 IMPLEMENTATION.
  METHOD run.
    DATA lv_json   TYPE string.
    DATA lo_node   TYPE REF TO if_sxml_node.
    DATA lo_reader TYPE REF TO if_sxml_reader.

    lv_json = lv_json && '['.
    DO 8000 TIMES.
      lv_json = lv_json && '{"abap": 2, "foo": "sdfs", "another": ""},'.
    ENDDO.
    lv_json = substring(
      val = lv_json
      len = strlen( lv_json ) - 1 ).
    lv_json = lv_json && ']'.

    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( lv_json ) ).
    DO.
      lo_node = lo_reader->read_next_node( ).
      IF lo_node IS NOT BOUND.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.
ENDCLASS.