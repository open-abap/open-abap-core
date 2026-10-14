INTERFACE if_a4c_cp_service PUBLIC.

  TYPES:
    ty_service_instance_name  TYPE c LENGTH 80,
    ty_service_type           TYPE c LENGTH 64,
    ty_service_property_name  TYPE c LENGTH 30,
    ty_service_property_value TYPE c LENGTH 512,
    ty_service_instance_id    TYPE x LENGTH 16,

    BEGIN OF ts_cp_svc_property,
      name  TYPE ty_service_property_name,
      value TYPE ty_service_property_value,
    END OF ts_cp_svc_property,

    BEGIN OF ENUM authn_mode,
      user_propagation,
      service_specific,
    END OF ENUM authn_mode,

    BEGIN OF ENUM authn_type BASE TYPE int4,
      none   VALUE IS INITIAL,
      basic  VALUE 1,
      oauth2 VALUE 2,
    END OF ENUM authn_type,

    tt_cp_svc_properties TYPE STANDARD TABLE OF ts_cp_svc_property WITH KEY name.

  METHODS create_http_client
    IMPORTING
      iv_svc_authentication_mode TYPE authn_mode DEFAULT service_specific
    RETURNING
      VALUE(ro_http_client)      TYPE REF TO if_web_http_client
    RAISING
      cx_web_http_client_error.

  METHODS get_property
    IMPORTING
      iv_property_name TYPE ty_service_property_name
    RETURNING
      VALUE(rv_value)  TYPE ty_service_property_value
    RAISING
      cx_a4c_cp_svc_prop_not_found.

  METHODS get_properties
    RETURNING
      VALUE(rt_properties) TYPE tt_cp_svc_properties.

  METHODS get_connection_details
    RETURNING
      VALUE(rs_details) TYPE tsa4c_cp_svc_conn_details.

ENDINTERFACE.
