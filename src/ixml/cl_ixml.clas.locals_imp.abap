CLASS lcl_escape DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS unescape_value
      IMPORTING
        iv_value        TYPE string
      RETURNING
        VALUE(rv_value) TYPE string.

    CLASS-METHODS escape_value
      IMPORTING
        iv_value        TYPE string
      RETURNING
        VALUE(rv_value) TYPE string.

  PRIVATE SECTION.
    CLASS-METHODS unescape_references
      IMPORTING
        iv_value        TYPE string
      RETURNING
        VALUE(rv_value) TYPE string.

    CLASS-METHODS reference_to_char
      IMPORTING
        iv_number      TYPE string
      RETURNING
        VALUE(rv_char) TYPE string.
ENDCLASS.

CLASS lcl_escape IMPLEMENTATION.
  METHOD unescape_value.
    rv_value = iv_value.
    REPLACE ALL OCCURRENCES OF '&lt;' IN rv_value WITH '<'.
    REPLACE ALL OCCURRENCES OF '&gt;' IN rv_value WITH '>'.
    REPLACE ALL OCCURRENCES OF '&quot;' IN rv_value WITH '"'.
    REPLACE ALL OCCURRENCES OF '&apos;' IN rv_value WITH |'|.
    rv_value = unescape_references( rv_value ).
* "&amp;" must be last, otherwise an escaped "&amp;lt;" is unescaped twice and
* a value that literally contains "&lt;" comes back as "<"
    REPLACE ALL OCCURRENCES OF '&amp;' IN rv_value WITH '&'.
  ENDMETHOD.

  METHOD unescape_references.
* character references, decimal "&#10;" and hexadecimal "&#x41;". Anything
* that is not one, "&#foo;" or "AT&#T", is left exactly as it is
    DATA lt_parts  TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lv_part   TYPE string.
    DATA lv_char   TYPE string.
    DATA lv_tail   TYPE string.
    DATA lv_number TYPE string.
    DATA lv_offset TYPE i.

    rv_value = iv_value.
    IF rv_value NS '&#'.
      RETURN.
    ENDIF.

    SPLIT rv_value AT '&#' INTO TABLE lt_parts.
    CLEAR rv_value.

    LOOP AT lt_parts INTO lv_part.
      IF sy-tabix = 1.
        rv_value = lv_part.
        CONTINUE.
      ENDIF.

      CLEAR lv_char.
      FIND FIRST OCCURRENCE OF ';' IN lv_part MATCH OFFSET lv_offset.
      IF sy-subrc = 0 AND lv_offset > 0.
        lv_number = lv_part(lv_offset).
        lv_char = reference_to_char( lv_number ).
      ENDIF.

      IF lv_char IS INITIAL.
        CONCATENATE rv_value '&#' lv_part INTO rv_value RESPECTING BLANKS.
      ELSE.
        lv_tail = lv_part+lv_offset.
        SHIFT lv_tail LEFT BY 1 PLACES.
        CONCATENATE rv_value lv_char lv_tail INTO rv_value RESPECTING BLANKS.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD reference_to_char.
* the text between "&#" and ";". Returns initial when it is not a number the
* runtime can turn into a character, the caller then keeps the text
    DATA lv_text  TYPE string.
    DATA lv_digit TYPE string.
    DATA lv_hex   TYPE abap_bool.
    DATA lv_value TYPE i.
    DATA lv_index TYPE i.
    DATA lv_pos   TYPE i.

    lv_text = iv_number.
    TRANSLATE lv_text TO UPPER CASE.

    IF lv_text(1) = 'X'.
      lv_hex = abap_true.
      SHIFT lv_text LEFT BY 1 PLACES.
      IF lv_text IS INITIAL.
        RETURN.
      ENDIF.
    ENDIF.

    WHILE lv_pos < strlen( lv_text ).
      lv_digit = lv_text+lv_pos(1).
      IF lv_hex = abap_true.
        FIND FIRST OCCURRENCE OF lv_digit IN '0123456789ABCDEF' MATCH OFFSET lv_index.
      ELSE.
        FIND FIRST OCCURRENCE OF lv_digit IN '0123456789' MATCH OFFSET lv_index.
      ENDIF.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      IF lv_hex = abap_true.
        lv_value = lv_value * 16 + lv_index.
      ELSE.
        lv_value = lv_value * 10 + lv_index.
      ENDIF.
* uccpi builds the character from two bytes, a code point above the basic
* multilingual plane is left as it is
      IF lv_value > 65535.
        RETURN.
      ENDIF.

      lv_pos = lv_pos + 1.
    ENDWHILE.

    IF lv_value = 0.
      RETURN.
    ENDIF.

    IF lv_value = 32.
* a blank, uccpi returns it in a C field where it is a trailing space
      rv_char = ` `.
    ELSE.
      rv_char = cl_abap_conv_in_ce=>uccpi( lv_value ).
    ENDIF.
  ENDMETHOD.

  METHOD escape_value.
    rv_value = iv_value.
    REPLACE ALL OCCURRENCES OF '&' IN rv_value WITH '&amp;'.
    REPLACE ALL OCCURRENCES OF '<' IN rv_value WITH '&lt;'.
    REPLACE ALL OCCURRENCES OF '>' IN rv_value WITH '&gt;'.
    REPLACE ALL OCCURRENCES OF '"' IN rv_value WITH '&quot;'.
    REPLACE ALL OCCURRENCES OF |'| IN rv_value WITH '&apos;'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_node_iterator DEFINITION.
  PUBLIC SECTION.
    TYPES ty_list TYPE STANDARD TABLE OF REF TO if_ixml_node WITH DEFAULT KEY.
    INTERFACES if_ixml_node_iterator.
    METHODS constructor IMPORTING it_list TYPE ty_list.
  PRIVATE SECTION.
    DATA mv_pointer TYPE i.
    DATA mt_list TYPE ty_list.
ENDCLASS.

CLASS lcl_node_iterator IMPLEMENTATION.
  METHOD constructor.
    mt_list = it_list.
    mv_pointer = 1.
  ENDMETHOD.

  METHOD if_ixml_node_iterator~reset.
    mv_pointer = 1.
  ENDMETHOD.

  METHOD if_ixml_node_iterator~get_next.
    READ TABLE mt_list INDEX mv_pointer INTO rval.
*    WRITE '@KERNEL console.dir(rval);'.
    mv_pointer = mv_pointer + 1.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_encoding DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_encoding.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_encoding IMPLEMENTATION.
  METHOD if_ixml_encoding~set_character_set.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_encoding~get_byte_order.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_encoding~get_character_set.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_named_node_map DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_named_node_map.
  PRIVATE SECTION.
    DATA mt_list TYPE STANDARD TABLE OF REF TO if_ixml_node WITH DEFAULT KEY.
