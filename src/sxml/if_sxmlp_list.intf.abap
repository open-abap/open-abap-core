INTERFACE if_sxmlp_list PUBLIC.
  INTERFACES if_sxmlp_part.

  METHODS add_part
    IMPORTING
      part TYPE REF TO if_sxmlp_part.
ENDINTERFACE.