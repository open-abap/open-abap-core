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
ENDCLASS.

****************************************************************

CLASS lcl_named_node_map DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_named_node_map.
  PRIVATE SECTION.
    DATA mt_list TYPE STANDARD TABLE OF REF TO if_ixml_node WITH DEFAULT KEY.
ENDCLASS.

CLASS lcl_named_node_map IMPLEMENTATION.
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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_named_node_map~remove_named_item.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_named_node_map~set_named_item_ns.
    APPEND node TO mt_list.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_node_list DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_node_list.
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
ENDCLASS.

****************************************************************

CLASS lcl_node DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_element.
    METHODS constructor
      IMPORTING
        ii_parent TYPE REF TO if_ixml_node OPTIONAL.

  PRIVATE SECTION.
    DATA mv_name       TYPE string.
    DATA mv_namespace  TYPE string.
    DATA mv_value      TYPE string.

    DATA mo_children   TYPE REF TO lcl_node_list.
    DATA mi_parent     TYPE REF TO if_ixml_node.
    DATA mi_attributes TYPE REF TO if_ixml_named_node_map.
ENDCLASS.

CLASS lcl_node IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT mo_children TYPE lcl_node_list.
    CREATE OBJECT mi_attributes TYPE lcl_named_node_map.
    mi_parent = ii_parent.

    IF mi_parent IS NOT INITIAL.
      ii_parent->append_child( me ).
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_element~get_attribute_node_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace_prefix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace_uri.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_attributes.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_next.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~append_child.
    DATA lo_node TYPE REF TO lcl_node.
    lo_node ?= new_child.
    lo_node->mi_parent = me.

    mo_children->append( new_child ).
  ENDMETHOD.

  METHOD if_ixml_element~clone.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~create_filter_node_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~remove_attribute_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~create_iterator.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~find_from_name_ns.

* todo: take importing parameter DEPTH into account
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA li_children TYPE REF TO if_ixml_node_list.
    DATA lt_nodes TYPE STANDARD TABLE OF REF TO if_ixml_node WITH DEFAULT KEY.
    DATA li_top LIKE LINE OF lt_nodes.

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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_attribute_node.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_attribute_ns.
    DATA li_node TYPE REF TO if_ixml_node.
    li_node = if_ixml_node~get_attributes( )->get_named_item_ns( name ).
    IF li_node IS NOT INITIAL.
      val = li_node->get_value( ).
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_element~get_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_children.
    val = if_ixml_node~get_children( ).
  ENDMETHOD.

  METHOD if_ixml_element~get_elements_by_tag_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_elements_by_tag_name_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~get_first_child.
    val = if_ixml_node~get_first_child( ).
  ENDMETHOD.

  METHOD if_ixml_element~get_value.
    val = if_ixml_node~get_value( ).
  ENDMETHOD.

  METHOD if_ixml_element~remove_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~remove_node.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~render.
    DATA li_iterator   TYPE REF TO if_ixml_node_iterator.
    DATA li_node       TYPE REF TO if_ixml_node.
    DATA li_element    TYPE REF TO if_ixml_element.
    DATA lv_attributes TYPE string.
    DATA lv_ns         TYPE string.

    li_iterator = mi_attributes->create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        EXIT. " current loop
      ENDIF.
      lv_attributes = lv_attributes && | | && li_node->get_name( ) && '="' && li_node->get_value( ) && '"'.
    ENDDO.

*    WRITE '@KERNEL console.dir(mv_namespace);'.
    IF mv_namespace IS NOT INITIAL.
      lv_ns = mv_namespace && ':'.
    ENDIF.

    ostream->write_string( '<' && lv_ns && mv_name && lv_attributes ).
    IF if_ixml_node~get_children( )->get_length( ) > 0 OR mv_value IS NOT INITIAL.
      ostream->write_string( '>' ).
    ENDIF.

    li_iterator = if_ixml_node~get_children( )->create_iterator( ).
    DO.
      li_element ?= li_iterator->get_next( ).
      IF li_element IS INITIAL.
        EXIT. " current loop
      ENDIF.
      li_element->render( ostream ).
    ENDDO.

    IF if_ixml_node~get_children( )->get_length( ) > 0 OR mv_value IS NOT INITIAL.
      ostream->write_string( mv_value && '</' && lv_ns && mv_name && '>' ).
    ELSE.
      ostream->write_string( '/>' ).
    ENDIF.
  ENDMETHOD.

  METHOD if_ixml_element~set_attribute_node_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~set_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_element~set_attribute_ns.
    DATA lo_node TYPE REF TO if_ixml_node.
    CREATE OBJECT lo_node TYPE lcl_node.
    lo_node->set_name( name ).
    lo_node->set_value( value ).
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
    DATA li_node TYPE REF TO if_ixml_node.
    DATA lv_max TYPE i.

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
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_document DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_document.
    METHODS constructor.
  PRIVATE SECTION.
    DATA mi_node TYPE REF TO lcl_node.