ENDCLASS.

CLASS lcl_named_node_map IMPLEMENTATION.
  METHOD if_ixml_named_node_map~get_item.
* one based, the same as get_item of the node list and the node collection
    READ TABLE mt_list INDEX index INTO rval.
  ENDMETHOD.

  METHOD if_ixml_named_node_map~create_iterator.
    CREATE OBJECT iterator TYPE lcl_node_iterator
      EXPORTING it_list = mt_list.
  ENDMETHOD.

  METHOD if_ixml_named_node_map~get_length.
    val = lines( mt_list ).
  ENDMETHOD.

  METHOD if_ixml_named_node_map~get_named_item_ns.
    DATA li_node LIKE LINE OF mt_list.

    LOOP AT mt_list INTO li_node.
      IF li_node->get_name( ) = name.
        val = li_node.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_ixml_named_node_map~get_named_item.
    val = if_ixml_named_node_map~get_named_item_ns( name ).
  ENDMETHOD.

  METHOD if_ixml_named_node_map~remove_named_item.
    DATA li_node  LIKE LINE OF mt_list.
    DATA lv_index TYPE i.

    LOOP AT mt_list INTO li_node.
      IF li_node->get_name( ) = name.
        lv_index = sy-tabix.
        EXIT.
      ENDIF.
    ENDLOOP.

* a name the map does not carry is not an error, there is nothing to remove
    IF lv_index > 0.
      DELETE mt_list INDEX lv_index.
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_named_node_map~set_named_item_ns.
* replace an existing node with the same name, otherwise add it,
* appending unconditionally produces duplicate attributes
    DATA lv_index TYPE i.
    DATA li_node  LIKE LINE OF mt_list.

    LOOP AT mt_list INTO li_node.
      lv_index = sy-tabix.
      IF li_node->get_name( ) = node->get_name( ).
        MODIFY mt_list INDEX lv_index FROM node.
        RETURN.
      ENDIF.
    ENDLOOP.

    APPEND node TO mt_list.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_node_list DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_node_list.
    INTERFACES if_ixml_node_collection.
    METHODS append IMPORTING ii_node TYPE REF TO if_ixml_node.
    METHODS remove IMPORTING ii_node TYPE REF TO if_ixml_node.
  PRIVATE SECTION.
    DATA mt_list TYPE STANDARD TABLE OF REF TO if_ixml_node WITH DEFAULT KEY.
ENDCLASS.

CLASS lcl_node_list IMPLEMENTATION.
  METHOD append.
    ASSERT ii_node IS NOT INITIAL.
    APPEND ii_node TO mt_list.
  ENDMETHOD.

  METHOD remove.
    READ TABLE mt_list WITH KEY table_line = ii_node TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      DELETE mt_list INDEX sy-tabix.
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_node_list~get_length.
    length = lines( mt_list ).
  ENDMETHOD.

  METHOD if_ixml_node_list~create_iterator.
    CREATE OBJECT rval TYPE lcl_node_iterator
      EXPORTING it_list = mt_list.
  ENDMETHOD.

  METHOD if_ixml_node_list~get_item.
    READ TABLE mt_list INDEX index INTO val.
  ENDMETHOD.

  METHOD if_ixml_node_list~create_rev_iterator_filtered.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node_collection~get_length.
    rval = lines( mt_list ).
  ENDMETHOD.

  METHOD if_ixml_node_collection~create_iterator.
    CREATE OBJECT rval TYPE lcl_node_iterator
      EXPORTING it_list = mt_list.
  ENDMETHOD.

  METHOD if_ixml_node_collection~get_item.
    READ TABLE mt_list INDEX index INTO rval.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_node DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_element.
    INTERFACES if_ixml_text.
* an attribute is a node of this class too, so it is one of these as well -
* the interface adds no method of its own, only aliases of if_ixml_node
    INTERFACES if_ixml_attribute.

    METHODS constructor
      IMPORTING
        ii_parent TYPE REF TO if_ixml_node OPTIONAL.

    METHODS set_parent
      IMPORTING
        ii_parent TYPE REF TO if_ixml_node.
    METHODS get_parent
      RETURNING
        VALUE(ri_parent) TYPE REF TO if_ixml_node.

  PRIVATE SECTION.
    DATA mv_name       TYPE string.
    DATA mv_namespace  TYPE string.
* internal representation is unescaped
    DATA mv_value      TYPE string.

    DATA mo_children   TYPE REF TO lcl_node_list.
    DATA mi_parent     TYPE REF TO if_ixml_node.
    DATA mi_attributes TYPE REF TO if_ixml_named_node_map.

    METHODS has_direct_text
      RETURNING
        VALUE(rv_has) TYPE abap_bool.

    METHODS collect_subtree
      CHANGING
        ct_nodes TYPE lcl_node_iterator=>ty_list.

    METHODS collect_elements_by_tag_name
      IMPORTING
        iv_name      TYPE string
        iv_namespace TYPE string
        io_list      TYPE REF TO lcl_node_list.

    METHODS uri_of_prefix
      IMPORTING
        iv_prefix     TYPE string
      RETURNING
        VALUE(rv_uri) TYPE string.

    METHODS attribute_node
      IMPORTING
        iv_name        TYPE string
        iv_uri         TYPE string OPTIONAL
      RETURNING
        VALUE(ri_node) TYPE REF TO if_ixml_node.
ENDCLASS.

