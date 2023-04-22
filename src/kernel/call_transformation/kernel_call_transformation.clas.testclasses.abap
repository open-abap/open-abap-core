CLASS lcl_empty DEFINITION.
ENDCLASS.
CLASS lcl_empty IMPLEMENTATION.
ENDCLASS.

CLASS lcl_attribute DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    DATA foo TYPE i.
ENDCLASS.
CLASS lcl_attribute IMPLEMENTATION.
ENDCLASS.

CLASS ltcl_call_transformation DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1_xml FOR TESTING RAISING cx_static_check.
    METHODS test2_xml FOR TESTING RAISING cx_static_check.
    METHODS test3_xml FOR TESTING RAISING cx_static_check.
    METHODS test4_xml FOR TESTING RAISING cx_static_check.

    METHODS test1_json FOR TESTING RAISING cx_static_check.
    METHODS test2_json_fs FOR TESTING RAISING cx_static_check.
    METHODS test3_json_table FOR TESTING RAISING cx_static_check.
    METHODS test3_json_table_fs FOR TESTING RAISING cx_static_check.
    METHODS invalid_input FOR TESTING RAISING cx_static_check.
    METHODS empty_input FOR TESTING RAISING cx_static_check.
    METHODS parse_escaped_quotes FOR TESTING RAISING cx_static_check.
    METHODS to_string_simple FOR TESTING RAISING cx_static_check.
    METHODS to_string_empty FOR TESTING RAISING cx_static_check.
    METHODS to_string_array FOR TESTING RAISING cx_static_check.

    METHODS convert_json_to_sxml
      IMPORTING iv_json TYPE string
      RETURNING VALUE(rv_xml) TYPE string
      RAISING cx_static_check.

    METHODS json_to_sxml1 FOR TESTING RAISING cx_static_check.
    METHODS ref_to_xml FOR TESTING RAISING cx_static_check.
    METHODS empty_object_to_xml FOR TESTING RAISING cx_static_check.
    METHODS attr_object_to_xml FOR TESTING RAISING cx_static_check.
    METHODS empty_obj_in_structure FOR TESTING RAISING cx_static_check.
    METHODS obj_to_xml_to_obj FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_call_transformation IMPLEMENTATION.

  METHOD test4_xml.

    DATA lv_xml TYPE string.
    DATA: BEGIN OF rs_repo,
            empty TYPE string,
          END OF rs_repo.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?>| &&
      |<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0"><asx:values>| &&
      |<REPO><EMPTY/></REPO>| &&
      |</asx:values></asx:abap>|.

    CALL TRANSFORMATION id
      OPTIONS value_handling = 'accept_data_loss'
      SOURCE XML lv_xml
      RESULT repo = rs_repo.

  ENDMETHOD.

  METHOD test3_xml.
    DATA lv_xml TYPE string.
    DATA: BEGIN OF rs_repo,
            url         TYPE string,
            branch_name TYPE string,
          END OF rs_repo.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?><asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0"><asx:values>| &&
      |<REPO><URL>https://github.com/abapGit/abapGit</URL><BRANCH_NAME></BRANCH_NAME></REPO>| &&
      |</asx:values></asx:abap>|.

    CALL TRANSFORMATION id
      OPTIONS value_handling = 'accept_data_loss'
      SOURCE XML lv_xml
      RESULT repo = rs_repo.

    cl_abap_unit_assert=>assert_equals(
      act = rs_repo-url
      exp = 'https://github.com/abapGit/abapGit' ).
    cl_abap_unit_assert=>assert_equals(
      act = rs_repo-branch_name
      exp = '' ).
  ENDMETHOD.

  METHOD to_string_simple.
    DATA lv_actual TYPE string.
    DATA lv_expected TYPE string.
    DATA: BEGIN OF ls_xml,
            field TYPE i,
          END OF ls_xml.

    CALL TRANSFORMATION id
      SOURCE repo = ls_xml
      RESULT XML lv_actual.
