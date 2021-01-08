CLASS ltcl_xml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_xml IMPLEMENTATION.

  METHOD test1.

    " DATA li_doc           TYPE REF TO if_ixml_document.
    " DATA li_ostream       TYPE REF TO if_ixml_ostream.
    " DATA li_renderer      TYPE REF TO if_ixml_renderer.
    " DATA lv_xml           TYPE string.
    " DATA li_streamfactory TYPE REF TO if_ixml_stream_factory.
    " DATA li_ixml          TYPE REF TO if_ixml.

    " li_ixml = cl_ixml=>create( ).
    " li_doc = li_ixml->create_document( ).
    " li_streamfactory = li_ixml->create_stream_factory( ).
    " li_ostream = li_streamfactory->create_ostream_cstring( lv_xml ).
    " li_renderer = li_ixml->create_renderer(
    "   ostream  = li_ostream
    "   document = li_doc ).
    " li_renderer->render( ).

    " cl_abap_unit_assert=>assert_equals(
    "   act = lv_xml
    "   exp = '<?xml version="1.0" encoding="utf-16"?>' ).

  ENDMETHOD.

ENDCLASS.