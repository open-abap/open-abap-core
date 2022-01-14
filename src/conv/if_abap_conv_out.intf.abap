INTERFACE if_abap_conv_out PUBLIC.

  METHODS convert
    IMPORTING
      source TYPE string
    RETURNING
      VALUE(result) TYPE xstring
    RAISING
      cx_sy_conversion_codepage.

ENDINTERFACE.