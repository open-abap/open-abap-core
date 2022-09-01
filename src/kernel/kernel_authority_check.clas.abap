CLASS kernel_authority_check DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS call.
  PRIVATE SECTION.
ENDCLASS.

CLASS kernel_authority_check IMPLEMENTATION.

  METHOD call.
* add custom implementation here if needed
    sy-subrc = 0.
  ENDMETHOD.

ENDCLASS.