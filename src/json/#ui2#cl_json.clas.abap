CLASS /ui2/cl_json DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS deserialize
      IMPORTING
        json TYPE string OPTIONAL
      CHANGING
        data TYPE data.
ENDCLASS.

CLASS /ui2/cl_json IMPLEMENTATION.
  METHOD deserialize.
    RETURN.
  ENDMETHOD.
ENDCLASS.