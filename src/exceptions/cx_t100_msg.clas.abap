CLASS cx_t100_msg DEFINITION PUBLIC INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid     LIKE textid OPTIONAL
        previous   LIKE previous OPTIONAL
        t100_msgid TYPE sy-msgid OPTIONAL
        t100_msgno TYPE sy-msgno OPTIONAL
        t100_msgv1 TYPE string OPTIONAL
        t100_msgv2 TYPE string OPTIONAL
        t100_msgv3 TYPE string OPTIONAL
        t100_msgv4 TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_t100_msg IMPLEMENTATION.

  METHOD constructor.
    RETURN.
  ENDMETHOD.

ENDCLASS.