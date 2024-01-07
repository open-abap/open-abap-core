CLASS cl_ui2_deserialize1 DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run.
ENDCLASS.

CLASS cl_ui2_deserialize1 IMPLEMENTATION.
  METHOD run.
    TYPES: BEGIN OF ty_data,
             abap    TYPE i,
             foo     TYPE string,
             another TYPE string,
           END OF ty_data.

    DATA lv_json TYPE string.
    DATA ls_data TYPE STANDARD TABLE OF ty_data WITH DEFAULT KEY.

    lv_json = lv_json && '['.
    DO 300 TIMES.
      lv_json = lv_json && '{"abap": 2, "foo": "sdfs", "another": ""},'.
    ENDDO.
    lv_json = substring(
      val = lv_json
      len = strlen( lv_json ) - 1 ).
    lv_json = lv_json && ']'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = ls_data ).
  ENDMETHOD.
ENDCLASS.