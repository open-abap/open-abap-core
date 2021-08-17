CLASS lcl_document DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_document.
ENDCLASS.
CLASS lcl_document IMPLEMENTATION.

  METHOD if_ixml_node~append_child.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_attributes.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_first_child.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_children.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~query_interface.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~remove_node.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_parent.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~replace_child.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_name.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_depth.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~is_leaf.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_namespace.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_value.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~get_type.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~set_name.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~remove_child.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~append_child.
    RETURN.
  ENDMETHOD.

  METHOD if_ixml_node~set_value.
    RETURN.
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
    ASSERT 1 = 'todo'.
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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_ixml_document~get_root_element.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.

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
    DATA mv_istream  TYPE REF TO if_ixml_istream.
    DATA mv_document TYPE REF TO if_ixml_document.
ENDCLASS.
CLASS lcl_parser IMPLEMENTATION.
  METHOD constructor.
    mv_istream = istream.
    mv_document = document.
  ENDMETHOD.

  METHOD if_ixml_parser~parse.

    CONSTANTS lc_regex_tag TYPE string VALUE '<\/?(\w+)( \w+="[\w\.]+")*>'.

    DATA lv_xml TYPE string.
    DATA lv_offset TYPE i.
    DATA lv_value TYPE string.
    DATA lv_name TYPE string.
    DATA lt_stack TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA ls_match TYPE match_result.
    DATA ls_submatch LIKE LINE OF ls_match-submatches.

* this gets the private value from istream,    
    WRITE '@KERNEL lv_xml.set(this.mv_istream.get().mv_xml);'.
  
    REPLACE ALL OCCURRENCES OF |\n| IN lv_xml WITH ||.
  
    WHILE lv_xml IS NOT INITIAL.
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
          WRITE: / 'close:', lv_name.
        ELSE.
          WRITE: / 'open:', lv_name.
        ENDIF.

        lv_offset = ls_match-length.
      ELSE.
* value
        FIND FIRST OCCURRENCE OF '<' IN lv_xml MATCH OFFSET lv_offset.
        lv_value = lv_xml(lv_offset).
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