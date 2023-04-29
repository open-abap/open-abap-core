CLASS cx_root DEFINITION ABSTRACT PUBLIC.

  PUBLIC SECTION.
    DATA previous TYPE REF TO cx_root.
    DATA textid   TYPE c LENGTH 32.

    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL.

    METHODS get_source_position
      EXPORTING
        program_name TYPE string
        include_name TYPE string
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
    ASSERT 'todo' = 1.
  ENDMETHOD.

  METHOD if_message~get_longtext.
    result = 'OpenAbapGetLongtextDummyValue'.
  ENDMETHOD.

  METHOD if_message~get_text.
    result = cl_message_helper=>get_text_for_message( me ).
  ENDMETHOD.

ENDCLASS.