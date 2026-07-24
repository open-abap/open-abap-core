CLASS ltcl_oauth2_client DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION MEDIUM FINAL.

  PRIVATE SECTION.
    METHODS create_client
      IMPORTING
        configuration TYPE oa2c_configuration
        path          TYPE string
      RETURNING
        VALUE(result) TYPE REF TO if_oauth2_client
      RAISING
        cx_oa2c.

    METHODS successful_flow FOR TESTING RAISING cx_static_check.
    METHODS spaced_json FOR TESTING RAISING cx_static_check.
    METHODS token_not_available FOR TESTING RAISING cx_static_check.
    METHODS unauthorized FOR TESTING RAISING cx_static_check.
    METHODS missing_token FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_oauth2_client IMPLEMENTATION.

  METHOD create_client.
    DATA config TYPE REF TO cl_oa2c_config_writer_api.

    config = cl_oa2c_config_writer_api=>create(
      i_client_id            = 'test-client'
      i_client_secret        = 'test-secret'
      i_profile              = 'ZTEST'
      i_configuration        = configuration
      i_configured_granttype = cl_oa2c_config_writer_api=>c_granttype_cc
      i_token_endpoint       = 'http://localhost:8081'
      i_target_path          = path ).
    config->save( ).

    result = cl_oauth2_client=>create(
      i_profile       = 'ZTEST'
      i_configuration = configuration ).
  ENDMETHOD.

  METHOD successful_flow.
    DATA oauth_client TYPE REF TO if_oauth2_client.
    DATA http_client TYPE REF TO if_http_client.

    oauth_client = create_client(
      configuration = 'SUCCESS'
      path          = '/token' ).
    oauth_client->execute_cc_flow( ).

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://example.com'
      IMPORTING
        client = http_client ).
    oauth_client->set_token( http_client ).

    cl_abap_unit_assert=>assert_equals(
      act = http_client->request->get_header_field( 'Authorization' )
      exp = 'Bearer test-token' ).
  ENDMETHOD.

  METHOD spaced_json.
    DATA oauth_client TYPE REF TO if_oauth2_client.
    DATA http_client TYPE REF TO if_http_client.

    oauth_client = create_client(
      configuration = 'SPACED_JSON'
      path          = '/spaced-token' ).
    oauth_client->execute_cc_flow( ).

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://example.com'
      IMPORTING
        client = http_client ).
    oauth_client->set_token( http_client ).

    cl_abap_unit_assert=>assert_equals(
      act = http_client->request->get_header_field( 'Authorization' )
      exp = 'Bearer spaced-token' ).
  ENDMETHOD.

  METHOD token_not_available.
    DATA oauth_client TYPE REF TO if_oauth2_client.
    DATA http_client TYPE REF TO if_http_client.

    oauth_client = create_client(
      configuration = 'NO_TOKEN'
      path          = '/token' ).
    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://example.com'
      IMPORTING
        client = http_client ).

    TRY.
        oauth_client->set_token( http_client ).
        cl_abap_unit_assert=>fail( 'Expected CX_OA2C_AT_NOT_AVAILABLE' ).
      CATCH cx_oa2c_at_not_available.
    ENDTRY.
  ENDMETHOD.

  METHOD unauthorized.
    DATA oauth_client TYPE REF TO if_oauth2_client.

    oauth_client = create_client(
      configuration = 'UNAUTHORIZED'
      path          = '/unauthorized' ).

    TRY.
        oauth_client->execute_cc_flow( ).
        cl_abap_unit_assert=>fail( 'Expected CX_OA2C' ).
      CATCH cx_oa2c.
    ENDTRY.
  ENDMETHOD.

  METHOD missing_token.
    DATA oauth_client TYPE REF TO if_oauth2_client.

    oauth_client = create_client(
      configuration = 'MISSING_TOKEN'
      path          = '/missing-token' ).

    TRY.
        oauth_client->execute_cc_flow( ).
        cl_abap_unit_assert=>fail( 'Expected CX_OA2C' ).
      CATCH cx_oa2c.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
