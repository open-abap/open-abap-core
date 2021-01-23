CLASS lcl_document DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ixml_document.
ENDCLASS.
CLASS lcl_document IMPLEMENTATION.
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