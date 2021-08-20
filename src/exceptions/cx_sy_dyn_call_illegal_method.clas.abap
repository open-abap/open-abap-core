CLASS cx_sy_dyn_call_illegal_method DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.

  PUBLIC SECTION.
    CONSTANTS private_method TYPE c VALUE '1'.

    METHODS constructor
      IMPORTING
        textid     LIKE textid OPTIONAL
        previous   LIKE previous OPTIONAL
        classname  TYPE string OPTIONAL
        methodname TYPE string OPTIONAL.

ENDCLASS.

CLASS cx_sy_dyn_call_illegal_method IMPLEMENTATION.

  METHOD constructor.
    RETURN.
  ENDMETHOD.

ENDCLASS.