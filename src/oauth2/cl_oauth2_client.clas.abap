CLASS cl_oauth2_client DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oauth2_client.

    CLASS-METHODS create
      IMPORTING
        i_profile               TYPE oa2c_profile
        i_configuration         TYPE clike OPTIONAL
      RETURNING
        VALUE(ro_oauth2_client) TYPE REF TO if_oauth2_client
      RAISING
        cx_oa2c.
ENDCLASS.

CLASS cl_oauth2_client IMPLEMENTATION.

  METHOD create.
* todo, throw cx_oa2c_config_not_found

    WRITE '@KERNEL const scopes = abap.OA2P[i_profile.get().toUpperCase()].scopes;'.

    WRITE / 'todo, cl_oauth2_client in open-abap-core, create()'.
    ASSERT 1 = 'todo'.
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