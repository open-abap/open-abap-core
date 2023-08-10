CLASS cl_abap_weak_reference DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        oref TYPE REF TO object.

    METHODS get
      RETURNING
        VALUE(oref) TYPE REF TO object.
  PRIVATE SECTION.
ENDCLASS.

CLASS cl_abap_weak_reference IMPLEMENTATION.
  METHOD constructor.
* https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef

  ENDMETHOD.

  METHOD get.

  ENDMETHOD.
ENDCLASS.