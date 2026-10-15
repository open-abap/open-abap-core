CLASS cx_abap_foreign_lock DEFINITION PUBLIC INHERITING FROM cx_static_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    TYPES tv_user_name TYPE sy-uname.

    CONSTANTS:
      BEGIN OF cx_abap_foreign_lock,
        msgid TYPE symsgid VALUE 'DD_ABAP_LANG_VERS',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF cx_abap_foreign_lock.
    CONSTANTS:
      BEGIN OF object_locked_by_user,
        msgid TYPE symsgid VALUE 'DD_ABAP_LANG_VERS',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'USER_NAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF object_locked_by_user.

    DATA user_name TYPE tv_user_name READ-ONLY.

    METHODS constructor
      IMPORTING
        textid    LIKE if_t100_message=>t100key OPTIONAL
        previous  LIKE previous OPTIONAL
        user_name TYPE tv_user_name OPTIONAL.

ENDCLASS.

CLASS cx_abap_foreign_lock IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->user_name = user_name.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = cx_abap_foreign_lock.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
