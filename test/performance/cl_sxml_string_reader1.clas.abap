CLASS cl_sxml_string_reader1 DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run.
ENDCLASS.

CLASS cl_sxml_string_reader1 IMPLEMENTATION.
  METHOD run.
* Parse 2,000 child elements (6,002 SXML nodes) as a performance workload.
    DATA lv_xml    TYPE string.
    DATA lo_reader TYPE REF TO if_sxml_reader.
    DATA lo_node   TYPE REF TO if_sxml_node.

    lv_xml = '<a>' && repeat( val = '<b>12345678</b>'
                              occ = 2000 ) && '</a>'.
    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( lv_xml ) ).

    DO.
      lo_node = lo_reader->read_next_node( ).
      IF lo_node IS NOT BOUND.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.
ENDCLASS.
