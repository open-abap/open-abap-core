CLASS cx_abap_lock_failure DEFINITION PUBLIC INHERITING FROM cx_static_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    TYPES tv_field_name       TYPE c LENGTH 30.
    TYPES tv_field_value      TYPE string.
    TYPES tv_object_name      TYPE c LENGTH 40.
    TYPES tv_object_type_text TYPE c LENGTH 50.

    CONSTANTS:
      BEGIN OF cx_abap_lock_failure,
        msgid TYPE symsgid VALUE 'DD_ABAP_LANG_VERS',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF cx_abap_lock_failure.
    CONSTANTS:
      BEGIN OF param_value_not_allowed,
        msgid TYPE symsgid VALUE 'DD_ABAP_LANG_VERS',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'FIELD_NAME',
        attr2 TYPE scx_attrname VALUE 'FIELD_VALUE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF param_value_not_allowed.
    CONSTANTS:
      BEGIN OF param_value_conversion_error,
        msgid TYPE symsgid VALUE 'DD_ABAP_LANG_VERS',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'FIELD_NAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF param_value_conversion_error.
    CONSTANTS:
      BEGIN OF object_not_to_be_used,
        msgid TYPE symsgid VALUE 'LA',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'OBJECT_TYPE_TEXT',
        attr2 TYPE scx_attrname VALUE 'OBJECT_NAME',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF object_not_to_be_used.

    DATA field_name       TYPE tv_field_name READ-ONLY.
    DATA field_value      TYPE tv_field_value READ-ONLY.
    DATA object_name      TYPE tv_object_name READ-ONLY.
    DATA object_type_text TYPE tv_object_type_text READ-ONLY.

    METHODS constructor
      IMPORTING
        textid           LIKE if_t100_message=>t100key OPTIONAL
        previous         LIKE previous OPTIONAL
        field_name       TYPE tv_field_name OPTIONAL
        field_value      TYPE tv_field_value OPTIONAL
        object_name      TYPE tv_object_name OPTIONAL
        object_type_text TYPE tv_object_type_text OPTIONAL.

ENDCLASS.

CLASS cx_abap_lock_failure IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->field_name       = field_name.
    me->field_value      = field_value.
    me->object_name      = object_name.
    me->object_type_text = object_type_text.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = cx_abap_lock_failure.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
