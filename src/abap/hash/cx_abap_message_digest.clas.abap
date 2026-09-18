CLASS cx_abap_message_digest DEFINITION PUBLIC INHERITING FROM cx_static_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF unknown_algorithm,
        msgid TYPE symsgid VALUE 'MD5',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'ALGORITHM',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF unknown_algorithm.
    CONSTANTS:
      BEGIN OF param_error,
        msgid TYPE symsgid VALUE 'MD5',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF param_error.
    CONSTANTS:
      BEGIN OF conv_error,
        msgid TYPE symsgid VALUE 'MD5',
        msgno TYPE symsgno VALUE '021',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF conv_error.
    CONSTANTS:
      BEGIN OF key_error,
        msgid TYPE symsgid VALUE 'MD5',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF key_error.

    DATA algorithm TYPE string READ-ONLY.
    DATA rc        TYPE i READ-ONLY.

    METHODS constructor
      IMPORTING
        textid    LIKE if_t100_message=>t100key OPTIONAL
        previous  LIKE previous OPTIONAL
        algorithm TYPE string OPTIONAL
        rc        TYPE i DEFAULT 0.

ENDCLASS.

CLASS cx_abap_message_digest IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->algorithm = algorithm.
    me->rc        = rc.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
