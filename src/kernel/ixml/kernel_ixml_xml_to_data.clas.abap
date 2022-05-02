CLASS kernel_ixml_xml_to_data DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS build
      IMPORTING
        iv_name TYPE string
        iv_ref  TYPE REF TO data
        ii_doc  TYPE REF TO if_ixml_document.
  PRIVATE SECTION.
    CLASS-METHODS traverse
      IMPORTING
        ii_node TYPE REF TO if_ixml_node
        iv_ref  TYPE REF TO data.
ENDCLASS.

CLASS kernel_ixml_xml_to_data IMPLEMENTATION.

  METHOD build.

    DATA li_first TYPE REF TO if_ixml_element.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA lv_name TYPE string.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.

    li_first ?= ii_doc->get_root( )->get_first_child( ).

    li_node = li_first->find_from_name_ns(
      name      = iv_name
      depth     = 0
      namespace = '' ).
    IF li_node IS NOT INITIAL.
*      WRITE '@KERNEL console.dir("found");'.
      traverse( ii_node = li_node
                iv_ref  = iv_ref ).
*    ELSE.
*      WRITE '@KERNEL console.dir("nah");'.
    ENDIF.

  ENDMETHOD.

  METHOD traverse.

    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA li_child TYPE REF TO if_ixml_node.
    DATA lv_name TYPE string.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA lv_ref TYPE REF TO data.
    FIELD-SYMBOLS <any> TYPE any.
    FIELD-SYMBOLS <field> TYPE any.
    FIELD-SYMBOLS <tab> TYPE ANY TABLE.

    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
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
        ASSIGN iv_ref->* TO <any>.
        <any> = li_child->get_value( ).
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
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(lo_type.get().kind.get());'.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.