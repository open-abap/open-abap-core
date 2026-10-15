CLASS lcl_lock_object DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES if_abap_lock_object.

ENDCLASS.

CLASS lcl_lock_object IMPLEMENTATION.

  METHOD if_abap_lock_object~enqueue.
* Node JS is single threaded, so no locking here, same as KERNEL_LOCK
    RETURN.
  ENDMETHOD.

  METHOD if_abap_lock_object~dequeue.
* Node JS is single threaded, so no locking here, same as KERNEL_LOCK
    RETURN.
  ENDMETHOD.

ENDCLASS.
