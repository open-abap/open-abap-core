CLASS cx_bcs_mail DEFINITION PUBLIC INHERITING FROM cx_static_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF internal_error,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF internal_error,

      BEGIN OF invalid_recipient,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'ATTRIBUTE1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_recipient,

      BEGIN OF invalid_sender,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'ATTRIBUTE1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_sender,

      BEGIN OF address_initial,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF address_initial,

      BEGIN OF main_content_initial,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF main_content_initial,

      BEGIN OF sender_initial,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF sender_initial,

      BEGIN OF no_recipients,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_recipients,

      BEGIN OF sender_not_allowed,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'ATTRIBUTE1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF sender_not_allowed,

      BEGIN OF recipient_not_allowed,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'ATTRIBUTE1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF recipient_not_allowed,

      BEGIN OF process_addr_not_allowed,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'ATTRIBUTE1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF process_addr_not_allowed,

      BEGIN OF no_related_recipients_found,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_related_recipients_found,

      BEGIN OF mail_guid_missing,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF mail_guid_missing,

      BEGIN OF mail_instance_missing,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '013',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF mail_instance_missing,

      BEGIN OF attachment_invalid,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '402',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF attachment_invalid,

      BEGIN OF mime_error,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '100',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF mime_error,

      BEGIN OF mime_not_found,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '101',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF mime_not_found,

      BEGIN OF send_error,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '200',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF send_error,

      BEGIN OF received_status_initial,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '204',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF received_status_initial,

      BEGIN OF techconf_error,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '300',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF techconf_error,

      BEGIN OF tls_conf_error,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '301',
        attr1 TYPE scx_attrname VALUE 'ATTRIBUTE1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF tls_conf_error,

      BEGIN OF parse_error,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '201',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF parse_error,

      BEGIN OF main_invalid,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '400',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF main_invalid,

      BEGIN OF alternative_invalid,
        msgid TYPE symsgid VALUE 'BCS_MAIL',
        msgno TYPE symsgno VALUE '401',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF alternative_invalid.

    DATA attribute1 TYPE string.
    DATA attribute2 TYPE string.
    DATA attribute3 TYPE string.
    DATA attribute4 TYPE string.

    METHODS constructor
      IMPORTING
        textid     LIKE if_t100_message=>t100key OPTIONAL
        previous   LIKE previous OPTIONAL
        attribute1 TYPE string OPTIONAL
        attribute2 TYPE string OPTIONAL
        attribute3 TYPE string OPTIONAL
        attribute4 TYPE string OPTIONAL.

ENDCLASS.

CLASS cx_bcs_mail IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->attribute1 = attribute1.
    me->attribute2 = attribute2.
    me->attribute3 = attribute3.
    me->attribute4 = attribute4.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
