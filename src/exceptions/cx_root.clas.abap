CLASS cx_root DEFINITION ABSTRACT PUBLIC.
  PUBLIC SECTION.
    DATA previous     TYPE REF TO cx_root READ-ONLY.
    DATA textid       TYPE c LENGTH 32 READ-ONLY.
    DATA kernel_errid TYPE char30 READ-ONLY.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL.

    METHODS get_source_position
      EXPORTING
        program_name TYPE syrepid
        include_name TYPE syrepid
        source_line  TYPE i.

    INTERFACES if_message.
    ALIASES get_longtext FOR if_message~get_longtext.
    ALIASES get_text FOR if_message~get_text.

ENDCLASS.

CLASS cx_root IMPLEMENTATION.

  METHOD constructor.
    me->previous = previous.
    me->textid = textid.
  ENDMETHOD.

  METHOD get_source_position.
    CLEAR program_name.
    CLEAR include_name.
    CLEAR source_line.

    " EXTRA_CX is attached by the transpiled RAISE statement. An exception the
    " runtime raises itself - a conversion error, a division by zero - never
    " goes through RAISE, so it has no EXTRA_CX, and reading through it threw
    " a TypeError before the fallbacks below could be reached.
    WRITE '@KERNEL source_line.set(this.EXTRA_CX?.INTERNAL_LINE || 1);'.
    WRITE '@KERNEL program_name.set(this.EXTRA_CX?.INTERNAL_FILENAME || "error");'.
  ENDMETHOD.

  METHOD if_message~get_longtext.
    result = 'OpenAbapGetLongtextDummyValue'.
  ENDMETHOD.

  METHOD if_message~get_text.
    result = cl_message_helper=>get_text_for_message( me ).
  ENDMETHOD.

ENDCLASS.
