CLASS cl_aunit_factory DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS create_task
      IMPORTING
        listener      TYPE REF TO if_aunit_listener
      RETURNING
        VALUE(result) TYPE REF TO if_aunit_task.

    METHODS get_text_converter
      RETURNING
        VALUE(result) TYPE REF TO if_aunit_text_description.
ENDCLASS.

CLASS cl_aunit_factory IMPLEMENTATION.

  METHOD create_task.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_text_converter.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
