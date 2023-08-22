CLASS cl_gui_container DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA screen0 TYPE REF TO cl_gui_container.
    CLASS-DATA default_screen TYPE REF TO cl_gui_container.
    CONSTANTS visible_true TYPE c LENGTH 1 VALUE '1'.
    CONSTANTS visible_false TYPE c LENGTH 1 VALUE '0'.

    METHODS free.
ENDCLASS.

CLASS cl_gui_container IMPLEMENTATION.
  METHOD free.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.
ENDCLASS.