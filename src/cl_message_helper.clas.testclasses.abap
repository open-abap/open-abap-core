CLASS ltcl_message_helper DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS set_msg_vars_for_clike FOR TESTING.

ENDCLASS.

CLASS ltcl_message_helper IMPLEMENTATION.

  METHOD set_msg_vars_for_clike.
    cl_message_helper=>set_msg_vars_for_clike( 'hello' ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-msgv1
      exp = 'hello' ).
  ENDMETHOD.

ENDCLASS.