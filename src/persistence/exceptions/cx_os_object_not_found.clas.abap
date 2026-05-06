CLASS cx_os_object_not_found DEFINITION PUBLIC INHERITING FROM cx_os_object.
  PUBLIC SECTION.

    CONSTANTS by_ref                TYPE sotr_conc VALUE '11111111111111111111111111111111'.
    CONSTANTS by_bkey               TYPE sotr_conc VALUE '11111111111111111111111111111111'.
    CONSTANTS deleted_by_bkey       TYPE sotr_conc VALUE '11111111111111111111111111111111'.
    CONSTANTS is_persistent_by_bkey TYPE sotr_conc VALUE '11111111111111111111111111111111'.
    CONSTANTS is_transient_by_bkey  TYPE sotr_conc VALUE '11111111111111111111111111111111'.
    CONSTANTS transient_by_bkey     TYPE sotr_conc VALUE '11111111111111111111111111111111'.


    DATA table TYPE tabname.
    DATA bkey TYPE string.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        table    LIKE table OPTIONAL
        bkey     LIKE bkey OPTIONAL.

ENDCLASS.

CLASS cx_os_object_not_found IMPLEMENTATION.
  METHOD constructor.

    CALL METHOD super->constructor
      EXPORTING
        textid   = textid
        previous = previous.

    me->table = table.
    me->bkey = bkey.

  ENDMETHOD.

ENDCLASS.