ENDCLASS.

CLASS lcl_document IMPLEMENTATION.

  METHOD constructor.
    CREATE OBJECT mi_node TYPE lcl_node.
    mi_node->if_ixml_node~set_name( '#document' ).
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace_prefix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace_uri.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_node~append_child.
    DATA lo_node TYPE REF TO lcl_node.
    lo_node ?= new_child.
    lo_node->mi_parent = me.

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
    mi_node->if_ixml_node~query_interface( foo ).
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
* todo, something here?
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_document~set_namespace_prefix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~append_child.
    if_ixml_node~append_child( new_child ).
  ENDMETHOD.

  METHOD if_ixml_document~get_first_child.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_attribute_ns.
    ASSERT 1 = 'todo'.
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
      EXPORTING ii_parent = parent.
    val->if_ixml_node~set_name( name ).
  ENDMETHOD.

  METHOD if_ixml_document~find_from_name.
    ASSERT 1 = 'todo, use find_from_name_ns instead'.
  ENDMETHOD.

  METHOD if_ixml_document~find_from_name_ns.
    element = mi_node->if_ixml_element~find_from_name_ns(
      name      = name
      depth     = depth
      namespace = '' ).
  ENDMETHOD.

  METHOD if_ixml_document~find_from_path.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~get_elements_by_tag_name_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~get_elements_by_tag_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~get_root.
    node = mi_node.
  ENDMETHOD.

  METHOD if_ixml_document~get_root_element.
    root = mi_node.
  ENDMETHOD.

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
    DATA mi_ostream TYPE REF TO if_ixml_ostream.
    DATA mi_document TYPE REF TO if_ixml_document.
ENDCLASS.

CLASS lcl_renderer IMPLEMENTATION.
  METHOD constructor.
    mi_ostream = ostream.
    mi_document = document.
  ENDMETHOD.

  METHOD if_ixml_renderer~render.
    DATA li_root     TYPE REF TO if_ixml_element.
    DATA li_element  TYPE REF TO if_ixml_element.
    DATA li_children TYPE REF TO if_ixml_node_list.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.

    li_root = mi_document->get_root_element( ).

    li_children = li_root->get_children( ).
    li_iterator = li_children->create_iterator( ).
    DO.
      li_element ?= li_iterator->get_next( ).
      IF li_element IS INITIAL.
        EXIT. " current loop
      ENDIF.
      li_element->render( mi_ostream ).
    ENDDO.
  ENDMETHOD.

  METHOD if_ixml_renderer~set_normalizing.
    RETURN.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_ostream DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_ostream.
    DATA mv_string TYPE string.
ENDCLASS.

CLASS lcl_ostream IMPLEMENTATION.
  METHOD if_ixml_ostream~write_string.
    mv_string = mv_string && string.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_istream DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_istream.
    METHODS constructor IMPORTING iv_xml TYPE string.
  PRIVATE SECTION.
    DATA mv_xml TYPE string.
ENDCLASS.
CLASS lcl_istream IMPLEMENTATION.
  METHOD constructor.
    mv_xml = iv_xml.
  ENDMETHOD.

  METHOD if_ixml_istream~close.
    RETURN.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_stream_factory DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_stream_factory.
ENDCLASS.

CLASS lcl_stream_factory IMPLEMENTATION.
  METHOD if_ixml_stream_factory~create_ostream_cstring.
    CREATE OBJECT stream TYPE lcl_ostream.
