* https://nodejs.org/api/net.html

CLASS lcl_message DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_apc_wsp_message.
ENDCLASS.

CLASS lcl_message IMPLEMENTATION.
  METHOD if_apc_wsp_message~get_binary.
    RETURN. " todo
  ENDMETHOD.

  METHOD if_apc_wsp_message~set_binary.
    RETURN. " todo
  ENDMETHOD.
ENDCLASS.

********************************

CLASS lcl_client DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_apc_wsp_client.
    INTERFACES if_apc_wsp_message_manager.
    METHODS constructor
      IMPORTING 
        iv_host TYPE string
        iv_port TYPE i.
  PRIVATE SECTION.
    DATA mv_host TYPE string.
    DATA mv_port TYPE i.
ENDCLASS.

CLASS lcl_client IMPLEMENTATION.
  METHOD constructor.
    ASSERT iv_host IS NOT INITIAL.
    ASSERT iv_port IS NOT INITIAL.
    mv_host = iv_host.
    mv_port = iv_port.
  ENDMETHOD.

  METHOD if_apc_wsp_client~connect.
    WRITE / 'connect'.

    WRITE '@KERNEL const net = await import("net");'.
    WRITE '@KERNEL const client = net.createConnection({ port: this.mv_port.get(), host: this.mv_host.get()}, () => {console.log("connected to server!");});'.
    WRITE '@KERNEL client.on("data", (data) => {console.log(data.toString()); client.end();});'.
    WRITE '@KERNEL client.on("end", () => {console.log("disconnected");});'.
    WRITE '@KERNEL client.on("error", (e) => {console.log("net error");console.dir(e);});'.
    WRITE '@KERNEL await new Promise(resolve => client.once("connect", resolve));'.
  ENDMETHOD.

  METHOD if_apc_wsp_client~get_message_manager.
    ri_manager = me.
  ENDMETHOD.

  METHOD if_apc_wsp_message_manager~create_message.
    CREATE OBJECT ri_message TYPE lcl_message.
  ENDMETHOD.

  METHOD if_apc_wsp_message_manager~send.
    RETURN. " todo
  ENDMETHOD.
ENDCLASS.