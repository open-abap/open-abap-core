CLASS cl_apc_tcp_client_manager DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS co_protocol_type_tcp  TYPE i VALUE 1.
    CONSTANTS co_protocol_type_tcps TYPE i VALUE 2.

    CLASS-METHODS create
      IMPORTING
        i_host           TYPE string
        i_port           TYPE string
        i_frame          TYPE if_abap_channel_types=>ty_apc_tcp_frame
        i_event_handler  TYPE REF TO if_apc_wsp_event_handler
        i_protocol       TYPE i DEFAULT co_protocol_type_tcp
        i_ssl_id         TYPE ssfapplssl OPTIONAL
      RETURNING
        VALUE(ri_client) TYPE REF TO if_apc_wsp_client
      RAISING
        cx_apc_error.
ENDCLASS.

CLASS cl_apc_tcp_client_manager IMPLEMENTATION.
  METHOD create.
    DATA lv_port TYPE i.
    lv_port = i_port.
    CREATE OBJECT ri_client TYPE lcl_client
      EXPORTING
        iv_host     = i_host
        iv_port     = lv_port
        io_handler  = i_event_handler
        iv_protocol = i_protocol.
  ENDMETHOD.
ENDCLASS.