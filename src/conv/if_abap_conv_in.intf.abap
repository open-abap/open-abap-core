INTERFACE if_abap_conv_in PUBLIC.

  METHODS convert
    IMPORTING
      source        TYPE xstring
    RETURNING
      VALUE(result) TYPE string
    RAISING
      cx_sy_conversion_codepage.

ENDINTERFACE.