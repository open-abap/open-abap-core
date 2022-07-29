CLASS ltcl_message_helper DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PUBLIC SECTION.
    INTERFACES if_message.

  PRIVATE SECTION.
    METHODS set_msg_vars_for_clike FOR TESTING RAISING cx_root.
    METHODS set_msg_vars_for_if_msg_initial FOR TESTING RAISING cx_root.
    METHODS set_msg_vars_for_if_msg_text FOR TESTING RAISING cx_root.

ENDCLASS.

CLASS ltcl_message_helper IMPLEMENTATION.

  METHOD if_message~get_text.
    result = 'hello world'.
  ENDMETHOD.

  METHOD if_message~get_longtext.
    ASSERT 1 = 'unexpected call'.
  ENDMETHOD.

  METHOD set_msg_vars_for_if_msg_initial.
    DATA lv_str TYPE string.
    DATA li_text TYPE REF TO if_message.
    TRY.
        cl_message_helper=>set_msg_vars_for_if_msg(
          EXPORTING
            text   = li_text
          IMPORTING
            string = lv_str ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_message_illegal_text.
    ENDTRY.
  ENDMETHOD.

  METHOD set_msg_vars_for_if_msg_text.
    DATA lv_str TYPE string.
    cl_message_helper=>set_msg_vars_for_if_msg(
      EXPORTING
        text   = me
      IMPORTING
        string = lv_str ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-msgv1
      exp = 'hello world' ).
  ENDMETHOD.

  METHOD set_msg_vars_for_clike.
    cl_message_helper=>set_msg_vars_for_clike( 'hello' ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-msgv1
      exp = 'hello' ).
  ENDMETHOD.

ENDCLASS.