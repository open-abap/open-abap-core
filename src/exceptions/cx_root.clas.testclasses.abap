CLASS lcx_error DEFINITION INHERITING FROM cx_root.
  PUBLIC SECTION.
    INTERFACES if_t100_message.

    DATA msgv1 TYPE symsgv READ-ONLY.
    DATA msgv2 TYPE symsgv READ-ONLY.
    DATA msgv3 TYPE symsgv READ-ONLY.
    DATA msgv4 TYPE symsgv READ-ONLY.

    METHODS constructor
      IMPORTING
        textid LIKE if_t100_message=>t100key OPTIONAL
        msgv1  TYPE symsgv OPTIONAL.
ENDCLASS.

CLASS lcx_error IMPLEMENTATION.
  METHOD constructor.
    me->msgv1 = msgv1.

    if_t100_message~t100key = textid.
  ENDMETHOD.
ENDCLASS.

******************************

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.
    METHODS source_position_runtime_raise FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test1.

    DATA lx_error        TYPE REF TO cx_root.
    DATA lv_act          TYPE string.
    DATA ls_t100_key     TYPE scx_t100key.
    DATA lv_program_name TYPE syrepid.
    DATA lv_line         TYPE i.

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

        lx_error->get_source_position(
          IMPORTING
            program_name = lv_program_name
            source_line  = lv_line ).
        cl_abap_unit_assert=>assert_not_initial( lv_program_name ).
        cl_abap_unit_assert=>assert_not_initial( lv_line ).
    ENDTRY.

  ENDMETHOD.

  METHOD source_position_runtime_raise.
    " an exception the runtime raises itself never goes through RAISE, so it
    " carries no EXTRA_CX. Reading through it used to throw a TypeError before
    " the fallbacks in get_source_position could be reached, which turns a
    " handler that asks where something happened into a crash of its own.
    DATA lv_float       TYPE f.
    DATA lv_program_name TYPE syrepid.
    DATA lv_line        TYPE i.

    TRY.
        lv_float = CONV f( 'not a number' ).
        cl_abap_unit_assert=>fail( 'expected CX_SY_CONVERSION_NO_NUMBER' ).
      CATCH cx_root INTO DATA(lx_error).
        lx_error->get_source_position(
          IMPORTING
            program_name = lv_program_name
            source_line  = lv_line ).
        cl_abap_unit_assert=>assert_not_initial( lv_program_name ).
        cl_abap_unit_assert=>assert_not_initial( lv_line ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
