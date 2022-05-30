CLASS ltcl_ui2json DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS test2 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_ui2json IMPLEMENTATION.

  METHOD test1.
    DATA: BEGIN OF stru,
           foo TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": 2}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = 2 ).
  ENDMETHOD.

  METHOD test2.
    DATA: BEGIN OF stru,
           foo TYPE string,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": "hello world"}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = 'hello world' ).
  ENDMETHOD.

ENDCLASS.