CLASS lcl_document DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_document.
ENDCLASS.
CLASS lcl_document IMPLEMENTATION.
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

CLASS lcl_ostream DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_ostream.
ENDCLASS.
CLASS lcl_ostream IMPLEMENTATION.
ENDCLASS.

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
    ASSERT 2 = 'todo'.
  ENDMETHOD.
ENDCLASS.