CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS create_instance FOR TESTING RAISING cx_static_check.
    METHODS setters FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD create_instance.
    DATA lo_part    TYPE REF TO cl_bcs_mail_binarypart.
    DATA lv_content TYPE xstring.

    lv_content = '255044462D'.

    lo_part = cl_bcs_mail_binarypart=>create_instance(
      iv_content      = lv_content
      iv_content_type = 'application/pdf'
      iv_filename     = `report.pdf` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content( )
      exp = lv_content ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content_type( )
      exp = 'application/pdf' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_filename( )
      exp = `report.pdf` ).
  ENDMETHOD.

  METHOD setters.
    DATA lo_part    TYPE REF TO cl_bcs_mail_binarypart.
    DATA lv_content TYPE xstring.

    lv_content = 'CAFE'.

    lo_part = cl_bcs_mail_binarypart=>create_instance( ).
    lo_part->set_content( lv_content ).
    lo_part->set_content_type( 'application/octet-stream' ).
    lo_part->set_filename( `blob.bin` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content( )
      exp = lv_content ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content_type( )
      exp = 'application/octet-stream' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_filename( )
      exp = `blob.bin` ).
  ENDMETHOD.

ENDCLASS.
