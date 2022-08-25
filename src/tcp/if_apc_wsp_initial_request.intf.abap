INTERFACE if_apc_wsp_initial_request PUBLIC.
  METHODS get_form_fields
    IMPORTING
      i_formfield_encoding TYPE i DEFAULT 0
    CHANGING
      c_fields             TYPE if_abap_channel_types=>ty_tihttpnvp
    RAISING
      cx_apc_error.

  METHODS get_header_fields
    CHANGING
      c_fields TYPE if_abap_channel_types=>ty_tihttpnvp
    RAISING
      cx_apc_error.
ENDINTERFACE.