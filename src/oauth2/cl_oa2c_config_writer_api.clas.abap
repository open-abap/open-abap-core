CLASS cl_oa2c_config_writer_api DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS c_granttype_cc TYPE oa2c_granttype VALUE 4.

    CLASS-METHODS create
      IMPORTING
        i_profile                   TYPE oa2c_profile
        i_configuration             TYPE oa2c_configuration OPTIONAL
        i_client_id                 TYPE string
        i_client_secret             TYPE string
        i_authorization_endpoint    TYPE string OPTIONAL
        i_token_endpoint            TYPE string OPTIONAL
        i_target_path               TYPE string OPTIONAL
        i_configured_granttype      TYPE oa2c_granttype DEFAULT 0
      RETURNING
        VALUE(ro_config_writer_api) TYPE REF TO cl_oa2c_config_writer_api
      RAISING
        cx_oa2c.

    CLASS-METHODS load
      IMPORTING
        i_configuration             TYPE oa2c_configuration OPTIONAL
      RETURNING
        VALUE(ro_config_writer_api) TYPE REF TO cl_oa2c_config_writer_api
      RAISING
        cx_oa2c.

    METHODS save
      RAISING
        cx_oa2c.

    METHODS read
      EXPORTING
        e_client_id              TYPE string
        e_authorization_endpoint TYPE string
        e_token_endpoint         TYPE string
        e_target_path            TYPE string
        e_configured_granttype   TYPE oa2c_granttype.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_config,
             configuration          TYPE oa2c_configuration,
             client_id              TYPE string,
             client_secret          TYPE string,
             authorization_endpoint TYPE string,
             token_endpoint         TYPE string,
             target_path            TYPE string,
             granttype              TYPE oa2c_granttype,
           END OF ty_config.

* this class currently only saves to memory for testing purposes
    CLASS-DATA mt_saved_configs TYPE SORTED TABLE OF ty_config WITH UNIQUE KEY configuration.

    DATA ms_config TYPE ty_config.
ENDCLASS.

CLASS cl_oa2c_config_writer_api IMPLEMENTATION.

  METHOD create.
    ASSERT i_configured_granttype = c_granttype_cc.

    CREATE OBJECT ro_config_writer_api.
    ro_config_writer_api->ms_config-configuration = i_configuration.
    ro_config_writer_api->ms_config-client_id = i_client_id.
    ro_config_writer_api->ms_config-client_secret = i_client_secret.
    ro_config_writer_api->ms_config-authorization_endpoint = i_authorization_endpoint.
    ro_config_writer_api->ms_config-token_endpoint = i_token_endpoint.
    ro_config_writer_api->ms_config-target_path = i_target_path.
    ro_config_writer_api->ms_config-granttype = i_configured_granttype.
  ENDMETHOD.

  METHOD save.

    INSERT ms_config INTO TABLE mt_saved_configs.
    ASSERT sy-subrc = 0.

  ENDMETHOD.

  METHOD load.

    DATA ls_config TYPE ty_config.

    READ TABLE mt_saved_configs INTO ls_config WITH KEY configuration = i_configuration.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_oa2c_config_not_found.
    ENDIF.

    CREATE OBJECT ro_config_writer_api.
    ro_config_writer_api->ms_config = ls_config.

  ENDMETHOD.

  METHOD read.

    e_client_id = ms_config-client_id.
    e_authorization_endpoint = ms_config-authorization_endpoint.
    e_token_endpoint = ms_config-token_endpoint.
    e_target_path = ms_config-target_path.
    e_configured_granttype = ms_config-granttype.

  ENDMETHOD.

ENDCLASS.