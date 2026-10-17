CLASS cl_sxml_string_writer DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES if_sxml_writer.

    METHODS constructor
      IMPORTING
        type TYPE if_sxml=>xml_stream_type.

    METHODS get_output
      RETURNING
        VALUE(output) TYPE xstring.

    CLASS-METHODS create
      IMPORTING
        type                     TYPE if_sxml=>xml_stream_type DEFAULT if_sxml=>co_xt_xml10
        ignore_conversion_errors TYPE abap_bool DEFAULT abap_false
        normalizing              TYPE abap_bool DEFAULT abap_false
        no_empty_elements        TYPE abap_bool DEFAULT abap_false
        encoding                 TYPE string DEFAULT 'UTF-8'
        PREFERRED PARAMETER type
      RETURNING
        VALUE(writer)            TYPE REF TO cl_sxml_string_writer
      RAISING
        cx_sxml_illegal_argument_error.

  PRIVATE SECTION.
    DATA mv_output TYPE xstring.
    DATA mv_type TYPE if_sxml=>xml_stream_type.
    DATA mt_stack TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA mv_tag_open TYPE abap_bool.
    DATA mv_linebreaks TYPE abap_bool.
    DATA mv_indent TYPE abap_bool.
* per open element: whether it got child elements, its closing tag then goes on a new line
    DATA mt_has_children TYPE STANDARD TABLE OF abap_bool WITH DEFAULT KEY.
    METHODS xml_new_line IMPORTING iv_depth TYPE i.
* namespace bindings in scope, the prefix of the default namespace is initial
    TYPES: BEGIN OF ty_binding,
             depth  TYPE i,
             prefix TYPE string,
             nsuri  TYPE string,
           END OF ty_binding.
    DATA mt_bindings TYPE STANDARD TABLE OF ty_binding WITH DEFAULT KEY.
    METHODS xml_declare
      IMPORTING iv_prefix TYPE string
                iv_nsuri  TYPE string.

    METHODS append_text IMPORTING text TYPE string.
    METHODS get_text RETURNING VALUE(text) TYPE string.

* json output
    METHODS json_open_element IMPORTING name TYPE string.
    METHODS json_close_element.
    METHODS json_write_attribute IMPORTING value TYPE string.
    METHODS json_write_value IMPORTING value TYPE string.

* xml output
    METHODS xml_open_element IMPORTING name   TYPE string
                                       nsuri  TYPE string OPTIONAL
                                       prefix TYPE string OPTIONAL.
    METHODS xml_close_element.
    METHODS xml_write_attribute IMPORTING name   TYPE string
                                          nsuri  TYPE string OPTIONAL
                                          prefix TYPE string OPTIONAL
                                          value  TYPE string.
    METHODS xml_write_value IMPORTING value TYPE string.
    METHODS xml_close_tag.
    METHODS xml_escape IMPORTING text          TYPE string
                                 attribute     TYPE abap_bool DEFAULT abap_false
                       RETURNING VALUE(result) TYPE string.

* stack operations
    METHODS peek RETURNING VALUE(rv_name) TYPE string.
    METHODS remove RETURNING VALUE(rv_name) TYPE string.
ENDCLASS.

