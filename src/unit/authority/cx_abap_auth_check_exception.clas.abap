CLASS cx_abap_auth_check_exception DEFINITION PUBLIC
  INHERITING FROM cx_static_check FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF unassignable_authorization,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF unassignable_authorization,
      BEGIN OF missing_authorization,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF missing_authorization,
      BEGIN OF missing_auth_objset,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF missing_auth_objset,
      BEGIN OF unavailable_auth_in_objset,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF unavailable_auth_in_objset,
      BEGIN OF unavailable_user,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF unavailable_user,
      BEGIN OF unsupported_value_range,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF unsupported_value_range,
      BEGIN OF unavailable_user_in_objset,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF unavailable_user_in_objset,
      BEGIN OF unavailable_auth_obj,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF unavailable_auth_obj,
      BEGIN OF unavailable_auth_obj_id,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF unavailable_auth_obj_id,
      BEGIN OF unavailable_auth_restriction,
        msgid TYPE symsgid VALUE 'ABAP_AUTHORITY_CHECK',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE 'MESSAGE_PREFIX',
      END OF unavailable_auth_restriction.

    DATA message_prefix TYPE string READ-ONLY.
    DATA text TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        textid         LIKE if_t100_message=>t100key OPTIONAL
        previous       LIKE previous OPTIONAL
        text           TYPE string OPTIONAL
        message_prefix TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_abap_auth_check_exception IMPLEMENTATION.
  METHOD constructor.
    super->constructor( previous = previous ).
    me->text = text.
    me->message_prefix = message_prefix.
    if_t100_message~t100key = textid.
  ENDMETHOD.
ENDCLASS.
