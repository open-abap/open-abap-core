INTERFACE if_ixml_stream_factory PUBLIC.
  METHODS create_ostream_cstring
    IMPORTING 
      string TYPE string
    RETURNING 
      VALUE(stream) TYPE REF TO if_ixml_ostream.
  METHODS create_istream_string
    IMPORTING
      xml TYPE string
    RETURNING 
      VALUE(stream) TYPE REF TO if_ixml_istream.
ENDINTERFACE.