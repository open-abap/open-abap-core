INTERFACE if_t100_message PUBLIC.

  DATA: BEGIN OF t100key,
          msgid TYPE string,
          msgno TYPE string,
          attr1 TYPE string,
          attr2 TYPE string,
          attr3 TYPE string,
          attr4 TYPE string,
        END OF t100key.

  CONSTANTS:
    BEGIN OF default_textid,
      msgid TYPE string VALUE 'AB',
      msgno TYPE string VALUE '123',
      attr1 TYPE string VALUE '',
      attr2 TYPE string VALUE '',
      attr3 TYPE string VALUE '',
      attr4 TYPE string VALUE '',
    END OF default_textid.

ENDINTERFACE.