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

    METHODS append_text IMPORTING text TYPE string.
    METHODS get_text RETURNING VALUE(text) TYPE string.

* stack operations
    METHODS peek RETURNING VALUE(rv_name) TYPE string.
    METHODS remove RETURNING VALUE(rv_name) TYPE string.
ENDCLASS.

CLASS cl_sxml_string_writer IMPLEMENTATION.

  METHOD constructor.
    mv_type = type.
  ENDMETHOD.

  METHOD if_sxml_writer~new_open_element.
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
    ASSERT 1 = 'todo'.
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

ENDCLASS.