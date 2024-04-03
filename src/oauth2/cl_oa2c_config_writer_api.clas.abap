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
        e_configured_granttype   TYPE oa2c_granttype
        et_configured_scopes     TYPE string_table.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_config,
             configuration          TYPE oa2c_configuration,
             profile                TYPE oa2c_profile,
             client_id              TYPE string,
             client_secret          TYPE string,
             authorization_endpoint TYPE string,
             token_endpoint         TYPE string,
             target_path            TYPE string,
             granttype              TYPE oa2c_granttype,
           END OF ty_config.

* this class currently only saves to memory for testing purposes
    CLASS-DATA mt_saved_configs TYPE STANDARD TABLE OF ty_config WITH DEFAULT KEY.
ENDCLASS.

CLASS cl_oa2c_config_writer_api IMPLEMENTATION.

  METHOD create.
    ASSERT i_configured_granttype = c_granttype_cc.
* todo
  ENDMETHOD.

  METHOD save.
    ASSERT 1 = 2.
  ENDMETHOD.

  METHOD read.
    ASSERT 1 = 2.
  ENDMETHOD.

  METHOD load.
    ASSERT 1 = 2.
  ENDMETHOD.

ENDCLASS.