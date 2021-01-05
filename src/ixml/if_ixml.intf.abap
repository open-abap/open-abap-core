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
      VALUE(renderer) TYPE REF TO if_ixml_rendererrrrr.
ENDINTERFACE.