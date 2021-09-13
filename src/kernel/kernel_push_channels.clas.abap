CLASS kernel_push_channels DEFINITION PUBLIC.
* handling of ABAP statement WAIT FOR PUSH CHANNELS
  PUBLIC SECTION.
    CLASS-METHODS wait.
  PRIVATE SECTION.
ENDCLASS.

CLASS kernel_push_channels IMPLEMENTATION.

  METHOD wait.
* todo, await up to some seconds
    WRITE '@KERNEL await new Promise(resolve => setTimeout(resolve, 1000));'.
* todo, check condition
  ENDMETHOD.

ENDCLASS.