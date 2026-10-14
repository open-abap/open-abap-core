CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS textid_and_attributes FOR TESTING RAISING cx_static_check.
    METHODS default_textid FOR TESTING RAISING cx_static_check.
    METHODS previous FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD textid_and_attributes.
    DATA lx_error TYPE REF TO cx_bcs_mail.

    TRY.
        RAISE EXCEPTION TYPE cx_bcs_mail
          EXPORTING
            textid     = cx_bcs_mail=>invalid_recipient
            attribute1 = 'foo@bar'.
      CATCH cx_bcs_mail INTO lx_error.
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->if_t100_message~t100key
          exp = cx_bcs_mail=>invalid_recipient ).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->attribute1
          exp = 'foo@bar' ).
    ENDTRY.
  ENDMETHOD.

  METHOD default_textid.
    DATA lx_error TYPE REF TO cx_bcs_mail.

    CREATE OBJECT lx_error.

    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key
      exp = if_t100_message=>default_textid ).
  ENDMETHOD.

  METHOD previous.
    DATA lx_previous TYPE REF TO cx_bcs_mail.
    DATA lx_error    TYPE REF TO cx_bcs_mail.

    CREATE OBJECT lx_previous
      EXPORTING
        textid = cx_bcs_mail=>send_error.
    CREATE OBJECT lx_error
      EXPORTING
        previous = lx_previous.

    cl_abap_unit_assert=>assert_equals(
      act = lx_error->previous
      exp = lx_previous ).
  ENDMETHOD.

ENDCLASS.
