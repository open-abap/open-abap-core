CLASS kernel_ixml_to_data DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS build
      IMPORTING 
        iv_name TYPE string
        iv_ref  TYPE REF TO data
        ii_doc  TYPE REF TO if_ixml_document.
  PRIVATE SECTION.
    CLASS-METHODS get_field_name
      IMPORTING ii_node TYPE REF TO if_ixml_node
      RETURNING VALUE(rv_name) TYPE string.        
ENDCLASS.

CLASS kernel_ixml_to_data IMPLEMENTATION.

  METHOD get_field_name.
    DATA li_aiterator TYPE REF TO if_ixml_node_iterator.
    DATA li_anode TYPE REF TO if_ixml_node.
    DATA attr TYPE REF TO if_ixml_named_node_map.
    
    attr = ii_node->get_attributes( ).
    IF attr IS NOT INITIAL.
      li_aiterator = attr->create_iterator( ).
      DO.
        li_anode = li_aiterator->get_next( ).
        IF li_anode IS INITIAL.
          EXIT. " current loop
        ENDIF.
* assume its the name,
        rv_name = li_anode->get_value( ).
        RETURN.
      ENDDO.
    ENDIF.
  ENDMETHOD.

  METHOD build.
* assumptions: the top level element is an object containing iv_name

* todo

    DATA li_first TYPE REF TO if_ixml_node.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA lv_name TYPE string.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    
    li_first = ii_doc->get_root( )->get_first_child( ).
    ASSERT li_first->get_name( ) = 'object'.

    li_iterator = li_first->get_children( )->create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        EXIT. " current loop
      ENDIF.

      lv_name = get_field_name( li_node ).
      IF lv_name = iv_name.
*        WRITE '@KERNEL console.dir("found");'. 
* todo        
        RETURN.
      ENDIF.
    ENDDO.
    
  ENDMETHOD.

ENDCLASS.