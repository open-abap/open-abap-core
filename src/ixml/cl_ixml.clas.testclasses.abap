CLASS ltcl_xml DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS render_empty_output FOR TESTING RAISING cx_static_check.
    METHODS parse_basic FOR TESTING RAISING cx_static_check.
    METHODS testing FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_xml IMPLEMENTATION.

  METHOD testing.

    CONSTANTS lc_regex_tag TYPE string VALUE '<\/?(\w+)( \w+="[\w.]+")*>'.

    DATA lv_xml TYPE string.
    DATA lv_offset TYPE i.
    DATA lv_value TYPE string.
    DATA lv_name TYPE string.
    DATA lt_stack TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA ls_match TYPE match_result.
    DATA ls_submatch LIKE LINE OF ls_match-submatches.
  
    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<abapGit version="v1.0.0">\n| &&
      | <foo>blah</foo>\n| &&
      | <bar>moo</bar>\n| &&
      |</abapGit>|.
  
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
      | <foo>blah</foo>\n| &&
      | <bar>moo</bar>\n| &&
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

********************

    " li_element = li_xml_doc->find_from_name_ns(
    "   depth = 0
    "   name  = 'abapGit' ).

    " cl_abap_unit_assert=>assert_not_initial( li_element ).

  ENDMETHOD.

ENDCLASS.