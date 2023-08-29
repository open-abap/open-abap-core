CLASS lcl_handler DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_apc_wsp_event_handler.
    DATA message TYPE xstring.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD if_apc_wsp_event_handler~on_open.
    RETURN.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_message.
*    WRITE / 'on_message'.
    message = i_message->get_binary( ).
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_close.
    RETURN.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_error.
    WRITE / 'on_error'.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_tcp DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION MEDIUM FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_tcp IMPLEMENTATION.

  METHOD test1.
    DATA lo_handler         TYPE REF TO lcl_handler.
    DATA li_client          TYPE REF TO if_apc_wsp_client.
    DATA ls_frame           TYPE if_abap_channel_types=>ty_apc_tcp_frame.
    DATA li_message_manager TYPE REF TO if_apc_wsp_message_manager.
    DATA li_message         TYPE REF TO if_apc_wsp_message.

    CREATE OBJECT lo_handler.

    ls_frame-frame_type   = if_apc_tcp_frame_types=>co_frame_type_fixed_length.
    ls_frame-fixed_length = 10.

    li_client = cl_apc_tcp_client_manager=>create(
      i_host          = 'httpbin.org'
      i_port          = '80'
      i_frame         = ls_frame
      i_event_handler = lo_handler ).

    li_client->connect( ).
    li_message_manager ?= li_client->get_message_manager( ).
    li_message = li_message_manager->create_message( ).
    li_message->set_binary( '11223344556677889900' ).
    li_message_manager->send( li_message ).

    WAIT FOR PUSH CHANNELS
      UNTIL lo_handler->message IS NOT INITIAL
      UP TO 10 SECONDS.

    li_client->close( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = cl_abap_codepage=>convert_from( lo_handler->message )
      exp = 'HTTP/1.1*' ).

  ENDMETHOD.

ENDCLASS.