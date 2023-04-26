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
    METHODS short_timestamp FOR TESTING RAISING cx_static_check.
    METHODS long_timestamp FOR TESTING RAISING cx_static_check.
    METHODS via_jsonx FOR TESTING RAISING cx_static_check.
    METHODS empty_reference FOR TESTING RAISING cx_static_check.
    METHODS empty_reference2 FOR TESTING RAISING cx_static_check.
    METHODS basic_reference FOR TESTING RAISING cx_static_check.
    METHODS deserialize_to_ref FOR TESTING RAISING cx_static_check.
    METHODS deserialize_to_ref_nested FOR TESTING RAISING cx_static_check.
    METHODS deserialize_to_esc FOR TESTING RAISING cx_static_check.
    METHODS deserialize_to_ref_bool FOR TESTING RAISING cx_static_check.
    METHODS deserialize_str FOR TESTING RAISING cx_static_check.
    METHODS deserialize_int FOR TESTING RAISING cx_static_check.

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

  METHOD short_timestamp.
    DATA: BEGIN OF stru,
            ts TYPE timestamp,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"ts": "2023-03-09T21:02:59Z"}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = |{ stru-ts TIMESTAMP = ISO }|
      exp = |2023-03-09T21:02:59| ).
  ENDMETHOD.

  METHOD long_timestamp.
    DATA: BEGIN OF stru,
            ts TYPE timestampl,
          END OF stru.
    DATA lv_json TYPE string.
    lv_json = '{"ts": "2023-03-09T21:02:59.930Z"}'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = stru ).
    cl_abap_unit_assert=>assert_char_cp(
      act = |{ stru-ts TIMESTAMP = ISO }|
      exp = |2023-03-09T21:02:59,9*| ).
  ENDMETHOD.

  METHOD via_jsonx.
    DATA: BEGIN OF stru,
            foo TYPE i,
          END OF stru.
    DATA lv_jsonx TYPE xstring.
    lv_jsonx = '7B22666F6F223A20327D'.
    /ui2/cl_json=>deserialize(
      EXPORTING
        jsonx = lv_jsonx
      CHANGING
        data  = stru ).
    cl_abap_unit_assert=>assert_equals(
      act = stru-foo
      exp = 2 ).
  ENDMETHOD.

  METHOD empty_reference.
    DATA ref TYPE REF TO data.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json         = ''
        assoc_arrays = abap_true
      CHANGING
       data          = ref ).
    cl_abap_unit_assert=>assert_initial( ref ).
  ENDMETHOD.

  METHOD empty_reference2.
    DATA ref TYPE REF TO data.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json         = '2'
        assoc_arrays = abap_true
      CHANGING
       data          = ref ).
    cl_abap_unit_assert=>assert_initial( ref ).
  ENDMETHOD.

  METHOD basic_reference.
    TYPES: BEGIN OF ty,
             field TYPE i,
           END OF ty.
    DATA ref TYPE REF TO ty.
    CREATE DATA ref.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json         = '{"field":2}'
        assoc_arrays = abap_true
      CHANGING
        data         = ref ).
    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = ref->field ).
  ENDMETHOD.

  METHOD deserialize_to_ref.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"oSystem":2}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'OSYSTEM' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.
    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = 2 ).
  ENDMETHOD.

  METHOD deserialize_to_ref_nested.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"oSystem":{"ID":"ABC"}}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'OSYSTEM' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'ID' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.
    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = 'ABC' ).
  ENDMETHOD.

  METHOD deserialize_to_esc.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"oUpdate":{"MS_ERROR-CLASSNAME":"hello"}}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'OUPDATE' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.

    ASSIGN COMPONENT 'MS_ERROR_CLASSNAME' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.

    " cl_abap_unit_assert=>assert_equals(
    "   act = <any>
    "   exp = 'hello' ).
  ENDMETHOD.

  METHOD deserialize_to_ref_bool.
    DATA lr_actual TYPE REF TO data.
    DATA lv_json   TYPE string.

    FIELD-SYMBOLS <any> TYPE any.

    lv_json = '{"fieldname":true}'.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json
      CHANGING
        data = lr_actual ).

    cl_abap_unit_assert=>assert_not_initial( lr_actual ).
    ASSIGN lr_actual->* TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT 'FIELDNAME' OF STRUCTURE <any> TO <any>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN <any>->* TO <any>.

    cl_abap_unit_assert=>assert_equals(
      act = <any>
      exp = abap_true ).
  ENDMETHOD.

  METHOD deserialize_str.
    DATA ref TYPE REF TO data.
    DATA lv_type TYPE c LENGTH 1.
    FIELD-SYMBOLS <fs> TYPE any.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{"foo":"600"}'
      CHANGING
        data = ref ).
    ASSIGN ref->('FOO->*') TO <fs>.
    DESCRIBE FIELD <fs> TYPE lv_type.
    cl_abap_unit_assert=>assert_equals(
      act = lv_type
      exp = 'g' ).
  ENDMETHOD.

  METHOD deserialize_int.
    DATA ref TYPE REF TO data.
    DATA lv_type TYPE c LENGTH 1.
    FIELD-SYMBOLS <fs> TYPE any.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = '{"foo":600}'
      CHANGING
        data = ref ).
    ASSIGN ref->('FOO->*') TO <fs>.
    DESCRIBE FIELD <fs> TYPE lv_type.
    cl_abap_unit_assert=>assert_equals(
      act = lv_type
      exp = 'I' ).
  ENDMETHOD.

