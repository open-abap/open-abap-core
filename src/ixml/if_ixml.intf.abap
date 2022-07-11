INTERFACE if_ixml PUBLIC.
  METHODS create_document
    RETURNING
      VALUE(doc) TYPE REF TO if_ixml_document.
  METHODS create_stream_factory
    RETURNING
      VALUE(stream) TYPE REF TO if_ixml_stream_factory.
  METHODS create_renderer
    IMPORTING
      ostream  TYPE REF TO if_ixml_ostream
      document TYPE REF TO if_ixml_document
    RETURNING
      VALUE(renderer) TYPE REF TO if_ixml_renderer.
  METHODS create_parser
    IMPORTING
      stream_factory  TYPE REF TO if_ixml_stream_factory
      istream  TYPE REF TO if_ixml_istream
      document TYPE REF TO if_ixml_document
    RETURNING
      VALUE(parser) TYPE REF TO if_ixml_parser.
  METHODS create_encoding
    IMPORTING
      byte_order    TYPE string
      character_set TYPE string
    RETURNING
      VALUE(rval) TYPE REF TO if_ixml_encoding.
ENDINTERFACE.