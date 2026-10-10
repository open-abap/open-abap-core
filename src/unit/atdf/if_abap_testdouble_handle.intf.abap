INTERFACE if_abap_testdouble_handle PUBLIC.

  METHODS raise_event
    IMPORTING
      name       TYPE abap_methname
      parameters TYPE abap_parmbind_tab OPTIONAL.

ENDINTERFACE.
