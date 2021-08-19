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

CLASS lcl_named_node_map DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_named_node_map.
ENDCLASS.

CLASS lcl_named_node_map IMPLEMENTATION.
  METHOD if_ixml_named_node_map~create_iterator.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_named_node_map~get_length.
    RETURN. " todo
  ENDMETHOD.

  METHOD if_ixml_named_node_map~get_named_item_ns.
    RETURN. " todo
  ENDMETHOD.

  METHOD if_ixml_named_node_map~get_named_item.
    RETURN. " todo
  ENDMETHOD.
  
  METHOD if_ixml_named_node_map~remove_named_item.
    RETURN. " todo
  ENDMETHOD.

  METHOD if_ixml_named_node_map~set_named_item_ns.
    RETURN. " todo
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
    ASSERT NOT ii_node IS INITIAL.
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
    INTERFACES if_ixml_node.
    METHODS constructor
      IMPORTING ii_parent TYPE REF TO if_ixml_node OPTIONAL.

  PRIVATE SECTION.
    DATA mo_children TYPE REF TO lcl_node_list.
    DATA mv_name TYPE string.
    DATA mv_namespace TYPE string.
    DATA mv_value TYPE string.
    DATA mi_parent TYPE REF TO if_ixml_node.
    DATA mi_attributes TYPE REF TO if_ixml_named_node_map.
ENDCLASS.

CLASS lcl_node IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT mo_children TYPE lcl_node_list.
    CREATE OBJECT mi_attributes TYPE lcl_named_node_map.
    mi_parent = ii_parent.
  ENDMETHOD.

  METHOD if_ixml_node~set_namespace_prefix.
    mv_namespace = val.
  ENDMETHOD.

  METHOD if_ixml_node~append_child.
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
    DATA mi_node TYPE REF TO if_ixml_node.
ENDCLASS.
CLASS lcl_document IMPLEMENTATION.

  METHOD constructor.
    CREATE OBJECT mi_node TYPE lcl_node.
  ENDMETHOD.

  METHOD if_ixml_node~append_child.
    mi_node->append_child( new_child ).
  ENDMETHOD.

  METHOD if_ixml_node~set_namespace_prefix.
    mi_node->set_namespace_prefix( val ).
  ENDMETHOD.

  METHOD if_ixml_node~get_attributes.
    map = mi_node->get_attributes( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_first_child.
    node = mi_node->get_first_child( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_children.
    val = mi_node->get_children( ).
  ENDMETHOD.

  METHOD if_ixml_node~query_interface.
    mi_node->query_interface( foo ).
  ENDMETHOD.

  METHOD if_ixml_node~remove_node.
    mi_node->remove_node( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_parent.
    val = mi_node->get_parent( ).
  ENDMETHOD.

  METHOD if_ixml_node~replace_child.
    mi_node->replace_child(
      new_child = new_child 
      old_child = old_child ).
  ENDMETHOD.

  METHOD if_ixml_node~get_name.
    val = mi_node->get_name( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_depth.
    val = mi_node->get_depth( ).
  ENDMETHOD.

  METHOD if_ixml_node~is_leaf.
    val = mi_node->is_leaf( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace.
    val = mi_node->get_namespace( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_value.
    val = mi_node->get_value( ).
  ENDMETHOD.

  METHOD if_ixml_node~get_type.
    val = mi_node->get_type( ).
  ENDMETHOD.

  METHOD if_ixml_node~set_name.
    mi_node->set_name( name ).
  ENDMETHOD.

  METHOD if_ixml_node~remove_child.
    mi_node->remove_child( child ).
  ENDMETHOD.

  METHOD if_ixml_node~set_value.
    mi_node->set_value( value ).
  ENDMETHOD.

  METHOD if_ixml_document~set_encoding.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~set_standalone.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~set_namespace_prefix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~append_child.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~get_first_child.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_attribute_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_element_ns.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_element.
    ASSERT 1 = 'todo'.
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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_filter_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~create_simple_element.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~find_from_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~find_from_name_ns.
* todo: take importing parameter DEPTH into account
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA li_children TYPE REF TO if_ixml_node_list.
    
    li_children = mi_node->get_children( ).
    li_iterator = li_children->create_iterator( ).
    DO.
      li_node = li_iterator->get_next( ).
      IF li_node IS INITIAL.
        EXIT. " current loop
      ENDIF.
      IF li_node->get_name( ) = name.
        element = li_node.
        RETURN.
      ENDIF.
    ENDDO.
    
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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.

****************************************************************

CLASS lcl_renderer DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_renderer.
ENDCLASS.
CLASS lcl_renderer IMPLEMENTATION.
  METHOD if_ixml_renderer~render.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_renderer~set_normalizing.
    RETURN.
  ENDMETHOD.
ENDCLASS.

****************************************************************

CLASS lcl_ostream DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_ostream.
ENDCLASS.
CLASS lcl_ostream IMPLEMENTATION.
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
    WRITE '@KERNEL INPUT.xml.set(`<?xml version="1.0" encoding="utf-16"?>`);'.
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
    DATA mi_istream  TYPE REF TO if_ixml_istream.
    DATA mi_document TYPE REF TO if_ixml_document.
ENDCLASS.
CLASS lcl_parser IMPLEMENTATION.
  METHOD constructor.
    mi_istream = istream.
    mi_document = document.
  ENDMETHOD.

  METHOD if_ixml_parser~parse.

    CONSTANTS lc_regex_tag TYPE string VALUE '<\/?([\w:]+)( [\w:]+="[\w\.:\/]+")*>'.

    DATA lv_xml TYPE string.
    DATA lv_offset TYPE i.
    DATA lv_value TYPE string.
    DATA lv_name TYPE string.
    DATA lv_namespace TYPE string.
    DATA ls_match TYPE match_result.
    DATA ls_submatch LIKE LINE OF ls_match-submatches.

    DATA lo_parent TYPE REF TO lcl_node.
    DATA lo_node TYPE REF TO lcl_node.


    lo_parent = mi_document->get_root( ).

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
          lo_parent = lo_parent->if_ixml_node~get_parent( ).
        ELSE.
          CREATE OBJECT lo_node EXPORTING ii_parent = lo_parent.
          IF lv_name CA ':'.
            SPLIT lv_name AT ':' INTO lv_namespace lv_name.
            lo_node->if_ixml_node~set_namespace_prefix( lv_namespace ).
          ENDIF.
          lo_node->if_ixml_node~set_name( lv_name ).
          lo_parent->if_ixml_node~append_child( lo_node ).
          lo_parent = lo_node.
        ENDIF.

        lv_offset = ls_match-length.
      ELSE.
* value
        FIND FIRST OCCURRENCE OF '<' IN lv_xml MATCH OFFSET lv_offset.
        lv_value = lv_xml(lv_offset).

        CREATE OBJECT lo_node EXPORTING ii_parent = lo_parent.
        lo_node->if_ixml_node~set_name( '#text' ).
        lo_node->if_ixml_node~set_value( lv_value ).
        lo_parent->if_ixml_node~append_child( lo_node ).
      ENDIF.

      lv_xml = lv_xml+lv_offset.
      CONDENSE lv_xml.
    ENDWHILE.

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