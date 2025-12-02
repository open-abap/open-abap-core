CLASS kernel_lock DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS enqueue
      IMPORTING
        input TYPE any
      EXCEPTIONS
        foreign_lock
        system_failure.
    CLASS-METHODS dequeue
      IMPORTING
        input TYPE any.
  PRIVATE SECTION.
ENDCLASS.

CLASS kernel_lock IMPLEMENTATION.

  METHOD enqueue.
* Node JS is single threaded, so no locking here
    sy-subrc = 0.
  ENDMETHOD.

  METHOD dequeue.
* Node JS is single threaded, so no locking here
    sy-subrc = 0.
  ENDMETHOD.

ENDCLASS.