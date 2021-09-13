* https://nodejs.org/api/net.html

CLASS lcl_message DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_apc_wsp_message.
  PRIVATE SECTION.
    DATA mv_data TYPE xstring.
ENDCLASS.

CLASS lcl_message IMPLEMENTATION.
  METHOD if_apc_wsp_message~get_binary.
    rv_binary = mv_data.
  ENDMETHOD.

  METHOD if_apc_wsp_message~set_binary.
    mv_data = iv_binary.
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
        iv_port TYPE i
        io_handler TYPE REF TO if_apc_wsp_event_handler.
  PRIVATE SECTION.
    DATA mv_host TYPE string.
    DATA mv_port TYPE i.
    DATA mo_handler TYPE REF TO if_apc_wsp_event_handler.
ENDCLASS.

CLASS lcl_client IMPLEMENTATION.
  METHOD constructor.
    ASSERT iv_host IS NOT INITIAL.
    ASSERT iv_port IS NOT INITIAL.
    ASSERT io_handler IS NOT INITIAL.
    mv_host = iv_host.
    mv_port = iv_port.
    mo_handler = io_handler.
  ENDMETHOD.

  METHOD if_apc_wsp_client~connect.
    WRITE '@KERNEL const net = await import("net");'.
    WRITE '@KERNEL this.client = net.createConnection({ port: this.mv_port.get(), host: this.mv_host.get()}, () => {this.mo_handler.get().if_apc_wsp_event_handler$on_open();});'.
    WRITE '@KERNEL this.client.on("data", async (data) => {'.
    WRITE '@KERNEL   const msg = await (new lcl_message().constructor_());'.
    WRITE '@KERNEL   await msg.if_apc_wsp_message$set_binary({iv_binary: data.toString("hex").toUpperCase()});'.
*    WRITE '@KERNEL   console.dir(data);'.
    WRITE '@KERNEL   await this.mo_handler.get().if_apc_wsp_event_handler$on_message({i_message: msg});'.
    WRITE '@KERNEL });'.
    WRITE '@KERNEL this.client.on("end",   async () => {this.mo_handler.get().if_apc_wsp_event_handler$on_close();});'.
    WRITE '@KERNEL this.client.on("error", async (e) => {this.mo_handler.get().if_apc_wsp_event_handler$on_error();});'.
    WRITE '@KERNEL await new Promise(resolve => this.client.once("connect", resolve));'.
  ENDMETHOD.

  METHOD if_apc_wsp_client~get_message_manager.
    ri_manager = me.
  ENDMETHOD.

  METHOD if_apc_wsp_message_manager~create_message.
    CREATE OBJECT ri_message TYPE lcl_message.
  ENDMETHOD.

  METHOD if_apc_wsp_message_manager~send.
    WRITE '@KERNEL const val = await ii_message.get().if_apc_wsp_message$get_binary();'.
    WRITE '@KERNEL this.client.write(Buffer.from(val.get(), "hex"));'.
  ENDMETHOD.
ENDCLASS.