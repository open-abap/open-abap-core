CLASS cx_sy_file_access_error DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.
  PUBLIC SECTION.
    DATA filename TYPE string.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        filename TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_file_access_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( textid = textid ).
    me->filename = filename.
  ENDMETHOD.
ENDCLASS.
