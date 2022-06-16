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
    sy-msgid = '00'.
    sy-msgno = '001'.
    sy-msgv1 = text.
    IF strlen( text ) > 50.
      sy-msgv2 = text+50.
    ENDIF.
    IF strlen( text ) > 100.
      sy-msgv3 = text+100.
    ENDIF.
    IF strlen( text ) > 150.
      sy-msgv4 = text+150.
    ENDIF.
  ENDMETHOD.

ENDCLASS.