CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS decode_x_base64 FOR TESTING RAISING cx_static_check.
    METHODS decode_x_base64_2 FOR TESTING RAISING cx_static_check.
    METHODS encode_x_base64 FOR TESTING RAISING cx_static_check.
    METHODS unescape_url FOR TESTING RAISING cx_static_check.
    METHODS unescape_url_eqs1 FOR TESTING RAISING cx_static_check.
    METHODS unescape_url_eqs2 FOR TESTING RAISING cx_static_check.
    METHODS unescape_url_colon FOR TESTING RAISING cx_static_check.
    METHODS unescape_url_colon2 FOR TESTING RAISING cx_static_check.
    METHODS escape_url FOR TESTING RAISING cx_static_check.
    METHODS encode_base64 FOR TESTING RAISING cx_static_check.
    METHODS fields_identity01 FOR TESTING RAISING cx_static_check.
    METHODS fields_identity02 FOR TESTING RAISING cx_static_check.
    METHODS fields_escaping FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD fields_identity01.

    DATA lv_input TYPE string.
    DATA lv_output TYPE string.

    lv_input = 'moo=42'.

    lv_output = cl_http_utility=>fields_to_string( cl_http_utility=>string_to_fields( lv_input ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = lv_input ).

  ENDMETHOD.

  METHOD fields_identity02.

    DATA lv_input TYPE string.
    DATA lv_output TYPE string.

    lv_input = 'moo=42&bar=a'.

    lv_output = cl_http_utility=>fields_to_string( cl_http_utility=>string_to_fields( lv_input ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = lv_input ).

  ENDMETHOD.

  METHOD decode_x_base64.

    DATA decoded TYPE xstring.

    decoded = cl_http_utility=>decode_x_base64( 'YWJhcA==' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = '61626170' ).

  ENDMETHOD.

  METHOD decode_x_base64_2.

    DATA decoded TYPE xstring.

    decoded = cl_http_utility=>decode_x_base64( 'qrvM' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = 'AABBCC' ).

  ENDMETHOD.

  METHOD unescape_url.

    DATA decoded TYPE string.

    decoded = cl_http_utility=>unescape_url( '%27' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = |'| ).

  ENDMETHOD.

  METHOD unescape_url_eqs1.
    DATA lv_name TYPE string.
    lv_name = '%3D%3D'.
    lv_name = cl_http_utility=>unescape_url( lv_name ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp  = '==' ).
  ENDMETHOD.

  METHOD unescape_url_eqs2.
    DATA lv_name TYPE string.
    lv_name = 'ello%3D%3D'.
    lv_name = cl_http_utility=>unescape_url( lv_name ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp  = 'ello==' ).
  ENDMETHOD.

  METHOD unescape_url_colon.
    DATA lv_act TYPE string.
    lv_act = cl_http_utility=>unescape_url( 'foo%3Abar' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_act
      exp = 'foo:bar' ).
  ENDMETHOD.

  METHOD unescape_url_colon2.
    DATA lv_act TYPE string.
    DATA lv_input TYPE string.
    lv_input = 'url=https%3A%2F%2Fgithub.com%2FabapGit%2FabapGit&package=ZSDFSDd&branch_name=&folder_logic=PREFIX&display_name=&labels='.
    lv_act = cl_http_utility=>unescape_url( lv_input ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_act
      exp = 'url=https://github.com/abapGit/abapGit&package=ZSDFSDd&branch_name=&folder_logic=PREFIX&display_name=&labels=' ).
  ENDMETHOD.

  METHOD escape_url.

    DATA value TYPE string.

    value = cl_http_utility=>escape_url( |/foo/| ).

    cl_abap_unit_assert=>assert_equals(
      act = value
      exp = '%2Ffoo%2F' ).

  ENDMETHOD.

  METHOD encode_base64.

    DATA encoded TYPE string.

    encoded = cl_http_utility=>encode_base64( 'opensesame' ).

    cl_abap_unit_assert=>assert_equals(
      act = encoded
      exp = |b3BlbnNlc2FtZQ==| ).

  ENDMETHOD.

  METHOD encode_x_base64.

    DATA encoded TYPE string.

    encoded = cl_http_utility=>encode_x_base64( '61626170' ).

    cl_abap_unit_assert=>assert_equals(
      act = encoded
      exp = 'YWJhcA==' ).

  ENDMETHOD.

  METHOD fields_escaping.

    DATA lv_output TYPE string.
    DATA lt_fields TYPE tihttpnvp.
    DATA ls_field LIKE LINE OF lt_fields.

    ls_field-name = 'sdf'.
    ls_field-value = 'api://119d38c1-fe84-5520-b1e0-7e277a0c67bb/.default'.
    APPEND ls_field TO lt_fields.

    lv_output = cl_http_utility=>fields_to_string( lt_fields ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = 'sdf=api%3a%2f%2f119d38c1-fe84-5520-b1e0-7e277a0c67bb%2f.default' ).

  ENDMETHOD.

ENDCLASS.