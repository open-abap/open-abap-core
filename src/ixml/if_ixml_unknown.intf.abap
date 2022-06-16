INTERFACE if_ixml_unknown PUBLIC.
  METHODS query_interface
    IMPORTING
      iid         TYPE i
    RETURNING
      VALUE(rval) TYPE REF TO if_ixml_unknown.
ENDINTERFACE.