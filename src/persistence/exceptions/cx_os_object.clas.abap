CLASS cx_os_object DEFINITION PUBLIC INHERITING FROM cx_os_error.
  PUBLIC SECTION.
    DATA object TYPE REF TO object.

    METHODS constructor
      IMPORTING
        textid LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        object TYPE REF TO object OPTIONAL.
ENDCLASS.

CLASS cx_os_object IMPLEMENTATION.
  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        textid = textid
        previous = previous.

    me->object = object.
  ENDMETHOD.

ENDCLASS.