CLASS lcl_handler DEFINITION FINAL .
  PUBLIC SECTION.
    INTERFACES if_apc_wsp_event_handler.
    DATA message TYPE xstring.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD if_apc_wsp_event_handler~on_open.
    RETURN.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_message.
    WRITE / 'on_message'.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_close.
    WRITE / 'on_close'.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_error.
    WRITE / 'on_error'.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_tcp DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_tcp IMPLEMENTATION.

  METHOD test1.
    DATA lo_handler         TYPE REF TO lcl_handler.
    DATA li_client          TYPE REF TO if_apc_wsp_client.
    DATA ls_frame           TYPE if_apc_tcp_frame_types=>ty_frame_type.
    DATA li_message_manager TYPE REF TO if_apc_wsp_message_manager.
    DATA li_message         TYPE REF TO if_apc_wsp_message.

    CREATE OBJECT lo_handler.

* todo, set ls_frame details

    li_client = cl_apc_tcp_client_manager=>create(
      i_host          = 'httpbin.org'
      i_port          = 80
      i_frame         = ls_frame
      i_event_handler = lo_handler ).

    li_client->connect( ).
    li_message_manager = li_client->get_message_manager( ).
    li_message = li_message_manager->create_message( ).
    li_message->set_binary( '112233' ).
    li_message_manager->send( li_message ).

    WAIT FOR PUSH CHANNELS
      UNTIL lo_handler->message IS NOT INITIAL
      UP TO 10 SECONDS.

* todo, close connection?

  ENDMETHOD.

ENDCLASS.