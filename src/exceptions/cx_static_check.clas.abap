CLASS cx_static_check DEFINITION PUBLIC INHERITING FROM cx_root.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        previous TYPE REF TO cx_root OPTIONAL.

ENDCLASS.

CLASS cx_static_check IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
  ENDMETHOD.

ENDCLASS.