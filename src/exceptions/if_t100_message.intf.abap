INTERFACE if_t100_message PUBLIC.

  DATA: BEGIN OF t100key,
          msgid TYPE string,
          msgno TYPE string,
          attr1 TYPE string,
          attr2 TYPE string,
          attr3 TYPE string,
          attr4 TYPE string,
        END OF t100key.

  CONSTANTS: default_textid TYPE string VALUE 'default'.

ENDINTERFACE.