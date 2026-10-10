CLASS lcl_answer DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_testdouble_answer.

    DATA mv_method_name TYPE abap_methname READ-ONLY.
    DATA mv_size TYPE i READ-ONLY.
    DATA mv_names TYPE string READ-ONLY.
    DATA mo_exception TYPE REF TO cx_root.
ENDCLASS.

CLASS lcl_answer IMPLEMENTATION.

  METHOD if_abap_testdouble_answer~answer.
    DATA lr_value TYPE REF TO data.
    DATA lv_name  TYPE abap_parmname.
    DATA lv_kind  TYPE abap_parmkind.

    FIELD-SYMBOLS <lv_name> TYPE string.

    mv_method_name = method_name.
    mv_size = arguments->size_of( ).
    WHILE arguments->has_next_parameter( ) = abap_true.
      arguments->next_parameter( IMPORTING name = lv_name kind = lv_kind ).
      mv_names = |{ mv_names }{ lv_name }:{ lv_kind } |.
    ENDWHILE.

    IF mo_exception IS BOUND.
      result->raise_exception( mo_exception ).
      RETURN.
    ENDIF.

    CASE method_name.
      WHEN 'IF_HTTP_REQUEST~GET_URI_PARAMETER'.
        lr_value = arguments->get_param_importing( 'NAME' ).
        ASSIGN lr_value->* TO <lv_name>.
        result->set_param_returning( |value of { <lv_name> }| ).
      WHEN 'IF_HTTP_REQUEST~GET_AUTHORIZATION'.
        result->set_param_exporting( name  = 'USERNAME'
                                     value = `answered` ).
      WHEN 'IF_HTTP_REQUEST~GET_FORM_DATA'.
        result->set_param_changing( name  = 'DATA'
                                    value = `changed` ).
    ENDCASE.
  ENDMETHOD.

ENDCLASS.

*************************************************************

"! applies when the actual NAME is the configured NAME in another case
CLASS lcl_matcher DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_testdouble_matcher.
ENDCLASS.

CLASS lcl_matcher IMPLEMENTATION.

  METHOD if_abap_testdouble_matcher~matches.
    DATA lr_configured TYPE REF TO data.
    DATA lr_actual     TYPE REF TO data.

    FIELD-SYMBOLS <lv_configured> TYPE string.
    FIELD-SYMBOLS <lv_actual>     TYPE string.

    lr_configured = configured_arguments->get_param_importing( 'NAME' ).
    lr_actual = actual_arguments->get_param_importing( 'NAME' ).
    ASSIGN lr_configured->* TO <lv_configured>.
    ASSIGN lr_actual->* TO <lv_actual>.
    result = boolc( to_upper( <lv_configured> ) = to_upper( <lv_actual> ) ).
  ENDMETHOD.

ENDCLASS.

