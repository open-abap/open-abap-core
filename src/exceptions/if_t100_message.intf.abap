INTERFACE if_t100_message PUBLIC.

  DATA t100key TYPE scx_t100key.

  CONSTANTS:
    BEGIN OF default_textid,
      msgid TYPE symsgid VALUE 'AB',
      msgno TYPE symsgno VALUE '123',
      attr1 TYPE scx_attrname VALUE '',
      attr2 TYPE scx_attrname VALUE '',
      attr3 TYPE scx_attrname VALUE '',
      attr4 TYPE scx_attrname VALUE '',
    END OF default_textid.

ENDINTERFACE.