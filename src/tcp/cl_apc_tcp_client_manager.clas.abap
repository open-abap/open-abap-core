CLASS cl_apc_tcp_client_manager DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        i_host          TYPE string
        i_port          TYPE i
        i_frame         TYPE if_apc_tcp_frame_types=>ty_frame_type
        i_event_handler TYPE REF TO if_apc_wsp_event_handler
      RETURNING
        VALUE(ri_client) TYPE REF TO if_apc_wsp_client.
ENDCLASS.

CLASS cl_apc_tcp_client_manager IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT ri_client TYPE lcl_client.
  ENDMETHOD.
ENDCLASS.