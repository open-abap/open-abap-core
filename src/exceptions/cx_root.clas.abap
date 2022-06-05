CLASS cx_root DEFINITION ABSTRACT PUBLIC.

  PUBLIC SECTION.
    DATA previous TYPE REF TO cx_root.
    DATA textid TYPE c LENGTH 32.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL.

    METHODS get_source_position
      EXPORTING
        program_name TYPE string
        include_name TYPE string
        source_line TYPE string.

    INTERFACES if_message.
    ALIASES get_longtext FOR if_message~get_longtext.
    ALIASES get_text FOR if_message~get_text.

ENDCLASS.

CLASS cx_root IMPLEMENTATION.

  METHOD constructor.
    me->previous = previous.
  ENDMETHOD.

  METHOD get_source_position.
    ASSERT 'todo' = 1.
  ENDMETHOD.

  METHOD if_message~get_longtext.
    result = 'OpenAbapGetLongtextDummyValue'.
  ENDMETHOD.

  METHOD if_message~get_text.

    DATA lv_msgid LIKE sy-msgid.
    DATA lv_msgno LIKE sy-msgno.
    DATA lv_msgv1 LIKE sy-msgv1.
    DATA lv_msgv2 LIKE sy-msgv2.
    DATA lv_msgv3 LIKE sy-msgv3.
    DATA lv_msgv4 LIKE sy-msgv4.

* when the transpiler can do more, the below can be implemented in ABAP instead of using KERNEL,
    WRITE '@KERNEL if (this.if_t100_message$t100key === undefined) { result.set("An exception was raised."); return result; };'.
    WRITE '@KERNEL lv_msgid.set(this.if_t100_message$t100key.get().msgid);'.
    WRITE '@KERNEL lv_msgno.set(this.if_t100_message$t100key.get().msgno);'.
    WRITE '@KERNEL lv_msgv1.set(this[this.if_t100_message$t100key.get().attr1.get().toLowerCase()] ? this[this.if_t100_message$t100key.get().attr1.get().toLowerCase()].get() : "");'.
    WRITE '@KERNEL lv_msgv2.set(this[this.if_t100_message$t100key.get().attr2.get().toLowerCase()] ? this[this.if_t100_message$t100key.get().attr2.get().toLowerCase()].get() : "");'.
    WRITE '@KERNEL lv_msgv3.set(this[this.if_t100_message$t100key.get().attr3.get().toLowerCase()] ? this[this.if_t100_message$t100key.get().attr3.get().toLowerCase()].get() : "");'.
    WRITE '@KERNEL lv_msgv4.set(this[this.if_t100_message$t100key.get().attr4.get().toLowerCase()] ? this[this.if_t100_message$t100key.get().attr4.get().toLowerCase()].get() : "");'.

    MESSAGE ID lv_msgid TYPE 'S' NUMBER lv_msgno WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4 INTO result.

  ENDMETHOD.

ENDCLASS.