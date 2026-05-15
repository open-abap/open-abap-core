INTERFACE if_ixml_stream PUBLIC.

  METHODS get_encoding
    RETURNING
      VALUE(rval) TYPE REF TO if_ixml_encoding.

ENDINTERFACE.