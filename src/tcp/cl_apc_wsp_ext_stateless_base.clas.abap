CLASS cl_apc_wsp_ext_stateless_base DEFINITION PUBLIC ABSTRACT.
  PUBLIC SECTION.
    INTERFACES if_apc_wsp_extension.
ENDCLASS.

CLASS cl_apc_wsp_ext_stateless_base IMPLEMENTATION.
  METHOD if_apc_wsp_extension~on_start.
    RETURN.
  ENDMETHOD.

  METHOD if_apc_wsp_extension~on_message.
    RETURN.
  ENDMETHOD.
ENDCLASS.