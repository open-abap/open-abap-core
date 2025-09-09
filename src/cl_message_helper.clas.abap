CLASS cl_message_helper DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS set_msg_vars_for_if_msg
      IMPORTING
        text          TYPE REF TO if_message
      EXPORTING
        VALUE(string) TYPE string.

    CLASS-METHODS set_msg_vars_for_clike
      IMPORTING
        text TYPE clike.

    CLASS-METHODS get_text_for_message
      IMPORTING
        text          TYPE REF TO if_message
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS check_msg_kind
      IMPORTING
        msg     TYPE REF TO object
      EXPORTING
        t100key TYPE scx_t100key
        textid  TYPE sotr_conc.

    CLASS-METHODS get_otr_text_raw
      IMPORTING
        textid TYPE sotr_conc
      EXPORTING
        result TYPE string.

    CLASS-METHODS replace_text_params
      IMPORTING
        obj    TYPE REF TO object
      CHANGING
        result TYPE string.

    CLASS-METHODS get_text_params
      IMPORTING
        obj    TYPE REF TO object
      EXPORTING
        params TYPE any.
  PRIVATE SECTION.
    CONSTANTS gc_fallback TYPE string VALUE 'An exception was raised.'.
ENDCLASS.

CLASS cl_message_helper IMPLEMENTATION.
  METHOD get_text_params.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_otr_text_raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD replace_text_params.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_text_for_message.

    DATA lv_msgid LIKE sy-msgid.
    DATA lv_msgno LIKE sy-msgno.
    DATA lv_msgv1 LIKE sy-msgv1.
    DATA lv_msgv2 LIKE sy-msgv2.
    DATA lv_msgv3 LIKE sy-msgv3.
    DATA lv_msgv4 LIKE sy-msgv4.

* when the transpiler can do more, the below can be implemented in ABAP instead of using KERNEL,
    WRITE '@KERNEL if (text.get()?.if_t100_message$t100key === undefined) { result.set(this.gc_fallback); return result; };'.

    WRITE '@KERNEL lv_msgid.set(text.get().if_t100_message$t100key.get().msgid);'.
    WRITE '@KERNEL lv_msgno.set(text.get().if_t100_message$t100key.get().msgno);'.
    WRITE '@KERNEL lv_msgv1.set(text.get()[text.get().if_t100_message$t100key.get().attr1.get().toLowerCase().replace("~", "$").trimEnd()] ? text.get()[text.get().if_t100_message$t100key.get().attr1.get().toLowerCase().replace("~", "$").trimEnd()].get() : "");'.
    WRITE '@KERNEL lv_msgv2.set(text.get()[text.get().if_t100_message$t100key.get().attr2.get().toLowerCase().replace("~", "$").trimEnd()] ? text.get()[text.get().if_t100_message$t100key.get().attr2.get().toLowerCase().replace("~", "$").trimEnd()].get() : "");'.
    WRITE '@KERNEL lv_msgv3.set(text.get()[text.get().if_t100_message$t100key.get().attr3.get().toLowerCase().replace("~", "$").trimEnd()] ? text.get()[text.get().if_t100_message$t100key.get().attr3.get().toLowerCase().replace("~", "$").trimEnd()].get() : "");'.
    WRITE '@KERNEL lv_msgv4.set(text.get()[text.get().if_t100_message$t100key.get().attr4.get().toLowerCase().replace("~", "$").trimEnd()] ? text.get()[text.get().if_t100_message$t100key.get().attr4.get().toLowerCase().replace("~", "$").trimEnd()].get() : "");'.

    MESSAGE ID lv_msgid TYPE 'I' NUMBER lv_msgno WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4 INTO result.

  ENDMETHOD.

  METHOD set_msg_vars_for_if_msg.
    IF text IS INITIAL.
      RAISE EXCEPTION TYPE cx_sy_message_illegal_text.
    ENDIF.

* first try if_t100_message
    string = get_text_for_message( text ).
    IF string <> gc_fallback.
      CLEAR sy-msgty.
      RETURN.
    ENDIF.

    string = text->get_text( ).
    IF string IS INITIAL.
      ASSERT 1 = 'todo'.
    ENDIF.

    set_msg_vars_for_clike( string ).
  ENDMETHOD.

  METHOD set_msg_vars_for_clike.

    DATA lv_char200 TYPE c LENGTH 200.

    " move to char200 to avoid checking out of bound
    lv_char200 = text.

    sy-msgid = '00'.
    sy-msgno = '001'.

    sy-msgv1 = lv_char200.
    IF lv_char200+49(1) = space.
      lv_char200 = lv_char200+49.
    ELSE.
      lv_char200 = text+50.
    ENDIF.

    sy-msgv2 = lv_char200.
    IF lv_char200+49(1) = space.
      lv_char200 = lv_char200+49.
    ELSE.
      lv_char200 = lv_char200+50.
    ENDIF.

    sy-msgv3 = lv_char200.
    IF lv_char200+49(1) = space.
      lv_char200 = lv_char200+49.
    ELSE.
      lv_char200 = lv_char200+50.
    ENDIF.

    sy-msgv4 = lv_char200.

  ENDMETHOD.

  METHOD check_msg_kind.

    DATA li_t100_message TYPE REF TO if_t100_message.

    TRY.
        li_t100_message ?= msg.
        t100key = li_t100_message->t100key.
      CATCH cx_sy_move_cast_error.
        ASSERT 1 = 'todo'.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.