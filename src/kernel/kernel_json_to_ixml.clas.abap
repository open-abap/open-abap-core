CLASS kernel_json_to_ixml DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS build
      IMPORTING iv_json TYPE string
      RETURNING VALUE(ri_doc) TYPE REF TO if_ixml_document.
ENDCLASS.

CLASS kernel_json_to_ixml IMPLEMENTATION.

  METHOD build.

    DATA li_reader TYPE REF TO if_sxml_reader.
    DATA li_node TYPE REF TO if_sxml_node.
    DATA li_close TYPE REF TO if_sxml_close_element.
    DATA li_open TYPE REF TO if_sxml_open_element.
    DATA li_value TYPE REF TO if_sxml_value_node.
    DATA lt_attributes TYPE if_sxml_attribute=>attributes.
    DATA li_attribute TYPE REF TO if_sxml_attribute.
    DATA li_current TYPE REF TO if_ixml_node.
    DATA lv_name TYPE string.
    DATA li_map TYPE REF TO if_ixml_named_node_map.
    DATA li_new TYPE REF TO if_ixml_node.
    DATA li_element TYPE REF TO if_ixml_element.

    li_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( iv_json ) ).

    ri_doc = cl_ixml=>create( )->create_document( ).
    li_current = ri_doc->get_root( ).

    DO.
      li_node = li_reader->read_next_node( ).
      IF li_node IS INITIAL.
        EXIT.
      ENDIF.

      CASE li_node->type.
        WHEN if_sxml_node=>co_nt_element_open.
          li_open ?= li_node.
*          WRITE: / 'open: ', li_open->qname-name.

          CLEAR lv_name.
          lt_attributes = li_open->get_attributes( ).
          LOOP AT lt_attributes INTO li_attribute.
*            WRITE / li_attribute->get_value( ).
            lv_name = li_attribute->get_value( ).
          ENDLOOP.

          li_element = ri_doc->create_element_ns( li_open->qname-name ).
          li_new ?= li_element.
          li_current->append_child( li_new ).
          li_current = li_new.
*            WRITE '@KERNEL console.dir(li_element);'.
          
          IF lv_name IS NOT INITIAL.
            li_element = ri_doc->create_element_ns( 'name' ).
            li_new ?= li_element.
            li_new->set_value( lv_name ).
  
            li_map = li_current->get_attributes( ).
            li_map->set_named_item_ns( li_new ).
          ENDIF.

        WHEN if_sxml_node=>co_nt_element_close.
          li_close ?= li_node.
*          WRITE: / 'close: ', li_close->qname-name.
          IF li_close->qname-name = 'object' OR li_close->qname-name = 'array'.
            li_current = li_current->get_parent( ).
          ENDIF.
        WHEN if_sxml_node=>co_nt_value.
          li_value ?= li_node.
*          WRITE / li_value->get_value( ).
*          li_current->set_value( li_value->get_value( ) ).

          li_element = ri_doc->create_element_ns( '#text' ).
          li_element->set_value( li_value->get_value( ) ).
          li_new ?= li_element.
          li_current->append_child( li_new ).

      ENDCASE.
    ENDDO.

  ENDMETHOD.

ENDCLASS.