CLASS lcl_node IMPLEMENTATION.
  METHOD if_ixml_node~create_filter_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~create_filter_parent.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_parent.
    ri_parent = mi_parent.
  ENDMETHOD.

  METHOD set_parent.
    mi_parent = ii_parent.
  ENDMETHOD.

  METHOD if_ixml_node~num_children.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD constructor.
    CREATE OBJECT mo_children TYPE lcl_node_list.
    CREATE OBJECT mi_attributes TYPE lcl_named_node_map.
    mi_parent = ii_parent.

    IF mi_parent IS NOT INITIAL.
      ii_parent->append_child( me ).
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_node~get_height.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_gid.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~insert_child.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~clone.
* a deep copy: the node with its name, value and attributes, and every
* child cloned in turn. The copy has no parent, it belongs nowhere until it
* is appended somewhere
    DATA lo_clone TYPE REF TO lcl_node.
    DATA lo_attr  TYPE REF TO lcl_node.
    DATA li_attr  TYPE REF TO if_ixml_node.
    DATA li_iter  TYPE REF TO if_ixml_node_iterator.
    DATA li_child TYPE REF TO if_ixml_node.
    DATA lv_index TYPE i.

    CREATE OBJECT lo_clone.
    lo_clone->mv_name      = mv_name.
    lo_clone->mv_namespace = mv_namespace.
    lo_clone->mv_value     = mv_value.

    DO mi_attributes->get_length( ) TIMES.
      lv_index = sy-index.
      li_attr = mi_attributes->get_item( lv_index ).

      CREATE OBJECT lo_attr.
      lo_attr->mv_name  = li_attr->get_name( ).
      lo_attr->mv_value = li_attr->get_value( ).
      lo_clone->mi_attributes->set_named_item_ns( lo_attr ).
    ENDDO.

    li_iter = mo_children->if_ixml_node_list~create_iterator( ).
    DO.
      li_child = li_iter->get_next( ).
      IF li_child IS INITIAL.
        EXIT.
      ENDIF.
      lo_clone->if_ixml_node~append_child( li_child->clone( ) ).
    ENDDO.

    rval = lo_clone.
  ENDMETHOD.

  METHOD if_ixml_node~create_iterator_filtered.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_column.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~create_filter_name_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_attribute_node_ns.
    val ?= attribute_node( iv_name = name
                           iv_uri  = uri ).
  ENDMETHOD.

  METHOD if_ixml_node~get_next.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA lv_found    TYPE abap_bool.

    IF mi_parent IS INITIAL.
      RETURN.
    ENDIF.

    li_iterator = mi_parent->get_children( )->create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        RETURN.
      ENDIF.

      IF lv_found = abap_true.
        rval = li_node.
        RETURN.
      ENDIF.

      IF li_node = me.
        lv_found = abap_true.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace_prefix.
    rv_prefix = mv_namespace.
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace_uri.
    rval = uri_of_prefix( mv_namespace ).
  ENDMETHOD.

  METHOD uri_of_prefix.
* the declaration that binds a prefix: "xmlns:<prefix>", or "xmlns" for the
* empty one. It may stand on this node or on any of its ancestors, the
* nearest one wins - and an undeclared prefix has no uri, which is initial
    DATA lv_name TYPE string.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA li_map  TYPE REF TO if_ixml_named_node_map.
    DATA li_attr TYPE REF TO if_ixml_node.

    IF iv_prefix IS INITIAL.
      lv_name = 'xmlns'.
    ELSE.
      CONCATENATE 'xmlns:' iv_prefix INTO lv_name.
    ENDIF.

    li_node = me.
    WHILE li_node IS BOUND.
      li_map = li_node->get_attributes( ).
      IF li_map IS BOUND.
        li_attr = li_map->get_named_item( lv_name ).
        IF li_attr IS BOUND.
          rv_uri = li_attr->get_value( ).
          RETURN.
        ENDIF.
      ENDIF.
      li_node = li_node->get_parent( ).
    ENDWHILE.
  ENDMETHOD.

  METHOD if_ixml_element~get_attributes.
    attr = if_ixml_node~get_attributes( ).
  ENDMETHOD.

  METHOD if_ixml_element~get_next.
    next ?= if_ixml_node~get_next( ).
  ENDMETHOD.

  METHOD if_ixml_element~get_name.
    name = mv_name.
  ENDMETHOD.

  METHOD if_ixml_element~append_child.
    DATA lo_node TYPE REF TO lcl_node.
    DATA new_parent TYPE REF TO lcl_node.
    lo_node ?= new_child.

    new_parent ?= lo_node->get_parent( ).
    IF new_parent IS NOT INITIAL.
      new_parent->if_ixml_node~remove_child( lo_node ).
    ENDIF.

    lo_node->set_parent( me ).

    mo_children->append( new_child ).
  ENDMETHOD.

  METHOD if_ixml_element~clone.
    val = if_ixml_node~clone( ).
  ENDMETHOD.

  METHOD if_ixml_element~create_filter_node_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~remove_attribute_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~create_iterator.
* the element itself, then everything below it in document order
    DATA lt_nodes TYPE lcl_node_iterator=>ty_list.

    collect_subtree( CHANGING ct_nodes = lt_nodes ).
    CREATE OBJECT val TYPE lcl_node_iterator
      EXPORTING
        it_list = lt_nodes.
  ENDMETHOD.

  METHOD collect_subtree.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA lo_node     TYPE REF TO lcl_node.

    APPEND me TO ct_nodes.
    li_iterator = mo_children->if_ixml_node_list~create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        EXIT. " current loop
      ENDIF.
      lo_node ?= li_node.
      lo_node->collect_subtree( CHANGING ct_nodes = ct_nodes ).
    ENDDO.
  ENDMETHOD.

  METHOD if_ixml_element~find_from_name_ns.

* todo: take importing parameter DEPTH into account
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA li_children TYPE REF TO if_ixml_node_list.
    DATA lt_nodes    TYPE STANDARD TABLE OF REF TO if_ixml_node WITH DEFAULT KEY.
    DATA li_top      LIKE LINE OF lt_nodes.

    APPEND me TO lt_nodes.

    LOOP AT lt_nodes INTO li_top.
      li_children = li_top->get_children( ).
      li_iterator = li_children->create_iterator( ).
      DO.
        li_node = li_iterator->get_next( ).
*        WRITE '@KERNEL console.dir("next");'.
        IF li_node IS INITIAL.
          EXIT. " current loop
        ENDIF.
*        WRITE '@KERNEL console.dir(li_node.value.mv_name);'.
*        WRITE '@KERNEL console.dir(name);'.
        IF li_node->get_name( ) = name.
          val ?= li_node.
          RETURN.
        ENDIF.
        APPEND li_node TO lt_nodes.
      ENDDO.
    ENDLOOP.

  ENDMETHOD.

  METHOD if_ixml_element~find_from_name.
    val = if_ixml_element~find_from_name_ns(
      name      = name
      depth     = depth
      namespace = namespace ).
  ENDMETHOD.

  METHOD if_ixml_element~get_attribute_node.
    val ?= attribute_node( name ).
  ENDMETHOD.

  METHOD if_ixml_element~get_attribute_ns.
    DATA li_node TYPE REF TO if_ixml_node.

    li_node = attribute_node( iv_name = name
                              iv_uri  = uri ).
    IF li_node IS NOT INITIAL.
      val = li_node->get_value( ).
    ENDIF.
  ENDMETHOD.

  METHOD attribute_node.
