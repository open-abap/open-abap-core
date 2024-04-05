CLASS cl_oauth2_client DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oauth2_client.

    CLASS-METHODS create
      IMPORTING
        i_profile               TYPE oa2c_profile
        i_configuration         TYPE oa2c_configuration OPTIONAL
      RETURNING
        VALUE(ro_oauth2_client) TYPE REF TO if_oauth2_client
      RAISING
        cx_oa2c.

  PRIVATE SECTION.
    DATA mo_config_writer_api TYPE REF TO cl_oa2c_config_writer_api.
    DATA mv_token             TYPE string.
    DATA mv_scope             TYPE string.
ENDCLASS.

CLASS cl_oauth2_client IMPLEMENTATION.

  METHOD create.

    DATA lo_client TYPE REF TO cl_oauth2_client.
    DATA lv_scope  TYPE string.

    WRITE '@KERNEL const scopes = abap.OA2P[i_profile.get().toUpperCase().trimEnd()].scopes;'.
    WRITE '@KERNEL lv_scope.set(scopes[0]);'.

    CREATE OBJECT lo_client.
    lo_client->mo_config_writer_api = cl_oa2c_config_writer_api=>load( i_configuration ).
    lo_client->mv_scope = lv_scope.

    ro_oauth2_client ?= lo_client.

  ENDMETHOD.

  METHOD if_oauth2_client~execute_cc_flow.

    DATA lv_text          TYPE string.
    DATA lv_code          TYPE i.
    DATA lv_message       TYPE string.
    DATA lv_cdata         TYPE string.
    DATA lv_client_id     TYPE string.
    DATA lv_client_secret TYPE string.
    DATA lv_endpoint      TYPE string.
    DATA lv_path          TYPE string.
    DATA li_http_client   TYPE REF TO if_http_client.


    mo_config_writer_api->read(
      IMPORTING
        e_client_id      = lv_client_id
        e_token_endpoint = lv_endpoint
        e_target_path    = lv_path ).

    WRITE '@KERNEL lv_client_secret.set(this.mo_config_writer_api.get().ms_config.get().client_secret);'.

    cl_http_client=>create_by_url(
      EXPORTING
        url                = lv_endpoint && lv_path
      IMPORTING
        client             = li_http_client
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_oa2c.
    ENDIF.

    li_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

    li_http_client->request->set_method( 'POST' ).

    li_http_client->request->set_form_field(
      name  = 'grant_type'
      value = 'client_credentials' ).
    li_http_client->request->set_form_field(
      name  = 'client_id'
      value = lv_client_id ).
    li_http_client->request->set_form_field(
      name  = 'scope'
      value = mv_scope ).
    li_http_client->request->set_form_field(
      name  = 'client_secret'
      value = lv_client_secret ).
    li_http_client->request->set_content_type( 'application/x-www-form-urlencoded' ).

    li_http_client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_oa2c.
    ENDIF.

    li_http_client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4 ).
    IF sy-subrc <> 0.
      li_http_client->get_last_error(
        IMPORTING
          code    = lv_code
          message = lv_message ).
      RAISE EXCEPTION TYPE cx_oa2c.
    ENDIF.

    li_http_client->response->get_status( IMPORTING code = lv_code ).
    lv_cdata = li_http_client->response->get_cdata( ).
    li_http_client->close( ).

    IF lv_code <> 200.
      RAISE EXCEPTION TYPE cx_oa2c.
    ENDIF.

    FIND REGEX |"access_token":"([\\w\\.-]+)"| IN lv_cdata SUBMATCHES mv_token.
    ASSERT sy-subrc = 0.

  ENDMETHOD.

  METHOD if_oauth2_client~set_token.
    IF mv_token IS INITIAL.
      RAISE EXCEPTION TYPE cx_oa2c_at_not_available.
    ENDIF.

    io_http_client->request->set_header_field(
      name  = 'Authorization'
      value = |{ mv_token }| ).
  ENDMETHOD.

ENDCLASS.