INTERFACE if_ixml_renderer PUBLIC.
  METHODS render RETURNING VALUE(rval) TYPE i.
  METHODS set_normalizing IMPORTING normal TYPE abap_bool.
ENDINTERFACE.