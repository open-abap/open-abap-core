INTERFACE if_abap_unit_constant PUBLIC.
  CONSTANTS:
    BEGIN OF severity,
      low               TYPE int1 VALUE 0,
      medium            TYPE int1 VALUE 1,
      high              TYPE int1 VALUE 2,
    END OF severity.
  CONSTANTS:
    BEGIN OF quit,
      test   TYPE int1 VALUE 1,
      no     TYPE int1 VALUE 5,
    END OF quit.
ENDINTERFACE.