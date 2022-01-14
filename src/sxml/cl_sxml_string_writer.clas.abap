CLASS cl_sxml_string_writer DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.

    METHODS get_output
      RETURNING
        VALUE(output) TYPE xstring.

    CLASS-METHODS create
      IMPORTING
        type          TYPE if_sxml=>xml_stream_type DEFAULT if_sxml=>co_xt_xml10
      RETURNING
        VALUE(writer) TYPE REF TO cl_sxml_string_writer
      RAISING
        cx_sxml_illegal_argument_error.

ENDCLASS.

CLASS cl_sxml_string_writer IMPLEMENTATION.

  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_output.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.