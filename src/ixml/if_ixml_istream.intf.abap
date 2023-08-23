INTERFACE if_ixml_istream PUBLIC.
  CONSTANTS dtd_allowed    TYPE i VALUE 0.
  CONSTANTS dtd_restricted TYPE i VALUE 1.
  CONSTANTS dtd_prohibited TYPE i VALUE 2.

  METHODS close.

  METHODS get_dtd_restriction
    RETURNING
      VALUE(rval) TYPE i.
ENDINTERFACE.