* without a uri the name is taken as it stands, prefix included. With one,
* the name is the local part and the prefix of the attribute has to resolve
* to that uri - an attribute without a prefix is in no namespace, a default
* declaration does not reach it
    DATA li_map    TYPE REF TO if_ixml_named_node_map.
    DATA li_node   TYPE REF TO if_ixml_node.
    DATA lv_name   TYPE string.
    DATA lv_prefix TYPE string.
    DATA lv_local  TYPE string.
    DATA lv_index  TYPE i.

    li_map = if_ixml_node~get_attributes( ).

    IF iv_uri IS INITIAL.
      ri_node = li_map->get_named_item_ns( iv_name ).
      RETURN.
    ENDIF.

    DO li_map->get_length( ) TIMES.
      lv_index = sy-index.
      li_node = li_map->get_item( lv_index ).
      lv_name = li_node->get_name( ).
      IF lv_name NS ':'.
        CONTINUE.
      ENDIF.

      SPLIT lv_name AT ':' INTO lv_prefix lv_local.
      IF lv_local = iv_name AND uri_of_prefix( lv_prefix ) = iv_uri.
        ri_node = li_node.
        RETURN.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD if_ixml_element~get_attribute.
    val = if_ixml_element~get_attribute_ns( name ).
  ENDMETHOD.

  METHOD if_ixml_element~get_children.
    val = if_ixml_node~get_children( ).
  ENDMETHOD.

  METHOD if_ixml_element~get_elements_by_tag_name.
    DATA lo_list TYPE REF TO lcl_node_list.
    CREATE OBJECT lo_list.
    collect_elements_by_tag_name(
      iv_name      = name
      iv_namespace = namespace
      io_list      = lo_list ).
    val = lo_list.
  ENDMETHOD.

  METHOD if_ixml_element~get_elements_by_tag_name_ns.
    DATA lo_list TYPE REF TO lcl_node_list.
    CREATE OBJECT lo_list.
    collect_elements_by_tag_name(
      iv_name      = name
      iv_namespace = uri
      io_list      = lo_list ).
    val = lo_list.
  ENDMETHOD.

  METHOD if_ixml_element~get_first_child.
    val = if_ixml_node~get_first_child( ).
  ENDMETHOD.

  METHOD if_ixml_element~get_value.
    val = if_ixml_node~get_value( ).
  ENDMETHOD.

  METHOD if_ixml_element~remove_attribute.
    if_ixml_node~get_attributes( )->remove_named_item( name ).
  ENDMETHOD.

  METHOD if_ixml_element~remove_node.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD has_direct_text.
    DATA li_children TYPE REF TO if_ixml_node_list.
    DATA li_child    TYPE REF TO if_ixml_node.

    rv_has = abap_false.
    IF mv_value IS NOT INITIAL.
      rv_has = abap_true.
      RETURN.
    ENDIF.

    li_children = if_ixml_node~get_children( ).
    IF li_children->get_length( ) <> 1.
      RETURN.
    ENDIF.

    li_child = li_children->get_item( 1 ).
    IF li_child->get_name( ) = '#text'.
      rv_has = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD collect_elements_by_tag_name.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA lo_node     TYPE REF TO lcl_node.
    DATA lv_matches  TYPE abap_bool.

    li_iterator = mo_children->if_ixml_node_list~create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        EXIT. " current loop
      ENDIF.

      IF li_node->get_name( ) <> '#text'.
        lv_matches = boolc( iv_name = '*' OR li_node->get_name( ) = iv_name ).
        IF lv_matches = abap_true
            AND ( iv_namespace IS INITIAL
              OR iv_namespace = '*'
              OR li_node->get_namespace( ) = iv_namespace ).
          io_list->append( li_node ).
        ENDIF.
      ENDIF.

      lo_node ?= li_node.
      lo_node->collect_elements_by_tag_name(
        iv_name      = iv_name
        iv_namespace = iv_namespace
        io_list      = io_list ).
    ENDDO.
  ENDMETHOD.

  METHOD if_ixml_element~render.
    DATA li_iterator   TYPE REF TO if_ixml_node_iterator.
    DATA li_node       TYPE REF TO if_ixml_node.
    DATA li_element    TYPE REF TO if_ixml_element.
    DATA li_children   TYPE REF TO if_ixml_node_list.
    DATA lv_attributes TYPE string.
    DATA lv_ns         TYPE string.


    li_iterator = mi_attributes->create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        EXIT. " current loop
      ENDIF.
      lv_ns = li_node->get_namespace_prefix( ).
      IF lv_ns IS NOT INITIAL.
        lv_ns = lv_ns && ':'.
      ENDIF.
      lv_attributes = lv_attributes && | | && lv_ns && li_node->get_name( ) &&
        '="' && lcl_escape=>escape_value( li_node->get_value( ) ) && '"'.
    ENDDO.

