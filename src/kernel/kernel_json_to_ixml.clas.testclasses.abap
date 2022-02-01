CLASS ltcl_json_to_ixml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS dump_list
      IMPORTING
        ii_list        TYPE REF TO if_ixml_node_list
      RETURNING
        VALUE(rv_dump) TYPE string.
    METHODS dump
      IMPORTING 
        iv_json TYPE string
      RETURNING
        VALUE(rv_dump) TYPE string.    

    METHODS test_empty_object FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_json_to_ixml IMPLEMENTATION.

  METHOD dump.
    DATA li_node TYPE REF TO if_ixml_node.
    li_node ?= kernel_json_to_ixml=>build( iv_json ).
    rv_dump = dump_list( li_node->get_children( ) ).
  ENDMETHOD.

  METHOD dump_list.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_aiterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA attr TYPE REF TO if_ixml_named_node_map.
    DATA li_anode TYPE REF TO if_ixml_node.

    li_iterator = ii_list->create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        EXIT. " current loop
      ENDIF.

      rv_dump = |{ rv_dump }NAME:{
        li_node->get_name( ) }|.
      rv_dump = |{ rv_dump },DEPTH:{
        li_node->get_depth( ) },VALUE:{
        li_node->get_value( ) }|.
      IF li_node->get_namespace( ) IS NOT INITIAL.
        rv_dump = |{ rv_dump },NS:{ li_node->get_namespace( ) }|.
      ENDIF.
      IF li_node->is_leaf( ) = abap_true.
        rv_dump = |{ rv_dump },LEAF:{ li_node->is_leaf( ) }|.
      ENDIF.
      rv_dump = |{ rv_dump }\n|.

      attr = li_node->get_attributes( ).
      IF attr IS NOT INITIAL.
        li_aiterator = attr->create_iterator( ).
        DO.
          li_anode = li_aiterator->get_next( ).
          IF li_anode IS INITIAL.
            EXIT. " current loop
          ENDIF.
          rv_dump = |{ rv_dump }  ANAME:{ li_anode->get_name( ) },AVALUE:{ li_anode->get_value( ) }\n|.
        ENDDO.
      ENDIF.

      rv_dump = rv_dump && dump_list( li_node->get_children( ) ).
    ENDDO.
  ENDMETHOD.

  METHOD test_empty_object.
    DATA lv_dump TYPE string.
    lv_dump = dump( '{}' ).
    WRITE '@KERNEL console.dir(lv_dump);'.
    cl_abap_unit_assert=>assert_equals(
      act = lv_dump
      exp = |NAME:object,DEPTH:0,VALUE:,LEAF:X\n| ).
  ENDMETHOD.

ENDCLASS.