* note the byte order mark,
    lv_expected = |*<?xml version="1.0" encoding="utf-16"?>| &&
      |<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">| &&
      |<asx:values><REPO><FIELD>0</FIELD></REPO></asx:values>| &&
      |</asx:abap>|.
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_actual
      exp = lv_expected ).
  ENDMETHOD.

  METHOD to_string_empty.
    DATA lv_actual   TYPE string.
    DATA lv_expected TYPE string.
    DATA: BEGIN OF ls_xml,
            field TYPE string,
          END OF ls_xml.

    CALL TRANSFORMATION id
      SOURCE repo = ls_xml
      RESULT XML lv_actual.

    lv_expected = |*<FIELD/>*|.
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_actual
      exp = lv_expected ).
  ENDMETHOD.

  METHOD to_string_array.
    DATA lv_actual TYPE string.
    DATA lv_expected TYPE string.
    DATA lt_xml TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    APPEND 'foo' TO lt_xml.
    CALL TRANSFORMATION id
      SOURCE table = lt_xml
      RESULT XML lv_actual.
* note the byte order mark,
    lv_expected = |*<?xml version="1.0" encoding="utf-16"?>| &&
      |<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">| &&
      |<asx:values><TABLE><item>foo</item></TABLE></asx:values>| &&
      |</asx:abap>|.
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_actual
      exp = lv_expected ).
  ENDMETHOD.

  METHOD parse_escaped_quotes.
    DATA lv_response TYPE string.
    DATA lv_foo      TYPE string.
    lv_response = '{"FOO": "\""}'.
    CALL TRANSFORMATION id
      SOURCE XML lv_response
      RESULT foo = lv_foo.
    cl_abap_unit_assert=>assert_equals(
      act = lv_foo
      exp = |"| ).
  ENDMETHOD.

  METHOD convert_json_to_sxml.
    DATA lo_writer TYPE REF TO cl_sxml_string_writer.
    lo_writer = cl_sxml_string_writer=>create( ).
    CALL TRANSFORMATION id SOURCE XML iv_json RESULT XML lo_writer.
    rv_xml = cl_abap_conv_codepage=>create_in( )->convert( lo_writer->get_output( ) ).
  ENDMETHOD.

  METHOD json_to_sxml1.
    DATA lv_xml TYPE string.
* todo
*    lv_xml = convert_json_to_sxml( '{}' ).
*    WRITE '@KERNEL console.dir(lv_xml.get());'.
*    cl_abap_unit_assert=>assert_equals(
*      act = lv_xml
*      exp = '<object/>' ).
  ENDMETHOD.

  METHOD test3_json_table.
    TYPES: BEGIN OF ty_message,
             field TYPE i,
             val TYPE string,
           END OF ty_message.
    DATA tab TYPE STANDARD TABLE OF ty_message WITH DEFAULT KEY.
    DATA row LIKE LINE OF tab.
    DATA lv_input TYPE string.
    lv_input = '{"DATA": [{"FIELD": 321, "VAL": "hello"}]}'.
    CALL TRANSFORMATION id SOURCE XML lv_input RESULT data = tab.
    cl_abap_unit_assert=>assert_equals(
      act = lines( tab )
      exp = 1 ).
    READ TABLE tab INDEX 1 INTO row.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = row-field
      exp = 321 ).
    cl_abap_unit_assert=>assert_equals(
      act = row-val
      exp = 'hello' ).
  ENDMETHOD.

  METHOD test3_json_table_fs.
    TYPES: BEGIN OF ty_message,
             field TYPE i,
           END OF ty_message.
    DATA tab TYPE STANDARD TABLE OF ty_message WITH DEFAULT KEY.
    DATA row LIKE LINE OF tab.
    FIELD-SYMBOLS <fs> TYPE any.
    DATA lv_input TYPE string.
    lv_input = '{"DATA": [{"FIELD": 321}]}'.
    ASSIGN tab TO <fs>.
    CALL TRANSFORMATION id SOURCE XML lv_input RESULT data = <fs>.
    cl_abap_unit_assert=>assert_equals(
      act = lines( tab )
      exp = 1 ).
    READ TABLE tab INDEX 1 INTO row.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = row-field
      exp = 321 ).
  ENDMETHOD.

  METHOD test2_json_fs.

    DATA: BEGIN OF ls_message,
            field TYPE i,
          END OF ls_message.
    FIELD-SYMBOLS <fs> LIKE ls_message.
    DATA lv_input TYPE string.
    lv_input = '{"DATA": {"FIELD": 321}}'.
    ASSIGN ls_message TO <fs>.

    CALL TRANSFORMATION id SOURCE XML lv_input RESULT data = <fs>.

    cl_abap_unit_assert=>assert_equals(
      act = <fs>-field
      exp = 321 ).

  ENDMETHOD.

  METHOD test1_json.

    DATA: BEGIN OF ls_message,
            field TYPE i,
          END OF ls_message.
    DATA lv_input TYPE string.
    lv_input = '{"DATA": {"FIELD": 321}}'.

    CALL TRANSFORMATION id SOURCE XML lv_input RESULT data = ls_message.

    cl_abap_unit_assert=>assert_equals(
      act = ls_message-field
      exp = 321 ).

  ENDMETHOD.

  METHOD empty_input.
    DATA ls_message TYPE i.
    DATA lv_input   TYPE string.
    lv_input = ''.
    TRY.
        CALL TRANSFORMATION id SOURCE XML lv_input RESULT data = ls_message.
      CATCH cx_xslt_runtime_error.
    ENDTRY.
  ENDMETHOD.

  METHOD invalid_input.
    DATA ls_message TYPE i.
    DATA lv_json    TYPE string.
    lv_json = 'invalid'.
    TRY.
        CALL TRANSFORMATION id SOURCE XML lv_json RESULT data = ls_message.
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xslt_format_error.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD test1_xml.
    DATA lv_xml TYPE string.
    DATA: BEGIN OF ls_foo,
            foo TYPE i,
          END OF ls_foo.

    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">\n| &&
      | <asx:values>\n| &&
      |  <DATA>\n| &&
      |   <FOO>2</FOO>\n| &&
      |  </DATA>\n| &&
      | </asx:values>\n| &&
      |</asx:abap>|.

    CALL TRANSFORMATION id SOURCE XML lv_xml RESULT data = ls_foo.

    cl_abap_unit_assert=>assert_equals(
      act = ls_foo-foo
      exp = 2 ).
  ENDMETHOD.

  METHOD test2_xml.

    DATA li_git            TYPE REF TO if_ixml_element.
    DATA li_abap           TYPE REF TO if_ixml_node.
    DATA li_stream_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream        TYPE REF TO if_ixml_istream.
    DATA li_element        TYPE REF TO if_ixml_element.
    DATA li_version        TYPE REF TO if_ixml_node.
    DATA li_parser         TYPE REF TO if_ixml_parser.
    DATA lv_xml            TYPE string.
    DATA mi_ixml           TYPE REF TO if_ixml.
    DATA mi_xml_doc        TYPE REF TO if_ixml_document.
    DATA lt_rtab           TYPE abap_trans_resbind_tab.
    FIELD-SYMBOLS <ls_rtab> LIKE LINE OF lt_rtab.

    DATA: BEGIN OF ls_data,
            foo TYPE i,
          END OF ls_data.

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

    mi_ixml     = cl_ixml=>create( ).
    mi_xml_doc  = mi_ixml->create_document( ).

    li_stream_factory = mi_ixml->create_stream_factory( ).
    li_istream = li_stream_factory->create_istream_string( lv_xml ).
    li_parser = mi_ixml->create_parser( stream_factory = li_stream_factory
                                        istream        = li_istream
                                        document       = mi_xml_doc ).
    li_parser->add_strip_space_element( ).
    cl_abap_unit_assert=>assert_equals(
      act = li_parser->parse( )
      exp = 0 ).
    li_istream->close( ).

