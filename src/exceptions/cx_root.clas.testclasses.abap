CLASS lcx_error DEFINITION INHERITING FROM cx_root.
  PUBLIC SECTION.
    INTERFACES if_t100_message.

    DATA msgv1 TYPE symsgv READ-ONLY.
    DATA msgv2 TYPE symsgv READ-ONLY.
    DATA msgv3 TYPE symsgv READ-ONLY.
    DATA msgv4 TYPE symsgv READ-ONLY.

    METHODS constructor
      IMPORTING
        textid   LIKE if_t100_message=>t100key OPTIONAL
        msgv1    TYPE symsgv OPTIONAL.
ENDCLASS.

CLASS lcx_error IMPLEMENTATION.
  METHOD constructor.
    me->msgv1 = msgv1.

    if_t100_message~t100key = textid.
  ENDMETHOD.
ENDCLASS.

******************************

CLASS lcx_error2 DEFINITION INHERITING FROM cx_static_check.
ENDCLASS.

CLASS lcx_error2 IMPLEMENTATION.
ENDCLASS.

******************************

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.
    METHODS test2 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test1.

    DATA lx_error    TYPE REF TO cx_root.
    DATA lv_act      TYPE string.
    DATA ls_t100_key TYPE scx_t100key.

    ls_t100_key-msgid = '00'.
    ls_t100_key-msgno = '001'.
    ls_t100_key-attr1 = 'MSGV1'.

    TRY.
        RAISE EXCEPTION TYPE lcx_error
          EXPORTING
            textid = ls_t100_key
            msgv1  = 'hello'.
      CATCH cx_root INTO lx_error.
        lv_act = lx_error->get_text( ).
        cl_abap_unit_assert=>assert_equals(
          act = lv_act
          exp = 'hello' ).
    ENDTRY.

  ENDMETHOD.

  METHOD test2.

    DATA lx_error TYPE REF TO cx_root.
    DATA lv_act   TYPE string.

    TRY.
        RAISE EXCEPTION TYPE lcx_error2.
      CATCH cx_root INTO lx_error.
        lv_act = lx_error->get_text( ).
        ASSERT lv_act IS NOT INITIAL.
        cl_abap_unit_assert=>assert_equals(
          act = lv_act
          exp = 'An exception was raised.' ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.