*    WRITE '@KERNEL console.dir(mv_namespace);'.
    CLEAR lv_ns.
    IF mv_namespace IS NOT INITIAL.
      lv_ns = mv_namespace && ':'.
    ENDIF.

    li_children = if_ixml_node~get_children( ).

    IF mv_name <> '#text' AND ostream->get_pretty_print( ) = abap_true.
      ostream->write_string( repeat( val = | |
                                     occ = ostream->get_indent( ) ) ).
    ENDIF.

    IF mv_name <> '#text'.
      ostream->write_string( '<' && lv_ns && mv_name && lv_attributes ).
      IF li_children->get_length( ) > 0 OR mv_value IS NOT INITIAL.
        ostream->write_string( '>' ).
      ENDIF.
    ENDIF.

    IF ostream->get_pretty_print( ) = abap_true AND if_ixml_node~is_leaf( ) = abap_false AND has_direct_text( ) = abap_false.
      ostream->write_string( |\n| ).
    ENDIF.

    ostream->set_indent( ostream->get_indent( ) + 1 ).
    li_iterator = li_children->create_iterator( ).
    DO.
      li_element ?= li_iterator->get_next( ).
      IF li_element IS INITIAL.
        EXIT. " current loop
      ENDIF.
      li_element->render( ostream ).
    ENDDO.
    ostream->set_indent( ostream->get_indent( ) - 1 ).

    IF li_children->get_length( ) > 0 OR mv_value IS NOT INITIAL.
      ostream->write_string( lcl_escape=>escape_value( mv_value ) ).
      IF mv_name <> '#text'.
        IF ostream->get_pretty_print( ) = abap_true AND has_direct_text( ) = abap_false.
          ostream->write_string( repeat( val = | |
                                         occ = ostream->get_indent( ) ) ).
        ENDIF.
        ostream->write_string( '</' && lv_ns && mv_name && '>' ).
      ENDIF.
    ELSE.
      ostream->write_string( '/>' ).
    ENDIF.

    IF ostream->get_pretty_print( ) = abap_true AND mv_name <> '#text'.
      ostream->write_string( |\n| ).
    ENDIF.

  ENDMETHOD.

  METHOD if_ixml_element~set_attribute_node_ns.
    mi_attributes->set_named_item_ns( new_attr ).
  ENDMETHOD.

  METHOD if_ixml_element~set_attribute.
    if_ixml_element~set_attribute_ns(
      name  = name
      value = value ).
  ENDMETHOD.

  METHOD if_ixml_element~set_attribute_ns.
    DATA lo_node TYPE REF TO if_ixml_node.
    CREATE OBJECT lo_node TYPE lcl_node.
    lo_node->set_name( name ).
    lo_node->set_value( value ).
    lo_node->set_namespace_prefix( prefix ).
    mi_attributes->set_named_item_ns( lo_node ).
  ENDMETHOD.

  METHOD if_ixml_element~set_value.
    if_ixml_node~set_value( value ).
  ENDMETHOD.

  METHOD if_ixml_node~set_namespace_prefix.
    mv_namespace = val.
  ENDMETHOD.

  METHOD if_ixml_node~append_child.
    DATA lo_node TYPE REF TO lcl_node.
    lo_node ?= new_child.
    lo_node->mi_parent = me.

    mo_children->append( new_child ).
  ENDMETHOD.

  METHOD if_ixml_node~get_attributes.
    map = mi_attributes.
  ENDMETHOD.

  METHOD if_ixml_node~get_first_child.
    node = mo_children->if_ixml_node_list~get_item( 1 ).
  ENDMETHOD.

  METHOD if_ixml_node~get_children.
    val = mo_children.
  ENDMETHOD.

  METHOD if_ixml_node~query_interface.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~remove_node.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_parent.
    val = mi_parent.
  ENDMETHOD.

  METHOD if_ixml_node~replace_child.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_name.
    val = mv_name.
  ENDMETHOD.

  METHOD if_ixml_node~get_depth.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA lv_max      TYPE i.

    IF mo_children->if_ixml_node_list~get_length( ) = 0.
      val = 0.
    ELSE.
      li_iterator = mo_children->if_ixml_node_list~create_iterator( ).
      DO.
        li_node = li_iterator->get_next( ).
        IF li_node IS INITIAL.
          EXIT. " current loop
        ENDIF.
        IF li_node->get_depth( ) > lv_max.
          lv_max = li_node->get_depth( ).
        ENDIF.
      ENDDO.

      val = lv_max + 1.
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_node~is_leaf.
    val = boolc( mo_children->if_ixml_node_list~get_length( ) = 0 ).
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace.
    val = mv_namespace.
  ENDMETHOD.

  METHOD if_ixml_node~get_value.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA lv_max TYPE i.

    IF mo_children->if_ixml_node_list~get_length( ) = 0.
      val = mv_value.
    ELSE.
      li_iterator = mo_children->if_ixml_node_list~create_iterator( ).
      DO.
        li_node = li_iterator->get_next( ).
        IF li_node IS INITIAL.
          EXIT. " current loop
        ENDIF.

        val = val && li_node->get_value( ).
      ENDDO.
    ENDIF.

  ENDMETHOD.

  METHOD if_ixml_node~get_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~set_name.
    mv_name = name.
  ENDMETHOD.

  METHOD if_ixml_node~remove_child.
    mo_children->remove( child ).
  ENDMETHOD.

  METHOD if_ixml_node~set_value.
    mv_value = value.
    CLEAR mo_children.
    CREATE OBJECT mo_children TYPE lcl_node_list.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_document DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_document.

    METHODS constructor.
  PRIVATE SECTION.
    DATA mi_node       TYPE REF TO lcl_node.
    DATA mv_standalone TYPE abap_bool.
ENDCLASS.

