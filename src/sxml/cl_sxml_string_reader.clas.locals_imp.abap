CLASS lcl_node DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_type TYPE if_sxml_node=>node_type.
    INTERFACES if_sxml_node.
ENDCLASS.

CLASS lcl_node IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = iv_type.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_reader DEFINITION.
  PUBLIC SECTION.
    TYPES ty_nodes TYPE STANDARD TABLE OF REF TO if_sxml_node WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING
        it_nodes TYPE ty_nodes.
    INTERFACES if_sxml_reader.
  PRIVATE SECTION.
    DATA mt_nodes TYPE ty_nodes.
    DATA mv_pointer TYPE i.
ENDCLASS.

CLASS lcl_reader IMPLEMENTATION.
  METHOD constructor.
    mt_nodes = it_nodes.
    mv_pointer = 1.
  ENDMETHOD.

  METHOD if_sxml_reader~read_next_node.
    READ TABLE mt_nodes INDEX mv_pointer INTO node.
    mv_pointer = mv_pointer + 1.
  ENDMETHOD.
ENDCLASS.