ENDCLASS.

*****************************************************************************************

CLASS ltcl_serialize DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS structure_integer FOR TESTING RAISING cx_static_check.
    METHODS structure_integer_negative FOR TESTING RAISING cx_static_check.
    METHODS structure_string FOR TESTING RAISING cx_static_check.
    METHODS structure_two_fields FOR TESTING RAISING cx_static_check.
    METHODS basic_array FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestamp_iso FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestamp_iso_empty FOR TESTING RAISING cx_static_check.
    METHODS serialize_timestampl_iso_empty FOR TESTING RAISING cx_static_check.
    METHODS camel_case FOR TESTING RAISING cx_static_check.
    METHODS character10 FOR TESTING RAISING cx_static_check.
    METHODS character10_value FOR TESTING RAISING cx_static_check.
    METHODS character10_space FOR TESTING RAISING cx_static_check.
    METHODS string_spaces FOR TESTING RAISING cx_static_check.
    METHODS bool_false FOR TESTING RAISING cx_static_check.
    METHODS bool_true FOR TESTING RAISING cx_static_check.
    METHODS empty_reference FOR TESTING RAISING cx_static_check.
    METHODS basic_ref FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_serialize IMPLEMENTATION.

  METHOD bool_false.
    DATA: BEGIN OF ls_data,
        foo_bar TYPE abap_bool,
      END OF ls_data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":false}' ).
  ENDMETHOD.

  METHOD bool_true.
    DATA: BEGIN OF ls_data,
        foo_bar TYPE abap_bool,
      END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo_bar = abap_true.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":true}' ).
  ENDMETHOD.

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

  METHOD character10_value.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE c LENGTH 10,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo_bar = 'hello'.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":"hello"}' ).
  ENDMETHOD.

  METHOD character10_space.
    DATA: BEGIN OF ls_data,
            foo_bar TYPE c LENGTH 10,
          END OF ls_data.
    DATA lv_json TYPE string.
    ls_data-foo_bar = ' hello'.
    lv_json = /ui2/cl_json=>serialize( ls_data ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO_BAR":" hello"}' ).
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

  METHOD serialize_timestampl_iso_empty.
    DATA: BEGIN OF foo,
            ts TYPE timestampl,
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

  METHOD structure_integer_negative.
    DATA: BEGIN OF stru,
            foo TYPE i,
          END OF stru.
    DATA lv_json TYPE string.
    stru-foo = -2.
    lv_json = /ui2/cl_json=>serialize( stru ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FOO":-2}' ).
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

  METHOD empty_reference.
    DATA ref TYPE REF TO data.
    DATA lv_json TYPE string.
    lv_json = /ui2/cl_json=>serialize( ref ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = 'null' ).
  ENDMETHOD.

  METHOD basic_ref.
    TYPES: BEGIN OF ty,
             field TYPE i,
           END OF ty.
    DATA ref TYPE REF TO ty.
    DATA lv_json TYPE string.
    CREATE DATA ref.
    lv_json = /ui2/cl_json=>serialize( ref ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_json
      exp = '{"FIELD":0}' ).
  ENDMETHOD.

ENDCLASS.