*************************************************************

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    DATA mi_message TYPE REF TO if_message.
    DATA mi_request TYPE REF TO if_http_request.

    METHODS setup.

    METHODS create_interface FOR TESTING RAISING cx_static_check.
    METHODS create_unknown_raises FOR TESTING RAISING cx_static_check.
    METHODS create_class_raises FOR TESTING RAISING cx_static_check.
    METHODS not_configured_initial FOR TESTING RAISING cx_static_check.
    METHODS returning_value FOR TESTING RAISING cx_static_check.
    METHODS returning_used_up_repeats FOR TESTING RAISING cx_static_check.
    METHODS times_then_next_configuration FOR TESTING RAISING cx_static_check.
    METHODS times_zero_raises FOR TESTING RAISING cx_static_check.
    METHODS arguments_must_match FOR TESTING RAISING cx_static_check.
    METHODS arguments_converted FOR TESTING RAISING cx_static_check.
    METHODS optional_left_out FOR TESTING RAISING cx_static_check.
    METHODS ignore_parameter FOR TESTING RAISING cx_static_check.
    METHODS ignore_unknown_raises FOR TESTING RAISING cx_static_check.
    METHODS ignore_all_parameters FOR TESTING RAISING cx_static_check.
    METHODS set_parameter_exporting FOR TESTING RAISING cx_static_check.
    METHODS set_parameter_changing FOR TESTING RAISING cx_static_check.
    METHODS set_parameter_unknown_raises FOR TESTING RAISING cx_static_check.
    METHODS returning_without_raises FOR TESTING RAISING cx_static_check.
    METHODS raise_exception FOR TESTING RAISING cx_static_check.
    METHODS raise_with_returning_raises FOR TESTING RAISING cx_static_check.
    METHODS answer_returning FOR TESTING RAISING cx_static_check.
    METHODS answer_exporting_changing FOR TESTING RAISING cx_static_check.
    METHODS answer_raises FOR TESTING RAISING cx_static_check.
    METHODS answer_arguments FOR TESTING RAISING cx_static_check.
    METHODS matcher FOR TESTING RAISING cx_static_check.
    METHODS expect_times_verified FOR TESTING RAISING cx_static_check.
    METHODS expect_too_few_fails FOR TESTING RAISING cx_static_check.
    METHODS expect_too_many_fails FOR TESTING RAISING cx_static_check.
    METHODS expect_never_called FOR TESTING RAISING cx_static_check.
    METHODS no_double_raises FOR TESTING RAISING cx_static_check.
    METHODS doubles_are_independent FOR TESTING RAISING cx_static_check.
    METHODS returning_object FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    mi_message ?= cl_abap_testdouble=>create( 'IF_MESSAGE' ).
    mi_request ?= cl_abap_testdouble=>create( 'if_http_request' ).
  ENDMETHOD.

  METHOD create_interface.
    DATA lo_double  TYPE REF TO object.
    DATA li_message TYPE REF TO if_message.

    lo_double = cl_abap_testdouble=>create( 'IF_MESSAGE' ).

    li_message ?= lo_double.
    cl_abap_unit_assert=>assert_bound( li_message ).
  ENDMETHOD.

  METHOD create_unknown_raises.
    TRY.
        cl_abap_testdouble=>create( 'IF_DOES_NOT_EXIST' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_atd_exception_core.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD create_class_raises.
    DATA lx_error TYPE REF TO cx_atd_exception_core.

    TRY.
        cl_abap_testdouble=>create( 'CL_ABAP_TYPEDESCR' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_atd_exception_core INTO lx_error.
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->object_name
          exp = 'CL_ABAP_TYPEDESCR' ).
        cl_abap_unit_assert=>assert_char_cp(
          act = lx_error->get_text( )
          exp = '*not an interface*' ).
    ENDTRY.
  ENDMETHOD.

  METHOD not_configured_initial.
    DATA lv_user TYPE string.

    lv_user = `unchanged`.
    mi_request->get_authorization( IMPORTING username = lv_user ).

    cl_abap_unit_assert=>assert_initial( mi_message->get_text( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_user
      exp = `unchanged` ).
  ENDMETHOD.

  METHOD returning_value.
    cl_abap_testdouble=>configure_call( mi_message )->returning( `hello` ).
    mi_message->get_text( ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_text( )
      exp = `hello` ).
  ENDMETHOD.

  METHOD returning_used_up_repeats.
    cl_abap_testdouble=>configure_call( mi_message )->returning( `hello` ).
    mi_message->get_text( ).

    mi_message->get_text( ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_text( )
      exp = `hello` ).
  ENDMETHOD.

  METHOD times_then_next_configuration.
    cl_abap_testdouble=>configure_call( mi_message )->returning( `first` )->times( 2 ).
    mi_message->get_text( ).
    cl_abap_testdouble=>configure_call( mi_message )->returning( `second` ).
    mi_message->get_text( ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_text( )
      exp = `first` ).
    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_text( )
      exp = `first` ).
    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_text( )
      exp = `second` ).
    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_text( )
      exp = `second` ).
  ENDMETHOD.

  METHOD times_zero_raises.
    TRY.
        cl_abap_testdouble=>configure_call( mi_message )->times( 0 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_atd_exception_core.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD arguments_must_match.
    cl_abap_testdouble=>configure_call( mi_request )->returning( `x` ).
    mi_request->get_uri_parameter( 'X' ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_request->get_uri_parameter( 'X' )
      exp = `x` ).
    cl_abap_unit_assert=>assert_initial( mi_request->get_uri_parameter( 'Y' ) ).
  ENDMETHOD.

  METHOD arguments_converted.
    DATA lv_version TYPE i.

    cl_abap_testdouble=>configure_call( mi_request )->and_expect( )->is_called_once( ).
    mi_request->set_version( '5' ).

    lv_version = 5.
    mi_request->set_version( lv_version ).
    mi_request->set_version( 6 ).

    cl_abap_testdouble=>verify_expectations( mi_request ).
  ENDMETHOD.

  METHOD optional_left_out.
    cl_abap_testdouble=>configure_call( mi_message )->returning( `short` ).
    mi_message->get_longtext( ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_longtext( )
      exp = `short` ).
    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_longtext( preserve_newlines = abap_false )
      exp = `short` ).
    cl_abap_unit_assert=>assert_initial( mi_message->get_longtext( preserve_newlines = abap_true ) ).
  ENDMETHOD.

  METHOD ignore_parameter.
    cl_abap_testdouble=>configure_call( mi_request )->ignore_parameter( 'name' )->returning( `any` ).
    mi_request->get_uri_parameter( 'X' ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_request->get_uri_parameter( 'Y' )
      exp = `any` ).
  ENDMETHOD.

  METHOD ignore_unknown_raises.
    cl_abap_testdouble=>configure_call( mi_request )->ignore_parameter( 'UNKNOWN' )->returning( `any` ).
    TRY.
        mi_request->get_uri_parameter( 'X' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_atd_exception_core.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD ignore_all_parameters.
    cl_abap_testdouble=>configure_call( mi_request )->ignore_all_parameters( )->returning( `any` )->times( 2 ).
    mi_request->get_uri_parameter( 'X' ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_request->get_uri_parameter( 'Y' )
      exp = `any` ).
    cl_abap_unit_assert=>assert_equals(
      act = mi_request->get_uri_parameter( 'Z' )
      exp = `any` ).
  ENDMETHOD.

  METHOD set_parameter_exporting.
    DATA lv_user      TYPE string.
    DATA lv_auth_type TYPE i.

    cl_abap_testdouble=>configure_call( mi_request
      )->set_parameter( name  = 'USERNAME'
                        value = 'user' )->set_parameter( name  = 'auth_type'
                                                         value = '3' ).
    mi_request->get_authorization( ).

    mi_request->get_authorization(
      IMPORTING
        auth_type = lv_auth_type
        username  = lv_user ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_user
      exp = `user` ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_auth_type
      exp = 3 ).
  ENDMETHOD.

  METHOD set_parameter_changing.
    DATA lv_data TYPE string.

    cl_abap_testdouble=>configure_call( mi_request )->set_parameter(
      name  = 'DATA'
      value = `filled` ).
    mi_request->get_form_data(
      EXPORTING
        name = `field`
      CHANGING
        data = lv_data ).

    mi_request->get_form_data(
      EXPORTING
        name = `field`
      CHANGING
        data = lv_data ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_data
      exp = `filled` ).
  ENDMETHOD.

  METHOD set_parameter_unknown_raises.
    cl_abap_testdouble=>configure_call( mi_request )->set_parameter(
      name  = 'NAME'
      value = `importing` ).
    TRY.
        mi_request->get_uri_parameter( 'X' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_atd_exception_core.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD returning_without_raises.
    cl_abap_testdouble=>configure_call( mi_request )->returning( `value` ).
    TRY.
        mi_request->set_method( `GET` ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_atd_exception_core.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD raise_exception.
    DATA lx_zero TYPE REF TO cx_sy_zerodivide.

    CREATE OBJECT lx_zero.
    cl_abap_testdouble=>configure_call( mi_message )->raise_exception( lx_zero ).
    mi_message->get_text( ).

    TRY.
        mi_message->get_text( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_zerodivide.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD raise_with_returning_raises.
    DATA lx_zero TYPE REF TO cx_sy_zerodivide.

    CREATE OBJECT lx_zero.
    TRY.
        cl_abap_testdouble=>configure_call( mi_message )->returning( `text` )->raise_exception( lx_zero ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_atd_exception_core.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD answer_returning.
    DATA lo_answer TYPE REF TO lcl_answer.

    CREATE OBJECT lo_answer.
    cl_abap_testdouble=>configure_call( mi_request )->ignore_all_parameters( )->times( 2 )->set_answer( lo_answer ).
    mi_request->get_uri_parameter( '' ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_request->get_uri_parameter( 'A' )
      exp = `value of A` ).
    cl_abap_unit_assert=>assert_equals(
      act = mi_request->get_uri_parameter( 'B' )
      exp = `value of B` ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_answer->mv_method_name
      exp = 'IF_HTTP_REQUEST~GET_URI_PARAMETER' ).
  ENDMETHOD.

  METHOD answer_exporting_changing.
    DATA lo_answer TYPE REF TO lcl_answer.
    DATA lv_user   TYPE string.
    DATA lv_data   TYPE string.

    CREATE OBJECT lo_answer.
    cl_abap_testdouble=>configure_call( mi_request )->set_answer( lo_answer ).
    mi_request->get_authorization( ).
    cl_abap_testdouble=>configure_call( mi_request )->ignore_all_parameters( )->set_answer( lo_answer ).
    mi_request->get_form_data(
      EXPORTING
        name = ``
      CHANGING
        data = lv_data ).

    mi_request->get_authorization( IMPORTING username = lv_user ).
    lv_data = `before`.
    mi_request->get_form_data(
      EXPORTING
        name = `field`
      CHANGING
        data = lv_data ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_user
      exp = `answered` ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_data
      exp = `changed` ).
  ENDMETHOD.

  METHOD answer_raises.
    DATA lo_answer TYPE REF TO lcl_answer.

    CREATE OBJECT lo_answer.
    CREATE OBJECT lo_answer->mo_exception TYPE cx_sy_zerodivide.
    cl_abap_testdouble=>configure_call( mi_message )->set_answer( lo_answer ).
    mi_message->get_text( ).

    TRY.
        mi_message->get_text( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_zerodivide.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD answer_arguments.
    DATA lo_answer TYPE REF TO lcl_answer.
    DATA lv_data   TYPE string.

    CREATE OBJECT lo_answer.
    cl_abap_testdouble=>configure_call( mi_request )->ignore_all_parameters( )->set_answer( lo_answer ).
    mi_request->get_form_data(
      EXPORTING
        name = ``
      CHANGING
        data = lv_data ).

    mi_request->get_form_data(
      EXPORTING
        name = `field`
      CHANGING
        data = lv_data ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_answer->mv_size
      exp = 2 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_answer->mv_names
      exp = `NAME:I DATA:C ` ).
  ENDMETHOD.

  METHOD matcher.
    DATA lo_matcher TYPE REF TO lcl_matcher.

    CREATE OBJECT lo_matcher.
    cl_abap_testdouble=>configure_call( mi_request )->set_matcher( lo_matcher )->returning( `matched` )->times( 2 ).
    mi_request->get_uri_parameter( 'abc' ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_request->get_uri_parameter( 'ABC' )
      exp = `matched` ).
    cl_abap_unit_assert=>assert_initial( mi_request->get_uri_parameter( 'XYZ' ) ).
  ENDMETHOD.

  METHOD expect_times_verified.
    cl_abap_testdouble=>configure_call( mi_request )->and_expect( )->is_called_times( 2 ).
    mi_request->set_method( `GET` ).

    mi_request->set_method( `GET` ).
    mi_request->set_method( `POST` ).
    mi_request->set_method( `GET` ).

    cl_abap_testdouble=>verify_expectations( mi_request ).
  ENDMETHOD.

  METHOD expect_too_few_fails.
    cl_abap_testdouble=>configure_call( mi_request )->and_expect( )->is_called_times( 2 ).
    mi_request->set_method( `GET` ).

    mi_request->set_method( `GET` ).

    TRY.
        cl_abap_testdouble=>verify_expectations( mi_request ).
      CATCH kernel_cx_assert.
        RETURN.
    ENDTRY.
    cl_abap_unit_assert=>fail( 'verify_expectations must fail' ).
  ENDMETHOD.

  METHOD expect_too_many_fails.
    cl_abap_testdouble=>configure_call( mi_request )->and_expect( )->is_called_once( ).
    mi_request->set_method( `GET` ).

    mi_request->set_method( `GET` ).
    TRY.
        mi_request->set_method( `GET` ).
      CATCH kernel_cx_assert.
        RETURN.
    ENDTRY.
    cl_abap_unit_assert=>fail( 'the second call must fail' ).
  ENDMETHOD.

  METHOD expect_never_called.
    cl_abap_testdouble=>configure_call( mi_request )->ignore_all_parameters( )->and_expect( )->is_never_called( ).
    mi_request->set_method( `GET` ).

    cl_abap_testdouble=>verify_expectations( mi_request ).
  ENDMETHOD.

  METHOD no_double_raises.
    DATA lo_object TYPE REF TO object.

    CREATE OBJECT lo_object TYPE lcl_matcher.
    TRY.
        cl_abap_testdouble=>configure_call( lo_object ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_atd_exception_core.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD doubles_are_independent.
    DATA li_other TYPE REF TO if_message.

    li_other ?= cl_abap_testdouble=>create( 'IF_MESSAGE' ).
    cl_abap_testdouble=>configure_call( mi_message )->returning( `first` ).
    mi_message->get_text( ).
    cl_abap_testdouble=>configure_call( li_other )->returning( `other` ).
    li_other->get_text( ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_message->get_text( )
      exp = `first` ).
    cl_abap_unit_assert=>assert_equals(
      act = li_other->get_text( )
      exp = `other` ).
  ENDMETHOD.

  METHOD returning_object.
    cl_abap_testdouble=>configure_call( mi_request )->returning( mi_request ).
    mi_request->copy( ).

    cl_abap_unit_assert=>assert_equals(
      act = mi_request->copy( )
      exp = mi_request ).
  ENDMETHOD.

ENDCLASS.