CLASS cl_sxml_string_writer IMPLEMENTATION.

  METHOD constructor.
    mv_type = type.
  ENDMETHOD.

  METHOD if_sxml_writer~new_close_element.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_writer~write_attribute_raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_writer~new_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_writer~new_open_element.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_writer~write_value_raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_writer~write_namespace_declaration.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_writer~write_node.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD create.
    CREATE OBJECT writer
      EXPORTING
        type = type.
  ENDMETHOD.

  METHOD if_sxml_writer~set_option.
    CASE option.
      WHEN if_sxml_writer=>co_opt_linebreaks.
        mv_linebreaks = value.
      WHEN if_sxml_writer=>co_opt_indent.
        mv_indent = value.
      WHEN OTHERS.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

  METHOD get_output.
    output = mv_output.
  ENDMETHOD.

  METHOD append_text.
    DATA append TYPE xstring.
    append = cl_abap_conv_codepage=>create_out( )->convert( text ).
    CONCATENATE mv_output append INTO mv_output IN BYTE MODE.
  ENDMETHOD.

  METHOD get_text.
    text = cl_abap_conv_codepage=>create_in( )->convert( mv_output ).
  ENDMETHOD.

  METHOD if_sxml_writer~open_element.
    IF mv_type = if_sxml=>co_xt_json.
      json_open_element( name ).
    ELSE.
      xml_open_element( name   = name
                        nsuri  = nsuri
                        prefix = prefix ).
    ENDIF.
  ENDMETHOD.

  METHOD json_open_element.
    DATA parent TYPE string.
    parent = peek( ).

    IF parent = 'array' AND get_text( ) NP '*['.
      append_text( ',' ).
    ENDIF.
    IF parent = 'object' AND get_text( ) NP '*{'.
      append_text( ',' ).
    ENDIF.

    APPEND name TO mt_stack.
    CASE name.
      WHEN 'object'.
        append_text( '{' ).
      WHEN 'array'.
        append_text( '[' ).
    ENDCASE.
  ENDMETHOD.

  METHOD remove.
    DATA index TYPE i.
    index = lines( mt_stack ).
    READ TABLE mt_stack INDEX index INTO rv_name.
    DELETE mt_stack INDEX index.
  ENDMETHOD.

  METHOD if_sxml_writer~close_element.
    IF mv_type = if_sxml=>co_xt_json.
      json_close_element( ).
    ELSE.
      xml_close_element( ).
    ENDIF.
  ENDMETHOD.

  METHOD json_close_element.
    DATA name TYPE string.
    name = remove( ).
    CASE name.
      WHEN 'object'.
        append_text( '}' ).
      WHEN 'array'.
        append_text( ']' ).
    ENDCASE.
  ENDMETHOD.

  METHOD if_sxml_writer~write_attribute.
    IF mv_type = if_sxml=>co_xt_json.
      json_write_attribute( value ).
    ELSE.
      xml_write_attribute( name   = name
                           nsuri  = nsuri
                           prefix = prefix
                           value  = value ).
    ENDIF.
  ENDMETHOD.

  METHOD json_write_attribute.
    append_text( '"' ).
    append_text( value ).
    append_text( '":' ).
  ENDMETHOD.

  METHOD peek.
    DATA index TYPE i.
    index = lines( mt_stack ).
    READ TABLE mt_stack INDEX index INTO rv_name.
  ENDMETHOD.

  METHOD if_sxml_writer~write_value.
    IF mv_type = if_sxml=>co_xt_json.
      json_write_value( value ).
    ELSE.
      xml_write_value( value ).
    ENDIF.
  ENDMETHOD.

  METHOD json_write_value.
    DATA name TYPE string.
    name = peek( ).
    CASE name.
      WHEN 'str'.
        append_text( '"' ).
        append_text( condense( value ) ).
        append_text( '"' ).
      WHEN 'num'.
        append_text( condense( value ) ).
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(name);'.
        ASSERT 1 = 'todo_if_sxml_writer_write_value'.
    ENDCASE.
  ENDMETHOD.

  METHOD xml_open_element.
    DATA lv_depth TYPE i.
    DATA lv_prefix TYPE string.
    DATA lv_qname TYPE string.
    xml_close_tag( ).
    lv_depth = lines( mt_stack ).
    IF lv_depth > 0.
      MODIFY mt_has_children INDEX lv_depth FROM abap_true.
    ENDIF.
    IF xstrlen( mv_output ) > 0.
      xml_new_line( lv_depth ).
    ENDIF.
    lv_qname = name.
    IF nsuri IS NOT INITIAL AND prefix IS NOT INITIAL AND prefix <> if_sxml_named=>co_use_default_xmlns.
      lv_prefix = prefix.
      lv_qname = |{ prefix }:{ name }|.
    ENDIF.

    APPEND lv_qname TO mt_stack.
    APPEND abap_false TO mt_has_children.
    append_text( '<' ).
    append_text( lv_qname ).
    mv_tag_open = abap_true.

    xml_declare( iv_prefix = lv_prefix
                 iv_nsuri  = nsuri ).
  ENDMETHOD.

  METHOD xml_close_element.
    DATA name TYPE string.
    DATA lv_children TYPE abap_bool.
    DATA lv_depth TYPE i.
    lv_depth = lines( mt_has_children ).
    READ TABLE mt_has_children INDEX lv_depth INTO lv_children.
    DELETE mt_has_children INDEX lv_depth.
    DELETE mt_bindings WHERE depth = lv_depth.
    name = remove( ).
    IF mv_tag_open = abap_true.
      append_text( '/>' ).
      mv_tag_open = abap_false.
    ELSE.
      IF lv_children = abap_true.
        xml_new_line( lines( mt_stack ) ).
      ENDIF.
      append_text( '</' ).
      append_text( name ).
      append_text( '>' ).
    ENDIF.
  ENDMETHOD.

  METHOD xml_write_attribute.
    ASSERT mv_tag_open = abap_true.
