CLASS cx_os_object_existing DEFINITION PUBLIC INHERITING FROM cx_os_object.
  PUBLIC SECTION.

    CONSTANTS transient_creating_persistent  TYPE sotr_conc VALUE '11111111111111111111111111111111'.
    CONSTANTS persistent_creating_persistent TYPE sotr_conc VALUE '11111111111111111111111111111111'.
    CONSTANTS transient_creating_transient   TYPE sotr_conc VALUE '11111111111111111111111111111111'.
    CONSTANTS persistent_creating_transient  TYPE sotr_conc VALUE '11111111111111111111111111111111'.

    DATA bkey TYPE string.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        object   TYPE REF TO object OPTIONAL
        bkey     TYPE string OPTIONAL
        oid      TYPE os_guid OPTIONAL.

ENDCLASS.

CLASS cx_os_object_existing IMPLEMENTATION.
  METHOD constructor.

    CALL METHOD super->constructor
      EXPORTING
        textid   = textid
        previous = previous
        object   = object.

    me->bkey = bkey.

  ENDMETHOD.

ENDCLASS.