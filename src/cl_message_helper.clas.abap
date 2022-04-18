CLASS cl_message_helper DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS set_msg_vars_for_if_msg
      IMPORTING
        text TYPE REF TO if_message
      EXPORTING
        VALUE(string) TYPE string.

    CLASS-METHODS set_msg_vars_for_clike
      IMPORTING
        text TYPE clike.
ENDCLASS.

CLASS cl_message_helper IMPLEMENTATION.

  METHOD set_msg_vars_for_if_msg.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_msg_vars_for_clike.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.