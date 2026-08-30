CLASS cx_sy_dynamic_osql_syntax DEFINITION PUBLIC INHERITING FROM cx_sy_dynamic_osql_error.
  PUBLIC SECTION.
    DATA token TYPE string.

    METHODS constructor
      IMPORTING
        token  TYPE string OPTIONAL
        textid LIKE textid OPTIONAL
        sqlmsg TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_dynamic_osql_syntax IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid = textid
      sqlmsg = sqlmsg ).
    me->token = token.
  ENDMETHOD.
ENDCLASS.