* fix()
    li_git ?= mi_xml_doc->find_from_name_ns( depth = 0
                                             name = 'abapGit' ).
    li_abap = li_git->get_first_child( ).
    mi_xml_doc->get_root( )->remove_child( li_git ).
    mi_xml_doc->get_root( )->append_child( li_abap ).

* CALL TRANSFORMATION
    CALL TRANSFORMATION id
      OPTIONS value_handling = 'accept_data_loss'
      SOURCE XML mi_xml_doc
      RESULT data = ls_data.

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-foo
      exp = 2 ).

* via dynamic table
    CLEAR ls_data.
    APPEND INITIAL LINE TO lt_rtab ASSIGNING <ls_rtab>.
    <ls_rtab>-name = 'DATA'.
    GET REFERENCE OF ls_data INTO <ls_rtab>-value.

    CALL TRANSFORMATION id
      OPTIONS value_handling = 'accept_data_loss'
      SOURCE XML mi_xml_doc
      RESULT (lt_rtab).

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-foo
      exp = 2 ).
  ENDMETHOD.

  METHOD ref_to_xml.
    DATA result TYPE string.
    DATA ref    TYPE REF TO data.

    CALL TRANSFORMATION id
      SOURCE data = ref
      RESULT XML result.

    cl_abap_unit_assert=>assert_char_cp(
      act = result
      exp = '*<DATA/>*' ).
  ENDMETHOD.

  METHOD empty_object_to_xml.

    DATA lo     TYPE REF TO lcl_empty.
    DATA lv_xml TYPE string.

    CREATE OBJECT lo.

    CALL TRANSFORMATION id
      SOURCE data = lo
      RESULT XML lv_xml.

    cl_abap_unit_assert=>assert_text_matches(
      pattern = |<DATA href="#o|
      text    = lv_xml ).

    cl_abap_unit_assert=>assert_text_matches(
      pattern = |<prg:LCL_EMPTY |
      text    = lv_xml ).

    cl_abap_unit_assert=>assert_text_matches(
      pattern = |<asx:heap |
      text    = lv_xml ).

  ENDMETHOD.

  METHOD attr_object_to_xml.

    DATA lo     TYPE REF TO lcl_attribute.
    DATA lv_xml TYPE string.

    CREATE OBJECT lo.

    CALL TRANSFORMATION id
       SOURCE data = lo
       RESULT XML lv_xml.

    cl_abap_unit_assert=>assert_text_matches(
      pattern = |<DATA href="#o|
      text    = lv_xml ).

    cl_abap_unit_assert=>assert_text_matches(
      pattern = |<prg:LCL_ATTRIBUTE |
      text    = lv_xml ).

    cl_abap_unit_assert=>assert_text_matches(
      pattern = |<FOO>0</FOO>|
      text    = lv_xml ).

  ENDMETHOD.

  METHOD empty_obj_in_structure.

    DATA: BEGIN OF foo,
            bar TYPE REF TO cx_root,
          END OF foo.
    DATA lv_xml TYPE string.

    CALL TRANSFORMATION id
      SOURCE data = foo
      RESULT XML lv_xml.

    cl_abap_unit_assert=>assert_text_matches(
      pattern = |<DATA><BAR/></DATA>|
      text    = lv_xml ).

  ENDMETHOD.

  METHOD obj_to_xml_to_obj.

    DATA lo     TYPE REF TO lcl_attribute.
    DATA lv_xml TYPE string.

    CREATE OBJECT lo.
    lo->foo = 5.

    CALL TRANSFORMATION id
       SOURCE data = lo
       RESULT XML lv_xml.

    CLEAR lo.

    " WRITE '@KERNEL console.dir(lv_xml);'.

    CALL TRANSFORMATION id
       SOURCE XML lv_xml
       RESULT data = lo.

    cl_abap_unit_assert=>assert_not_initial( lo ).

    cl_abap_unit_assert=>assert_equals(
      act = lo->foo
      exp = 5 ).

  ENDMETHOD.

ENDCLASS.