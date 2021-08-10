CLASS ltcl_xml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS render_empty_output FOR TESTING RAISING cx_static_check.
    METHODS parse_basic FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_xml IMPLEMENTATION.

  METHOD render_empty_output.

    DATA li_doc      TYPE REF TO if_ixml_document.
    DATA li_ostream  TYPE REF TO if_ixml_ostream.
    DATA li_renderer TYPE REF TO if_ixml_renderer.
    DATA lv_xml      TYPE string.
    DATA li_factory  TYPE REF TO if_ixml_stream_factory.
    DATA li_ixml     TYPE REF TO if_ixml.

    li_ixml = cl_ixml=>create( ).
    li_doc = li_ixml->create_document( ).
    li_factory = li_ixml->create_stream_factory( ).
    li_ostream = li_factory->create_ostream_cstring( lv_xml ).
    li_renderer = li_ixml->create_renderer(
      ostream  = li_ostream
      document = li_doc ).
    li_renderer->render( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_xml
      exp = '<?xml version="1.0" encoding="utf-16"?>' ).

  ENDMETHOD.

  METHOD parse_basic.
    
    DATA li_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream TYPE REF TO if_ixml_istream.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_version TYPE REF TO if_ixml_node.
    DATA li_parser  TYPE REF TO if_ixml_parser.
    DATA li_ixml    TYPE REF TO if_ixml.
    DATA lv_xml     TYPE string.
    DATA lv_subrc   TYPE i.
    DATA li_xml_doc TYPE REF TO if_ixml_document.

    
    li_ixml    = cl_ixml=>create( ).
    li_xml_doc = li_ixml->create_document( ).

    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<abapGit version="v1.0.0">\n| &&
      | <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">\n| &&
      |  <asx:values>\n| &&
      |   <DATA>\n| &&
      |    <FOO>2</FOO>\n| &&
      |   </DATA>\n| &&
      |  </asx:values>\n| &&
      | </asx:abap>\n| &&
      |</abapGit>|.
    
    li_factory = li_ixml->create_stream_factory( ).
    li_istream = li_factory->create_istream_string( lv_xml ).
    li_parser = li_ixml->create_parser( stream_factory = li_factory
                                        istream        = li_istream
                                        document       = li_xml_doc ).
    li_parser->add_strip_space_element( ).
    lv_subrc = li_parser->parse( ).
    li_istream->close( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_subrc
      exp = 0 ).

  ENDMETHOD.

ENDCLASS.