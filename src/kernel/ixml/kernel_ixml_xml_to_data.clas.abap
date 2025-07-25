CLASS kernel_ixml_xml_to_data DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS build
      IMPORTING
        iv_name TYPE string
        iv_ref  TYPE REF TO data
        ii_doc  TYPE REF TO if_ixml_document.
  PRIVATE SECTION.
    CLASS-DATA mi_heap TYPE REF TO if_ixml_element.

    CLASS-METHODS traverse
      IMPORTING
        ii_node TYPE REF TO if_ixml_node
        iv_ref  TYPE REF TO data.

    CLASS-METHODS find_href_in_heap
      IMPORTING
        VALUE(iv_href) TYPE string
      RETURNING
        VALUE(ri_node) TYPE REF TO if_ixml_node.
ENDCLASS.

CLASS kernel_ixml_xml_to_data IMPLEMENTATION.

  METHOD build.

    DATA li_first    TYPE REF TO if_ixml_element.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA lv_name     TYPE string.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.

    mi_heap = ii_doc->find_from_name_ns( 'heap' ).
*    WRITE '@KERNEL console.dir(this.mi_heap);'.

    li_first ?= ii_doc->get_root( )->get_first_child( ).

    li_node = li_first->find_from_name_ns(
      name      = iv_name
      depth     = 0
      namespace = '' ).
    IF li_node IS NOT INITIAL.
      traverse( ii_node = li_node
                iv_ref  = iv_ref ).
    ENDIF.
  ENDMETHOD.

  METHOD find_href_in_heap.

    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_child    TYPE REF TO if_ixml_node.
    DATA lv_id       TYPE string.

    REPLACE FIRST OCCURRENCE OF '#' IN iv_href WITH ''.
    ASSERT mi_heap IS NOT INITIAL.
    ASSERT iv_href IS NOT INITIAL.

    li_iterator = mi_heap->get_children( )->create_iterator( ).

    DO.
      li_child = li_iterator->get_next( ).
      IF li_child IS INITIAL.
        EXIT. " current loop
      ENDIF.
      lv_id = li_child->get_attributes( )->get_named_item_ns( 'id' )->get_value( ).
      IF lv_id = iv_href.
        ri_node = li_child.
        RETURN.
      ENDIF.
    ENDDO.

    ASSERT 1 = 'not found in heap'.

  ENDMETHOD.

  METHOD traverse.

    DATA lo_type     TYPE REF TO cl_abap_typedescr.
    DATA li_child    TYPE REF TO if_ixml_node.
    DATA li_heap     TYPE REF TO if_ixml_node.
    DATA li_iname    TYPE REF TO if_ixml_node.
    DATA lv_name     TYPE string.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA lv_ref      TYPE REF TO data.
    DATA lv_value    TYPE string.
    DATA li_href     TYPE REF TO if_ixml_node.

    FIELD-SYMBOLS <any>   TYPE any.
    FIELD-SYMBOLS <field> TYPE any.
    FIELD-SYMBOLS <tab>   TYPE ANY TABLE.
    FIELD-SYMBOLS <ref>   TYPE any.

    ASSIGN iv_ref->* TO <ref>.
    lo_type = cl_abap_typedescr=>describe_by_data( <ref> ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        ASSIGN iv_ref->* TO <any>.
        li_iterator = ii_node->get_children( )->create_iterator( ).
        DO.
          li_child = li_iterator->get_next( ).
          IF li_child IS INITIAL.
            EXIT. " current loop
          ENDIF.
          lv_name = li_child->get_name( ).
          ASSIGN COMPONENT lv_name OF STRUCTURE <any> TO <field>.
          IF sy-subrc = 0.
            GET REFERENCE OF <field> INTO lv_ref.
            traverse( ii_node = li_child
                      iv_ref  = lv_ref ).
          ENDIF.
        ENDDO.
      WHEN cl_abap_typedescr=>kind_elem.
        li_child = ii_node->get_first_child( ).
        IF li_child IS NOT INITIAL.
          ASSIGN iv_ref->* TO <any>.
          <any> = li_child->get_value( ).
        ENDIF.
      WHEN cl_abap_typedescr=>kind_table.
        ASSIGN iv_ref->* TO <tab>.
        li_iterator = ii_node->get_children( )->create_iterator( ).
        DO.
          li_child = li_iterator->get_next( ).
          IF li_child IS INITIAL.
            EXIT. " current loop
          ENDIF.
          CREATE DATA lv_ref LIKE LINE OF <tab>.
          ASSIGN lv_ref->* TO <any>.
          traverse( ii_node = li_child
                    iv_ref  = lv_ref ).
          INSERT <any> INTO TABLE <tab>.
        ENDDO.
      WHEN cl_abap_typedescr=>kind_ref.
        ASSIGN iv_ref->* TO <any>.
        IF <any> IS INITIAL.
          " WRITE '@KERNEL lv_rtti_name.set(fs_any_.getPointer().RTTIName);'.
          " lv_internal = kernel_internal_name=>rtti_to_internal( lv_rtti_name ).
          " WRITE '@KERNEL fs_any_.pointer.value = new abap.Classes[lv_internal.get()]();'.

          li_href = ii_node->get_attributes( )->get_named_item_ns( 'href' ).
          IF li_href IS INITIAL.
            RETURN.
          ENDIF.
          lv_value = li_href->get_value( ).
          ASSERT lv_value IS NOT INITIAL.
          li_heap = find_href_in_heap( lv_value ).

          li_iname = li_heap->get_attributes( )->get_named_item_ns( 'internalName' ).
          IF li_iname IS INITIAL AND lv_value(2) = '#o'.
* then its a non serializable object, not to be instantiated
            RETURN.
          ENDIF.

          IF lv_value(2) = '#o'.
            lv_value = li_iname->get_value( ).
            ASSERT lv_value IS NOT INITIAL.
*          WRITE '@KERNEL console.dir(lv_value);'.
            WRITE '@KERNEL fs_any_.pointer.value = new abap.Classes[lv_value.get()]();'.

          " li_child = ii_node->get_attributes( )->get_named_item_ns( 'href' ).
          " WRITE '@KERNEL console.dir(ii_node.get());'.

            li_iterator = li_heap->get_first_child( )->get_children( )->create_iterator( ).
            DO.
              li_child = li_iterator->get_next( ).
              IF li_child IS INITIAL.
                EXIT. " current loop
              ENDIF.
              lv_name = li_child->get_name( ).
              REPLACE FIRST OCCURRENCE OF '.' IN lv_name WITH '~'.

              ASSIGN <any>->(lv_name) TO <field>.
              IF sy-subrc = 0.
                GET REFERENCE OF <field> INTO lv_ref.
                traverse( ii_node = li_child
                          iv_ref  = lv_ref ).
              ENDIF.
            ENDDO.
          ELSE.
* its a data reference
            " WRITE / lv_value.
            " WRITE '@KERNEL console.dir(fs_any_);'.
            CREATE DATA <any>.
            " WRITE '@KERNEL console.dir(fs_any_);'.

            li_child = li_heap->get_first_child( ).
            GET REFERENCE OF <any> INTO lv_ref.

            " WRITE '@KERNEL console.dir(lv_ref);'.
            traverse( ii_node = li_child
                      iv_ref  = <any> ).
          ENDIF.
        ELSE.
          ASSERT 1 = 'todo_ref2'.
        ENDIF.
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(lo_type.get().kind.get());'.
        ASSERT 1 = 'todo'.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.