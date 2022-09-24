INTERFACE if_sxmlp_factory PUBLIC.
  CLASS-METHODS create_list
    IMPORTING
      name        TYPE string
      nsuri       TYPE string OPTIONAL
      prefix      TYPE string OPTIONAL
    RETURNING
      VALUE(rval) TYPE REF TO if_sxmlp_list.
ENDINTERFACE.