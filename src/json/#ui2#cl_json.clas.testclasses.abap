CLASS ltcl_deserialize DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS structure_integer FOR TESTING RAISING cx_static_check.
    METHODS structure_string FOR TESTING RAISING cx_static_check.
    METHODS structure_nested FOR TESTING RAISING cx_static_check.
    METHODS basic_array FOR TESTING RAISING cx_static_check.
    METHODS parse_abap_true FOR TESTING RAISING cx_static_check.
    METHODS parse_abap_true_flag FOR TESTING RAISING cx_static_check.
    METHODS parse_abap_false FOR TESTING RAISING cx_static_check.
    METHODS camel_case FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_deserialize IMPLEMENTATION.

  METHOD parse_abap_true.
    DATA: BEGIN OF stru,
            foo TYPE abap_bool,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": true}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = lv_json
      CHANGING
        data        = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = abap_true ).
  ENDMETHOD.

  METHOD parse_abap_true_flag.
    DATA: BEGIN OF stru,
            foo TYPE flag,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": true}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = lv_json
      CHANGING
        data        = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = abap_true ).
  ENDMETHOD.

  METHOD parse_abap_false.
    DATA: BEGIN OF stru,
            foo TYPE abap_bool,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"foo": false}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = lv_json
      CHANGING
        data        = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = abap_false ).
  ENDMETHOD.

  METHOD camel_case.
    DATA: BEGIN OF stru,
            foo_bar TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"fooBar": 2}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = lv_json
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING
        data        = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo_bar
      exp = 2 ).
  ENDMETHOD.

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

CLASS ltcl_serialize DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS structure_integer FOR TESTING RAISING cx_static_check.
    METHODS structure_string FOR TESTING RAISING cx_static_check.
    METHODS structure_two_fields FOR TESTING RAISING cx_static_check.
    METHODS basic_array FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestamp_iso FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestamp_iso_empty FOR TESTING RAISING cx_static_check.
    METHODS camel_case FOR TESTING RAISING cx_static_check.
    METHODS character10 FOR TESTING RAISING cx_static_check.
    METHODS string_spaces FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_serialize IMPLEMENTATION.

  METHOD character10.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE c LENGTH 10,
          END OF ls_data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":""}' ).
  ENDMETHOD.

  METHOD string_spaces.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE string,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo_bar = | |.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":" "}' ).
  ENDMETHOD.

  METHOD camel_case.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE i,
          END OF ls_data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize(
      data        = ls_data
      pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"fooBar":0}' ).
  ENDMETHOD.

  METHOD serialize_timestamp_iso.
    DATA: BEGIN OF foo,
            ts TYPE timestamp,
          END OF foo.
    DATA lv_json TYPE string.
    GET TIME STAMP FIELD foo-ts.
    lv_json = /ui2/cl_json=>serialize(
      data          = foo
      ts_as_iso8601 = abap_true ).
    cl_abap_unit_assert=>assert_text_matches(
      text    = lv_json
      pattern = '\{"TS":"\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.0000000Z"\}' ).
  ENDMETHOD.

  METHOD serialize_timestamp_iso_empty.
    DATA: BEGIN OF foo,
            ts TYPE timestamp,
          END OF foo.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize(
      data          = foo
      ts_as_iso8601 = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act    = lv_json
      exp = '{"TS":""}' ).
  ENDMETHOD.

  METHOD basic_array.
    DATA tab TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA lv_json TYPE string.
    APPEND 1 TO tab.
    APPEND 2 TO tab.
    lv_json = /ui2/cl_json=>serialize( tab ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '[1,2]' ).
  ENDMETHOD.

  METHOD structure_integer.
    DATA: BEGIN OF stru,
            foo TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    stru-foo = 2.
    lv_json = /ui2/cl_json=>serialize( stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":2}' ).
  ENDMETHOD.

  METHOD structure_two_fields.
    DATA: BEGIN OF stru,
            foo TYPE i,
            bar TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":0,"BAR":0}' ).
  ENDMETHOD.

  METHOD structure_string.
    DATA: BEGIN OF stru,
            foo TYPE string,
          END OF stru.
    DATA lv_json TYPE string.
    stru-foo = 'hello'.
    lv_json = /ui2/cl_json=>serialize( stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":"hello"}' ).
  ENDMETHOD.

ENDCLASS.