CLASS cx_root DEFINITION PUBLIC.

  PUBLIC SECTION.
    DATA previous TYPE REF TO cx_root.
    DATA textid TYPE c LENGTH 32.

    METHODS: get_source_position.

    INTERFACES if_message.
    ALIASES get_longtext FOR if_message~get_longtext.
    ALIASES get_text FOR if_message~get_text.

ENDCLASS.

CLASS cx_root IMPLEMENTATION.

  METHOD get_source_position.
    ASSERT 'todo' = 1.
  ENDMETHOD.

  METHOD if_message~get_longtext.
    ASSERT 'todo' = 1.
  ENDMETHOD.

  METHOD if_message~get_text.
    ASSERT 'todo' = 1.
  ENDMETHOD.

ENDCLASS.
