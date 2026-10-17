CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS create_instance FOR TESTING RAISING cx_static_check.
    METHODS create_text_plain FOR TESTING RAISING cx_static_check.
    METHODS create_text_html FOR TESTING RAISING cx_static_check.
    METHODS setters FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD create_instance.
    DATA lo_part TYPE REF TO cl_bcs_mail_textpart.

    lo_part = cl_bcs_mail_textpart=>create_instance(
      iv_content      = `a;b`
      iv_content_type = 'text/csv'
      iv_filename     = `data.csv` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content( )
      exp = `a;b` ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content_type( )
      exp = 'text/csv' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_filename( )
      exp = `data.csv` ).
  ENDMETHOD.

  METHOD create_text_plain.
    DATA lo_part TYPE REF TO cl_bcs_mail_textpart.

    lo_part = cl_bcs_mail_textpart=>create_text_plain( `hello` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content( )
      exp = `hello` ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content_type( )
      exp = 'text/plain' ).
    cl_abap_unit_assert=>assert_initial( lo_part->get_filename( ) ).
  ENDMETHOD.

  METHOD create_text_html.
    DATA lo_part TYPE REF TO cl_bcs_mail_textpart.

    lo_part = cl_bcs_mail_textpart=>create_text_html(
      iv_content  = `<p>hello</p>`
      iv_filename = `hello.html` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content( )
      exp = `<p>hello</p>` ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content_type( )
      exp = 'text/html' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_filename( )
      exp = `hello.html` ).
  ENDMETHOD.

  METHOD setters.
    DATA lo_part TYPE REF TO cl_bcs_mail_textpart.

    lo_part = cl_bcs_mail_textpart=>create_instance( ).
    lo_part->set_content( `changed` ).
    lo_part->set_content_type( 'text/xml' ).
    lo_part->set_filename( `changed.xml` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content( )
      exp = `changed` ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_content_type( )
      exp = 'text/xml' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_part->get_filename( )
      exp = `changed.xml` ).
  ENDMETHOD.

ENDCLASS.
