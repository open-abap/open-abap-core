INTERFACE if_abap_testdouble_verify PUBLIC.

  METHODS is_called_times
    IMPORTING
      times TYPE i.

  METHODS is_called_once.

  METHODS is_never_called.

ENDINTERFACE.
