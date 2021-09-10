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

CLASS lcl_client DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_apc_wsp_client.
    INTERFACES if_apc_wsp_message_manager.
ENDCLASS.

CLASS lcl_client IMPLEMENTATION.
  METHOD if_apc_wsp_client~connect.
    RETURN. " todo
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