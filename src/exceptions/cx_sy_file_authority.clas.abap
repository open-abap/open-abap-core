CLASS cx_sy_file_authority DEFINITION PUBLIC INHERITING FROM cx_sy_file_access_error.
  PUBLIC SECTION.
    DATA operation TYPE string.

    METHODS constructor
      IMPORTING
        textid    LIKE textid OPTIONAL
        filename  TYPE string OPTIONAL
        operation TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_file_authority IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      filename = filename ).
    me->operation = operation.
  ENDMETHOD.
ENDCLASS.
