INTERFACE if_ixml_ostream PUBLIC.
  METHODS write_string
    IMPORTING
      string      TYPE string
    RETURNING
      VALUE(rval) TYPE i.
ENDINTERFACE.