* an attribute without prefix is in no namespace, so a namespace needs a prefix
    IF nsuri IS NOT INITIAL AND prefix IS NOT INITIAL AND prefix <> if_sxml_named=>co_use_default_xmlns.
      xml_declare( iv_prefix = prefix
                   iv_nsuri  = nsuri ).
      append_text( ` ` ).
      append_text( |{ prefix }:{ name }| ).
    ELSE.
      append_text( ` ` ).
      append_text( name ).
    ENDIF.
    append_text( '="' ).
    append_text( xml_escape( text      = value
                             attribute = abap_true ) ).
    append_text( '"' ).
  ENDMETHOD.

  METHOD xml_write_value.
    xml_close_tag( ).
    append_text( xml_escape( value ) ).
  ENDMETHOD.

  METHOD xml_declare.
* writes xmlns:prefix="nsuri" (or xmlns="nsuri" for the default namespace) when the
* binding in scope differs, an element without namespace inside a default one gets xmlns=""
    DATA ls_binding LIKE LINE OF mt_bindings.
    DATA lv_current TYPE string.
    DATA lv_index   TYPE i.

    lv_index = lines( mt_bindings ).
    WHILE lv_index > 0.
      READ TABLE mt_bindings INDEX lv_index INTO ls_binding.
      IF ls_binding-prefix = iv_prefix.
        lv_current = ls_binding-nsuri.
        EXIT.
      ENDIF.
      lv_index = lv_index - 1.
    ENDWHILE.

    IF lv_current = iv_nsuri.
      RETURN.
    ENDIF.

    ls_binding-depth = lines( mt_stack ).
    ls_binding-prefix = iv_prefix.
    ls_binding-nsuri = iv_nsuri.
    APPEND ls_binding TO mt_bindings.

    IF iv_prefix IS INITIAL.
      append_text( ` xmlns="` ).
    ELSE.
      append_text( | xmlns:{ iv_prefix }="| ).
    ENDIF.
    append_text( xml_escape( text      = iv_nsuri
                             attribute = abap_true ) ).
    append_text( '"' ).
  ENDMETHOD.

  METHOD xml_new_line.
* one blank per level, like the indented XML of CALL TRANSFORMATION
    IF mv_linebreaks = abap_false.
      RETURN.
    ENDIF.
    append_text( |\n| ).
    IF mv_indent = abap_true AND iv_depth > 0.
      append_text( repeat( val = ` `
                           occ = iv_depth ) ).
    ENDIF.
  ENDMETHOD.

  METHOD xml_close_tag.
    IF mv_tag_open = abap_true.
      append_text( '>' ).
      mv_tag_open = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD xml_escape.
    result = text.
    REPLACE ALL OCCURRENCES OF '&' IN result WITH '&amp;'.
    REPLACE ALL OCCURRENCES OF '<' IN result WITH '&lt;'.
    REPLACE ALL OCCURRENCES OF '>' IN result WITH '&gt;'.
    IF attribute = abap_true.
      REPLACE ALL OCCURRENCES OF '"' IN result WITH '&quot;'.
      REPLACE ALL OCCURRENCES OF |'| IN result WITH '&apos;'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
