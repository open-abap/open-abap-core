CLASS cl_ui2_serialize1 DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run.
ENDCLASS.

CLASS cl_ui2_serialize1 IMPLEMENTATION.
  METHOD run.
    TYPES: BEGIN OF ty_data,
             abap    TYPE i,
             foo     TYPE string,
             another TYPE string,
           END OF ty_data.

    DATA lt_data TYPE STANDARD TABLE OF ty_data WITH DEFAULT KEY.

    DO 5000 TIMES.
      APPEND INITIAL LINE TO lt_data.
    ENDDO.

    /ui2/cl_json=>serialize( lt_data ).
  ENDMETHOD.
ENDCLASS.