CLASS lcl_document IMPLEMENTATION.
  METHOD if_ixml_node~create_filter_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~create_filter_parent.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~num_children.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD constructor.
    CREATE OBJECT mi_node TYPE lcl_node.
    mi_node->if_ixml_node~set_name( '#document' ).
  ENDMETHOD.

  METHOD if_ixml_node~get_height.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_gid.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~insert_child.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~clone.
    rval = mi_node->if_ixml_node~clone( ).
  ENDMETHOD.

  METHOD if_ixml_node~create_iterator_filtered.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_column.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~create_filter_name_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace_prefix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_next.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace_uri.
    rval = mi_node->if_ixml_node~get_namespace_uri( ).
  ENDMETHOD.

  METHOD if_ixml_node~append_child.
    DATA lo_node TYPE REF TO lcl_node.
    lo_node ?= new_child.
    lo_node->set_parent( me ).

    mi_node->if_ixml_node~append_child( new_child ).
  ENDMETHOD.

  METHOD if_ixml_node~set_namespace_prefix.
    mi_node->if_ixml_node~set_namespace_prefix( val ).
  ENDMETHOD.

  METHOD if_ixml_node~get_attributes.
    map = mi_node->if_ixml_node~get_attributes( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_first_child.
    node = mi_node->if_ixml_node~get_first_child( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_children.
    val = mi_node->if_ixml_node~get_children( ).
  ENDMETHOD.

  METHOD if_ixml_node~query_interface.
    mi_node->if_ixml_node~query_interface( iid ).
  ENDMETHOD.

  METHOD if_ixml_node~remove_node.
    mi_node->if_ixml_node~remove_node( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_parent.
    val = mi_node->if_ixml_node~get_parent( ).
  ENDMETHOD.

  METHOD if_ixml_node~replace_child.
    mi_node->if_ixml_node~replace_child(
      new_child = new_child
      old_child = old_child ).
  ENDMETHOD.

  METHOD if_ixml_node~get_name.
    val = mi_node->if_ixml_node~get_name( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_depth.
    val = mi_node->if_ixml_node~get_depth( ).
  ENDMETHOD.

  METHOD if_ixml_node~is_leaf.
    val = mi_node->if_ixml_node~is_leaf( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace.
    val = mi_node->if_ixml_node~get_namespace( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_value.
    val = mi_node->if_ixml_node~get_value( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_type.
    val = mi_node->if_ixml_node~get_type( ).
  ENDMETHOD.

  METHOD if_ixml_node~set_name.
    mi_node->if_ixml_node~set_name( name ).
  ENDMETHOD.

  METHOD if_ixml_node~remove_child.
    mi_node->if_ixml_node~remove_child( child ).
  ENDMETHOD.

  METHOD if_ixml_node~set_value.
    mi_node->if_ixml_node~set_value( value ).
  ENDMETHOD.

  METHOD if_ixml_document~set_encoding.
* todo, something here?
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_document~set_standalone.
    mv_standalone = standalone.
  ENDMETHOD.

  METHOD if_ixml_document~get_standalone.
    rval = mv_standalone.
  ENDMETHOD.

  METHOD if_ixml_document~set_namespace_prefix.
* todo, should this do something?
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_document~append_child.
    if_ixml_node~append_child( new_child ).
  ENDMETHOD.

  METHOD if_ixml_document~get_first_child.
* skip whitespace #text nodes before the root element, they are not
* part of the document structure
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    li_iterator = mi_node->if_ixml_node~get_children( )->create_iterator( ).
    child = li_iterator->get_next( ).
    WHILE child IS NOT INITIAL AND child->get_name( ) = `#text`.
      child = li_iterator->get_next( ).
    ENDWHILE.
  ENDMETHOD.

  METHOD if_ixml_document~create_attribute_ns.
    CREATE OBJECT rval TYPE lcl_node.
    rval->if_ixml_node~set_name( name ).
    rval->if_ixml_node~set_namespace_prefix( prefix ).
  ENDMETHOD.

  METHOD if_ixml_document~create_element_ns.
    CREATE OBJECT element TYPE lcl_node.
    element->if_ixml_node~set_name( name ).
    element->if_ixml_node~set_namespace_prefix( prefix ).
  ENDMETHOD.

  METHOD if_ixml_document~create_element.
    CREATE OBJECT element TYPE lcl_node.
    element->if_ixml_node~set_name( name ).
  ENDMETHOD.

  METHOD if_ixml_document~create_iterator_filtered.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~set_declaration.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_filter_and.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_iterator.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_filter_node_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_simple_element_ns.
    DATA li_node TYPE REF TO if_ixml_node.
    val = if_ixml_document~create_simple_element(
      name   = name
      parent = parent ).
    li_node ?= val.
    li_node->set_namespace_prefix( prefix ).
  ENDMETHOD.

  METHOD if_ixml_document~create_filter_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_simple_element.
    CREATE OBJECT val TYPE lcl_node
      EXPORTING
        ii_parent = parent.
    val->if_ixml_node~set_name( name ).
    val->if_ixml_node~set_value( value ).
  ENDMETHOD.

  METHOD if_ixml_document~find_from_name.
    element = mi_node->if_ixml_element~find_from_name_ns(
      name      = name
      depth     = depth
      namespace = namespace ).
  ENDMETHOD.

  METHOD if_ixml_document~find_from_name_ns.
    element = mi_node->if_ixml_element~find_from_name_ns(
      name      = name
      depth     = depth
      namespace = '' ).
  ENDMETHOD.

  METHOD if_ixml_document~find_from_path.
    DATA lt_names    TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lv_name     TYPE string.
    DATA lv_found    TYPE abap_bool.
    DATA li_current  TYPE REF TO if_ixml_node.
    DATA li_children TYPE REF TO if_ixml_node_list.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node     TYPE REF TO if_ixml_node.

    li_current = mi_node.

    SPLIT path AT '/' INTO TABLE lt_names.

    LOOP AT lt_names INTO lv_name.
      IF lv_name IS INITIAL.
        CONTINUE.
      ENDIF.

      lv_found = abap_false.
      li_children = li_current->get_children( ).
      li_iterator = li_children->create_iterator( ).
      DO.
        li_node = li_iterator->get_next( ).
        IF li_node IS INITIAL.
          EXIT. " current loop
        ENDIF.
        IF li_node->get_name( ) = lv_name.
          li_current = li_node.
          lv_found = abap_true.
          EXIT. " current loop
        ENDIF.
      ENDDO.

      IF lv_found = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    IF lv_found = abap_true.
      val ?= li_current.
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_document~get_elements_by_tag_name_ns.
    DATA lv_namespace TYPE string.
    lv_namespace = uri.
    IF lv_namespace IS INITIAL.
      lv_namespace = namespace.
    ENDIF.

    val = mi_node->if_ixml_element~get_elements_by_tag_name_ns(
      name = name
      uri  = lv_namespace ).
  ENDMETHOD.

  METHOD if_ixml_document~get_elements_by_tag_name.
    val = mi_node->if_ixml_element~get_elements_by_tag_name(
      name      = name
      namespace = namespace ).
  ENDMETHOD.

  METHOD if_ixml_document~get_root.
    node = mi_node.
  ENDMETHOD.

  METHOD if_ixml_document~get_root_element.
    root ?= if_ixml_document~get_first_child( ).
  ENDMETHOD.

  METHOD if_ixml_document~create_text.
    CREATE OBJECT rval TYPE lcl_node.
    rval->if_ixml_node~set_name( '#text' ).
    rval->if_ixml_node~set_value( string ).
  ENDMETHOD.

ENDCLASS.

****************************************************************

CLASS lcl_ostream DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_ostream.
    DATA mv_string       TYPE string.
    DATA mv_hex          TYPE abap_bool.
    DATA mv_pretty_print TYPE abap_bool.
    DATA mv_indent       TYPE i.
ENDCLASS.

****************************************************************

CLASS lcl_renderer DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_renderer.
    METHODS constructor
      IMPORTING
        ostream  TYPE REF TO if_ixml_ostream
        document TYPE REF TO if_ixml_document.
  PRIVATE SECTION.
    DATA mi_ostream  TYPE REF TO if_ixml_ostream.
    DATA mi_document TYPE REF TO if_ixml_document.
ENDCLASS.

CLASS lcl_renderer IMPLEMENTATION.
  METHOD constructor.
    mi_ostream = ostream.
    mi_document = document.
  ENDMETHOD.

  METHOD if_ixml_renderer~render.
    DATA li_root       TYPE REF TO if_ixml_element.
    DATA lv_standalone TYPE string.
    DATA lo_stream     TYPE REF TO lcl_ostream.

    IF mi_document->get_standalone( ) = abap_true.
      lv_standalone = | standalone="yes"|.
    ENDIF.

    lo_stream ?= mi_ostream.
    IF lo_stream->mv_hex = abap_true.
      mi_ostream->write_string( |<?xml version="1.0" encoding="utf-8"{ lv_standalone }?>| ).
    ELSE.
      mi_ostream->write_string( |<?xml version="1.0" encoding="utf-16"{ lv_standalone }?>| ).
    ENDIF.
    IF lo_stream->mv_pretty_print = abap_true.
      mi_ostream->write_string( |\n| ).
    ENDIF.

    li_root = mi_document->get_root_element( ).
    IF li_root IS INITIAL.
      RETURN.
    ENDIF.

    li_root->render( mi_ostream ).

  ENDMETHOD.

  METHOD if_ixml_renderer~set_normalizing.
    mi_ostream->set_pretty_print( normal ).
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_ostream IMPLEMENTATION.
  METHOD if_ixml_ostream~write_string.
    DATA lo_obj  TYPE REF TO cl_abap_conv_out_ce.
    DATA lv_xstr TYPE xstring.

    IF mv_hex = abap_true.
      cl_abap_conv_out_ce=>create( )->convert(
        EXPORTING
          data   = string
          n      = strlen( string )
        IMPORTING
          buffer = lv_xstr ).
      mv_string = mv_string && lv_xstr.
    ELSE.
      mv_string = mv_string && string.
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_ostream~set_pretty_print.
    mv_pretty_print = pretty_print.
  ENDMETHOD.

  METHOD if_ixml_ostream~get_pretty_print.
    rval = mv_pretty_print.
  ENDMETHOD.

  METHOD if_ixml_ostream~set_indent.
    mv_indent = indent.
  ENDMETHOD.

  METHOD if_ixml_ostream~get_indent.
    rval = mv_indent.
  ENDMETHOD.

  METHOD if_ixml_ostream~set_encoding.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_ostream~get_encoding.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_ostream~get_num_written_raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_istream DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_istream.
    METHODS constructor IMPORTING iv_xml TYPE string.
    DATA mv_xml TYPE string.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_istream IMPLEMENTATION.
  METHOD if_ixml_stream~get_encoding.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD constructor.
    mv_xml = iv_xml.
  ENDMETHOD.

  METHOD if_ixml_istream~close.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_istream~set_dtd_restriction.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_istream~get_dtd_restriction.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_stream_factory DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_stream_factory.
ENDCLASS.

CLASS lcl_stream_factory IMPLEMENTATION.
  METHOD if_ixml_stream_factory~create_ostream_uri.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_ostream_itable.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_istream_cstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_ostream_cstring.
    CREATE OBJECT stream TYPE lcl_ostream.
* hack, this method doesnt really follow normal ABAP semantics
    WRITE '@KERNEL stream.get().mv_string = INPUT.string;'.
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_ostream_xstring.
    DATA lo_stream TYPE REF TO lcl_ostream.
    CREATE OBJECT lo_stream TYPE lcl_ostream.
    stream = lo_stream.
    lo_stream->mv_hex = abap_true.
* hack, this method doesnt really follow normal ABAP semantics
    WRITE '@KERNEL stream.get().mv_string = INPUT.string;'.
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_istream_xstring.
    CREATE OBJECT stream TYPE lcl_istream
      EXPORTING
        iv_xml = cl_abap_codepage=>convert_from( string ).
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_istream_string.
    CREATE OBJECT stream TYPE lcl_istream
      EXPORTING
        iv_xml = string.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_parser DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_parser.
    METHODS constructor
      IMPORTING
        istream  TYPE REF TO if_ixml_istream
        document TYPE REF TO if_ixml_document.
  PRIVATE SECTION.
* an attribute value is anything up to the closing quote, it may be empty
    CONSTANTS lc_regex_tag  TYPE string
      VALUE '<\/?([\w:.\-]+)(\s+[\w:.\-]+\s*=\s*("[^"]*"|''[^'']*''))*\s*\/?>'.
    CONSTANTS lc_regex_attr TYPE string
      VALUE '([\w:.\-]+)\s*=\s*(?:"([^"]*)"|''([^'']*)'')'.
* the length of "<![CDATA[", what stands before the content of a section
    CONSTANTS c_cdata_length TYPE i VALUE 9.

    DATA mi_istream  TYPE REF TO if_ixml_istream.
    DATA mi_document TYPE REF TO if_ixml_document.

    METHODS parse_attributes
      IMPORTING
        ii_node  TYPE REF TO if_ixml_node
        iv_xml   TYPE string
        is_match TYPE match_result.
ENDCLASS.

CLASS lcl_parser IMPLEMENTATION.
  METHOD constructor.
    mi_istream = istream.
    mi_document = document.
  ENDMETHOD.

  METHOD if_ixml_parser~set_validating.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_parser~parse.

    DATA lv_xml        TYPE string.
    DATA lv_rest       TYPE string.
    DATA lv_whitespace TYPE string.
    DATA lv_in_element TYPE abap_bool.
    DATA lv_bom        TYPE c LENGTH 1.
    DATA lv_offset    TYPE i.
    DATA lv_subset    TYPE i.
    DATA lv_length    TYPE i.
    DATA lv_value     TYPE string.
    DATA lv_name      TYPE string.
    DATA lv_namespace TYPE string.
    DATA lv_tag       TYPE string.
    DATA ls_match     TYPE match_result.
    DATA ls_submatch  LIKE LINE OF ls_match-submatches.
    DATA stream LIKE mi_istream.

    DATA lo_parent TYPE REF TO lcl_node.
    DATA lo_node   TYPE REF TO lcl_node.


    lo_parent ?= mi_document->get_root( ).

* get the private value from istream,
    stream = mi_istream.
    WRITE '@KERNEL lv_xml.set(stream.get().mv_xml);'.

    lv_whitespace = cl_abap_char_utilities=>get_simple_spaces_for_cur_cp( ).

* strip the byte order mark, it is not part of the document
    lv_bom = cl_abap_conv_in_ce=>uccpi( 65279 ).
    IF lv_xml IS NOT INITIAL AND lv_xml(1) = lv_bom.
      lv_xml = lv_xml+1.
    ENDIF.

* newline handling: whitespace between tags is skipped below, a LF inside a value is kept

    WHILE lv_xml IS NOT INITIAL.
      CLEAR lo_node.

      IF lv_xml CP '<?*'.
* the xml declaration and every other processing instruction, both carry
* no content of the document and end at "?>"
        FIND FIRST OCCURRENCE OF '?>' IN lv_xml MATCH OFFSET lv_offset.
        ASSERT lv_offset > 0.
        lv_offset = lv_offset + 2.
        lv_in_element = abap_false.
      ELSEIF lv_xml CP '<!DOCTYPE*'.
* the document type declaration, skipped as a whole. With an internal
* subset it ends at "]>", the ">" of the subset is not its own
        FIND FIRST OCCURRENCE OF '>' IN lv_xml MATCH OFFSET lv_offset.
        ASSERT sy-subrc = 0.
        FIND FIRST OCCURRENCE OF '[' IN lv_xml MATCH OFFSET lv_subset.
        IF sy-subrc = 0 AND lv_subset < lv_offset.
          FIND FIRST OCCURRENCE OF ']>' IN lv_xml MATCH OFFSET lv_offset.
          ASSERT sy-subrc = 0.
          lv_offset = lv_offset + 2.
        ELSE.
          lv_offset = lv_offset + 1.
        ENDIF.
        lv_in_element = abap_false.
      ELSEIF lv_xml CP '<![CDATA[*'.
* a CDATA section is character data, taken as it stands up to "]]>" - the
* markup it contains is text and nothing in it is unescaped
        FIND FIRST OCCURRENCE OF ']]>' IN lv_xml MATCH OFFSET lv_offset.
        ASSERT sy-subrc = 0.
        lv_length = lv_offset - c_cdata_length.
        lv_value = lv_xml+c_cdata_length.
        lv_value = lv_value(lv_length).

        CREATE OBJECT lo_node EXPORTING ii_parent = lo_parent.
        lo_node->if_ixml_node~set_name( '#text' ).
        lo_node->if_ixml_node~set_value( lv_value ).

        lv_offset = lv_offset + 3.
        lv_in_element = abap_false.
      ELSEIF lv_xml CP '<!--*'.
* a comment carries no content, it is skipped as a whole - what stands
* inside it is text and is never read as markup
        FIND FIRST OCCURRENCE OF '-->' IN lv_xml MATCH OFFSET lv_offset.
        ASSERT sy-subrc = 0.
        lv_offset = lv_offset + 3.
        lv_in_element = abap_false.
      ELSEIF lv_xml CP '<*'.
* start or close tag
        FIND FIRST OCCURRENCE OF REGEX lc_regex_tag IN lv_xml RESULTS ls_match.
        ASSERT ls_match-offset = 0.
        lv_tag = lv_xml(ls_match-length).

        READ TABLE ls_match-submatches INDEX 1 INTO ls_submatch.
        ASSERT sy-subrc = 0.
        lv_name = lv_xml+ls_submatch-offset(ls_submatch-length).

        IF lv_xml CP '</*'.
* todo: check its the right name
          lo_parent ?= lo_parent->if_ixml_node~get_parent( ).
          lv_in_element = abap_false.
        ELSE.
          CREATE OBJECT lo_node EXPORTING ii_parent = lo_parent.
          IF lv_name CA ':'.
            SPLIT lv_name AT ':' INTO lv_namespace lv_name.
            lo_node->if_ixml_node~set_namespace_prefix( lv_namespace ).
          ENDIF.
          lo_node->if_ixml_node~set_name( lv_name ).

          IF lv_tag NP '*/>'.
            lo_parent = lo_node.
            lv_in_element = abap_true.
          ELSE.
            lv_in_element = abap_false.
          ENDIF.
        ENDIF.

        parse_attributes(
          ii_node  = lo_node
          iv_xml   = lv_xml
          is_match = ls_match ).

        lv_offset = ls_match-length.

        " IF lv_xml CP '*/>'.
        "   lo_parent ?= lo_parent->if_ixml_node~get_parent( ).
        " ENDIF.
      ELSE.
* value
        FIND FIRST OCCURRENCE OF '<' IN lv_xml MATCH OFFSET lv_offset.
        IF sy-subrc <> 0.
* the document ends in character data. Without this the offset of the
* previous match stands, which reads beyond the end or, when there was no
* match yet, leaves the loop where it is and it never terminates
          lv_offset = strlen( lv_xml ).
        ENDIF.
        lv_value = lv_xml(lv_offset).
        CREATE OBJECT lo_node EXPORTING ii_parent = lo_parent.
        lo_node->if_ixml_node~set_name( '#text' ).
        lo_node->if_ixml_node~set_value( lcl_escape=>unescape_value( lv_value ) ).
        lv_in_element = abap_false.
      ENDIF.

      lv_xml = lv_xml+lv_offset.

* skip whitespace between tags, but never touch text content: CONDENSE
* also removed leading blanks of a value and collapsed blanks inside it,
* so `<t xml:space="preserve">A  B</t>` lost characters
      lv_rest = lv_xml.
      SHIFT lv_rest LEFT DELETING LEADING lv_whitespace.
      IF lv_rest IS INITIAL OR lv_rest(1) = '<'.
* whitespace that stands between a start tag and its own end tag is the
* content of that element, `<FIELD> </FIELD>` carries a single blank, so it
* is left for the value branch below - everything else is formatting
        IF lv_in_element = abap_true AND lv_rest CP '</*' AND lv_rest <> lv_xml.
          lv_in_element = abap_false.
        ELSE.
          lv_xml = lv_rest.
        ENDIF.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.

  METHOD parse_attributes.

    DATA ls_submatch LIKE LINE OF is_match-submatches.
    DATA lv_name     TYPE string.
    DATA lv_value    TYPE string.
    DATA lv_dquoted  TYPE string.
    DATA lv_squoted  TYPE string.
    DATA lv_xml      TYPE string.
    DATA li_node     TYPE REF TO if_ixml_node.
    DATA lv_offset   TYPE i.
    DATA lv_length   TYPE i.

    IF lines( is_match-submatches ) = 1.
      RETURN.
    ENDIF.

    lv_xml = iv_xml(is_match-length).

    DO.
      FIND FIRST OCCURRENCE OF REGEX lc_regex_attr IN lv_xml
        MATCH OFFSET lv_offset
        MATCH LENGTH lv_length
        SUBMATCHES lv_name lv_dquoted lv_squoted.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

* the value is quoted with either character, only one of the two matches
      IF lv_dquoted IS INITIAL.
        lv_value = lv_squoted.
      ELSE.
        lv_value = lv_dquoted.
      ENDIF.

      CREATE OBJECT li_node TYPE lcl_node.
      li_node->set_name( lv_name ).
      li_node->set_value( lcl_escape=>unescape_value( lv_value ) ).
      ii_node->get_attributes( )->set_named_item_ns( li_node ).

      lv_offset = lv_offset + lv_length.
      lv_xml = lv_xml+lv_offset.
    ENDDO.

  ENDMETHOD.

  METHOD if_ixml_parser~set_normalizing.
    RETURN. " todo
  ENDMETHOD.

  METHOD if_ixml_parser~num_errors.
    RETURN. " todo
  ENDMETHOD.

  METHOD if_ixml_parser~add_strip_space_element.
    RETURN. " todo
  ENDMETHOD.

  METHOD if_ixml_parser~get_error.
    RETURN. " todo
  ENDMETHOD.
ENDCLASS.
