INTERFACE if_ixml_stream_factory PUBLIC.
  METHODS create_ostream_cstring
    IMPORTING
      string        TYPE string
    RETURNING
      VALUE(stream) TYPE REF TO if_ixml_ostream.

  METHODS create_ostream_xstring
    IMPORTING
      string        TYPE xstring
    RETURNING
      VALUE(stream) TYPE REF TO if_ixml_ostream.

  METHODS create_istream_string
    IMPORTING
      string        TYPE string
    RETURNING
      VALUE(stream) TYPE REF TO if_ixml_istream.

  METHODS create_istream_xstring
    IMPORTING
      string        TYPE xstring
    RETURNING
      VALUE(stream) TYPE REF TO if_ixml_istream.

  METHODS create_ostream_itable
    IMPORTING
      table       TYPE table
    RETURNING
      VALUE(rval) TYPE REF TO if_ixml_ostream.

ENDINTERFACE.