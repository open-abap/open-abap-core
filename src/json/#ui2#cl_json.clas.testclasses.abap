CLASS ltcl_serialize DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS structure_integer FOR TESTING RAISING cx_static_check.
    METHODS structure_string FOR TESTING RAISING cx_static_check.
    METHODS structure_nested FOR TESTING RAISING cx_static_check.
    METHODS basic_array FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_serialize IMPLEMENTATION.

  METHOD structure_integer.
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

  METHOD structure_string.
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

  METHOD structure_nested.
    DATA: BEGIN OF stru,
           BEGIN OF sub,
             bar TYPE i,
           END OF sub,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"sub": {"bar": 2}}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-sub-bar
      exp = 2 ).
  ENDMETHOD.

  METHOD basic_array.
    DATA: BEGIN OF stru,
            foo TYPE STANDARD TABLE OF i WITH DEFAULT KEY,
          END OF stru.
    DATA lv_int TYPE i.
    DATA lv_json TYPE string.
    lv_json = '{"foo": [5, 7]}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( stru-foo )
      exp = 2 ).
    READ TABLE stru-foo INDEX 2 INTO lv_int.
    ASSERT sy-subrc = 0.
    cl_abap_unit_assert=>assert_equals(
      act = lv_int
      exp = 7 ).
  ENDMETHOD.

ENDCLASS.