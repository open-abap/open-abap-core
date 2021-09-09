INTERFACE if_apc_wsp_message PUBLIC.
  METHODS get_binary RETURNING VALUE(rv_binary) TYPE xstring.
  METHODS set_binary IMPORTING iv_binary TYPE xsequence.
ENDINTERFACE.