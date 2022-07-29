CLASS lcx_test1 DEFINITION INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    METHODS constructor
      IMPORTING
        message TYPE string.
ENDCLASS.

CLASS lcx_test1 IMPLEMENTATION.
  METHOD constructor.
    super->constructor( previous = previous ).
    cl_message_helper=>set_msg_vars_for_clike( message ).
    if_t100_message~t100key-attr1 = 'IF_T100_DYN_MSG~MSGV1'.
    if_t100_message~t100key-attr2 = 'IF_T100_DYN_MSG~MSGV2'.
    if_t100_message~t100key-attr3 = 'IF_T100_DYN_MSG~MSGV3'.
    if_t100_message~t100key-attr4 = 'IF_T100_DYN_MSG~MSGV4'.
    if_t100_dyn_msg~msgty = 'E'.
    if_t100_dyn_msg~msgv1 = sy-msgv1.
    if_t100_dyn_msg~msgv2 = sy-msgv2.
    if_t100_dyn_msg~msgv3 = sy-msgv3.
    if_t100_dyn_msg~msgv4 = sy-msgv4.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_message_helper DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PUBLIC SECTION.
    INTERFACES if_message.

  PRIVATE SECTION.
    METHODS set_msg_vars_for_clike FOR TESTING RAISING cx_root.
    METHODS set_msg_vars_for_if_msg_initial FOR TESTING RAISING cx_root.
    METHODS set_msg_vars_for_if_msg_text FOR TESTING RAISING cx_root.
    METHODS set_msg_vars_for_if_msg_dyn FOR TESTING RAISING cx_root.

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

  METHOD set_msg_vars_for_if_msg_dyn.
    DATA ref TYPE REF TO lcx_test1.
    CREATE OBJECT ref EXPORTING message = 'hello world'.
    cl_abap_unit_assert=>assert_equals(
      act = ref->get_text( )
      exp = 'I::000 hello world' ).

    cl_message_helper=>set_msg_vars_for_if_msg( ref ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-msgid
      exp = '' ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-msgty
      exp = '' ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-msgno
      exp = '000' ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-msgv1
      exp = 'hello world' ).
  ENDMETHOD.

ENDCLASS.