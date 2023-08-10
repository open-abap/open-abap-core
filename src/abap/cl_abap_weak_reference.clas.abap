CLASS cl_abap_weak_reference DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        oref TYPE REF TO object.

    METHODS get
      RETURNING
        VALUE(oref) TYPE REF TO object.
  PRIVATE SECTION.
    DATA mv_ref TYPE x LENGTH 1.
ENDCLASS.

CLASS cl_abap_weak_reference IMPLEMENTATION.
  METHOD constructor.
* https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef
    ASSERT oref IS NOT INITIAL.
    WRITE '@KERNEL this.mv_ref = new WeakRef(oref);'.
  ENDMETHOD.

  METHOD get.
    WRITE '@KERNEL oref.set(this.mv_ref.deref());'.
  ENDMETHOD.
ENDCLASS.