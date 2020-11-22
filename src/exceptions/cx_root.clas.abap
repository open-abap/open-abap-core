CLASS cx_root DEFINITION ABSTRACT PUBLIC.

  PUBLIC SECTION.
    DATA previous TYPE REF TO cx_root.
    DATA textid TYPE c LENGTH 32.

    METHODS constructor
      IMPORTING
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
    result = 'GetLongtextDummyValue'.
  ENDMETHOD.

  METHOD if_message~get_text.
    result = 'GetTextDummyValue'.
  ENDMETHOD.

ENDCLASS.
