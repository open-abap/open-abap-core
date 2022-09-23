INTERFACE if_aunit_constants PUBLIC.
  CONSTANTS no        TYPE i VALUE 0.
  CONSTANTS critical  TYPE i VALUE 1.
  CONSTANTS fatal     TYPE i VALUE 1.
  CONSTANTS tolerable TYPE i VALUE 1.
  CONSTANTS method    TYPE i VALUE 1.

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