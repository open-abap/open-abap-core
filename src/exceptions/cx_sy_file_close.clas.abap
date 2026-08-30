CLASS cx_sy_file_close DEFINITION PUBLIC INHERITING FROM cx_sy_file_access_error.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        filename TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_file_close IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      filename = filename ).
  ENDMETHOD.
ENDCLASS.
