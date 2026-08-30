CLASS cx_sy_file_open_mode DEFINITION PUBLIC INHERITING FROM cx_sy_file_access_error.
  PUBLIC SECTION.
    DATA operation TYPE string.

    METHODS constructor
      IMPORTING
        textid    LIKE textid OPTIONAL
        filename  TYPE string OPTIONAL
        operation TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_file_open_mode IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      filename = filename ).
    me->operation = operation.
  ENDMETHOD.
ENDCLASS.
