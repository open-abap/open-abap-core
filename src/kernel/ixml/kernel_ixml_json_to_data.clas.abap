CLASS kernel_ixml_json_to_data DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS build
      IMPORTING
        iv_name TYPE string
        iv_ref  TYPE REF TO data
        ii_doc  TYPE REF TO if_ixml_document.
  PRIVATE SECTION.
    CLASS-METHODS get_field_name
      IMPORTING ii_node        TYPE REF TO if_ixml_node
      RETURNING VALUE(rv_name) TYPE string.
    CLASS-METHODS traverse
      IMPORTING
        ii_node TYPE REF TO if_ixml_node
        iv_ref  TYPE REF TO data.
ENDCLASS.

CLASS kernel_ixml_json_to_data IMPLEMENTATION.

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
    DATA li_first    TYPE REF TO if_ixml_node.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA lv_name     TYPE string.
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
        traverse(
          iv_ref  = iv_ref
          ii_node = li_node ).
        RETURN.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD traverse.

    DATA lo_type     TYPE REF TO cl_abap_typedescr.
    DATA li_child    TYPE REF TO if_ixml_node.
    DATA lv_name     TYPE string.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA lv_ref      TYPE REF TO data.

    FIELD-SYMBOLS <any>   TYPE any.
    FIELD-SYMBOLS <field> TYPE any.
    FIELD-SYMBOLS <tab>   TYPE ANY TABLE.

    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        ASSERT ii_node->get_name( ) = 'object'.
        ASSIGN iv_ref->* TO <any>.
        li_iterator = ii_node->get_children( )->create_iterator( ).
        DO.
          li_child = li_iterator->get_next( ).
          IF li_child IS INITIAL.
            EXIT. " current loop
          ENDIF.
          lv_name = get_field_name( li_child ).
          ASSIGN COMPONENT lv_name OF STRUCTURE <any> TO <field>.
          IF sy-subrc = 0.
            GET REFERENCE OF <field> INTO lv_ref.
            traverse( ii_node = li_child
                      iv_ref  = lv_ref ).
          ENDIF.
        ENDDO.
      WHEN cl_abap_typedescr=>kind_elem.
        li_child = ii_node->get_first_child( ).
        ASSERT li_child->get_name( ) = '#text'.
        ASSIGN iv_ref->* TO <any>.
        <any> = li_child->get_value( ).

        IF lo_type->type_kind = cl_abap_typedescr=>typekind_char
            OR lo_type->type_kind = cl_abap_typedescr=>typekind_clike
            OR lo_type->type_kind = cl_abap_typedescr=>typekind_string.
          REPLACE ALL OCCURRENCES OF '\"' IN <any> WITH '"'.
        ENDIF.
      WHEN cl_abap_typedescr=>kind_table.
        ASSERT ii_node->get_name( ) = 'array'.
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
        ASSERT 1 = 'todo'.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.