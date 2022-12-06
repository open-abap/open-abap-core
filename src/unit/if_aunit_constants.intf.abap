INTERFACE if_aunit_constants PUBLIC.
  CONSTANTS no        TYPE int1 VALUE 0.
  CONSTANTS critical  TYPE int1 VALUE 1.
  CONSTANTS fatal     TYPE int1 VALUE 1.
  CONSTANTS tolerable TYPE int1 VALUE 1.
  CONSTANTS method    TYPE int1 VALUE 1.
  CONSTANTS class     TYPE int1 VALUE 2.

  CONSTANTS: BEGIN OF severity,
               low    TYPE int1 VALUE 0,
               medium TYPE int1 VALUE 1,
               high   TYPE int1 VALUE 2,
             END OF severity.

  CONSTANTS: BEGIN OF quit,
               no   TYPE int1 VALUE 0,
               test TYPE int1 VALUE 1,
             END OF quit.
ENDINTERFACE.