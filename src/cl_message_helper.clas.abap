CLASS cl_message_helper DEFINITION PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS set_msg_vars_for_if_msg
      IMPORTING
        msg TYPE REF TO if_message.

ENDCLASS.

CLASS cl_message_helper IMPLEMENTATION.
  METHOD set_msg_vars_for_if_msg.
    ASSERT 'todo' = 1.
  ENDMETHOD.
ENDCLASS.