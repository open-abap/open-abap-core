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
ENDCLASS.

CLASS cl_oauth2_client IMPLEMENTATION.

  METHOD create.
* todo, throw cx_oa2c_config_not_found

    DATA lo_client TYPE REF TO cl_oauth2_client.

    WRITE '@KERNEL const scopes = abap.OA2P[i_profile.get().toUpperCase()].scopes;'.

    CREATE OBJECT lo_client.
    lo_client->mo_config_writer_api = cl_oa2c_config_writer_api=>load( i_configuration ).

    ro_oauth2_client ?= lo_client.

  ENDMETHOD.

  METHOD if_oauth2_client~execute_cc_flow.
    WRITE / 'todo, cl_oauth2_client in open-abap-core, execute_cc_flow()'.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_oauth2_client~set_token.
    WRITE / 'todo, cl_oauth2_client in open-abap-core, set_token()'.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.