* hack, this method doesnt really follow normal ABAP semantics
    WRITE '@KERNEL stream.get().mv_string = INPUT.string;'.
    stream->write_string( '<?xml version="1.0" encoding="utf-16"?>' ).
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_ostream_xstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_istream_xstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_stream_factory~create_istream_string.
    CREATE OBJECT stream TYPE lcl_istream
      EXPORTING
        iv_xml = xml.
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
    CONSTANTS lc_regex_tag TYPE string VALUE '<\/?([\w:]+)( [\w:]+="[\w\.:\/]+")*>'.
    CONSTANTS lc_regex_attr TYPE string VALUE '([\w:]+)="([\w\.:\/]+)"'.

    DATA mi_istream  TYPE REF TO if_ixml_istream.
    DATA mi_document TYPE REF TO if_ixml_document.
    METHODS parse_attributes
      IMPORTING
        ii_node TYPE REF TO if_ixml_node
        iv_xml TYPE string
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

    DATA lv_xml TYPE string.
    DATA lv_offset TYPE i.
    DATA lv_value TYPE string.
    DATA lv_name TYPE string.
    DATA lv_namespace TYPE string.
    DATA ls_match TYPE match_result.
    DATA ls_submatch LIKE LINE OF ls_match-submatches.

    DATA lo_parent TYPE REF TO lcl_node.
    DATA lo_node TYPE REF TO lcl_node.


    lo_parent ?= mi_document->get_root( ).

* get the private value from istream,
    WRITE '@KERNEL lv_xml.set(this.mi_istream.get().mv_xml);'.

    REPLACE ALL OCCURRENCES OF |\n| IN lv_xml WITH ||.

    WHILE lv_xml IS NOT INITIAL.
      CLEAR lo_node.

      IF lv_xml CP '<?xml *'.
* for now just skip the xml tag
        FIND FIRST OCCURRENCE OF '?>' IN lv_xml MATCH OFFSET lv_offset.
        ASSERT lv_offset > 0.
        lv_offset = lv_offset + 2.
      ELSEIF lv_xml CP '<*'.
* start or close tag
        FIND FIRST OCCURRENCE OF REGEX lc_regex_tag IN lv_xml RESULTS ls_match.
        ASSERT ls_match-offset = 0.

        READ TABLE ls_match-submatches INDEX 1 INTO ls_submatch.
        ASSERT sy-subrc = 0.
        lv_name = lv_xml+ls_submatch-offset(ls_submatch-length).

        IF lv_xml CP '</*'.
* todo: check its the right name
          lo_parent ?= lo_parent->if_ixml_node~get_parent( ).
        ELSE.
          CREATE OBJECT lo_node EXPORTING ii_parent = lo_parent.
          IF lv_name CA ':'.
            SPLIT lv_name AT ':' INTO lv_namespace lv_name.
            lo_node->if_ixml_node~set_namespace_prefix( lv_namespace ).
          ENDIF.
          lo_node->if_ixml_node~set_name( lv_name ).
          lo_parent = lo_node.
        ENDIF.

        parse_attributes(
          ii_node  = lo_node
          iv_xml   = lv_xml
          is_match = ls_match ).

        lv_offset = ls_match-length.
      ELSE.
* value
        FIND FIRST OCCURRENCE OF '<' IN lv_xml MATCH OFFSET lv_offset.
        lv_value = lv_xml(lv_offset).

        CREATE OBJECT lo_node EXPORTING ii_parent = lo_parent.
        lo_node->if_ixml_node~set_name( '#text' ).
        lo_node->if_ixml_node~set_value( lv_value ).
      ENDIF.

      lv_xml = lv_xml+lv_offset.
      CONDENSE lv_xml.
    ENDWHILE.

  ENDMETHOD.

  METHOD parse_attributes.

    DATA ls_submatch LIKE LINE OF is_match-submatches.
    DATA lv_name TYPE string.
    DATA lv_value TYPE string.
    DATA lv_xml TYPE string.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA lv_offset TYPE i.
    DATA lv_length TYPE i.

    IF lines( is_match-submatches ) = 1.
      RETURN.
    ENDIF.

    lv_xml = iv_xml(is_match-length).

    DO.
      FIND FIRST OCCURRENCE OF REGEX lc_regex_attr IN lv_xml
        MATCH OFFSET lv_offset
        MATCH LENGTH lv_length
        SUBMATCHES lv_name lv_value.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      CREATE OBJECT li_node TYPE lcl_node.
      li_node->set_name( lv_name ).
      li_node->set_value( lv_value ).
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