CLASS cl_apc_tcp_client_manager DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        i_host          TYPE string
        i_port          TYPE string
        i_frame         TYPE if_abap_channel_types=>ty_apc_tcp_frame
        i_event_handler TYPE REF TO if_apc_wsp_event_handler
      RETURNING
        VALUE(ri_client) TYPE REF TO if_apc_wsp_client.
ENDCLASS.

CLASS cl_apc_tcp_client_manager IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT ri_client TYPE lcl_client
      EXPORTING 
        iv_host    = i_host
        iv_port    = i_port
        io_handler = i_event_handler.
  ENDMETHOD.
ENDCLASS.