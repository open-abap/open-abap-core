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
    METHODS escape_url1 FOR TESTING RAISING cx_static_check.
    METHODS escape_html1 FOR TESTING RAISING cx_static_check.
    METHODS escape_url2 FOR TESTING RAISING cx_static_check.
    METHODS encode_base64 FOR TESTING RAISING cx_static_check.
    METHODS fields_identity01 FOR TESTING RAISING cx_static_check.
    METHODS fields_identity02 FOR TESTING RAISING cx_static_check.
    METHODS fields_escaping1 FOR TESTING RAISING cx_static_check.
    METHODS fields_escaping2 FOR TESTING RAISING cx_static_check.
    METHODS decode_base64 FOR TESTING RAISING cx_static_check.
    METHODS fields_encode_base64url FOR TESTING RAISING cx_static_check.
    METHODS fields_decode_base64url FOR TESTING RAISING cx_static_check.

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

    decoded = cl_http_utility=>unescape_url( '%27%24' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = |'$| ).

  ENDMETHOD.

  METHOD unescape_url_eqs1.
    DATA lv_name TYPE string.
    lv_name = '%3D%3D'.
    lv_name = cl_http_utility=>unescape_url( lv_name ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp = '==' ).
  ENDMETHOD.

  METHOD unescape_url_eqs2.
    DATA lv_name TYPE string.
    lv_name = 'ello%3D%3D'.
    lv_name = cl_http_utility=>unescape_url( lv_name ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp = 'ello==' ).
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

  METHOD escape_url1.

    DATA value TYPE string.

    value = cl_http_utility=>escape_url( |/foO/$| ).

    cl_abap_unit_assert=>assert_equals(
      act = value
      exp = '%2ffoO%2f%24' ).

  ENDMETHOD.

  METHOD escape_url2.

    DATA value TYPE string.

    value = cl_http_utility=>escape_url( |aa'*+=?&:/;=?@~[],()| ).

    cl_abap_unit_assert=>assert_equals(
      act = value
      exp = 'aa%27%2a%2b%3d%3f%26%3a%2f%3b%3d%3f%40%7e%5b%5d%2c()' ).

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

  METHOD fields_escaping1.

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

  METHOD fields_escaping2.

    DATA lv_output TYPE string.
    DATA lt_fields TYPE tihttpnvp.
    DATA ls_field  LIKE LINE OF lt_fields.

    ls_field-name = 'sdf'.
    ls_field-value = |aa'*+=?&:/;=?@~[]|.
    APPEND ls_field TO lt_fields.

    lv_output = cl_http_utility=>fields_to_string( lt_fields ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = 'sdf=aa%27%2a%2b%3d%3f%26%3a%2f%3b%3d%3f%40%7e%5b%5d' ).

  ENDMETHOD.

  METHOD decode_base64.

    DATA decoded TYPE string.

    decoded = cl_http_utility=>decode_base64( 'b3BlbiBzZXNhbWU=' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = 'open sesame' ).

  ENDMETHOD.

  METHOD escape_html1.

    DATA value TYPE string.

    value = cl_http_utility=>escape_html( `<a href="x">Q&A</a>` ).

    cl_abap_unit_assert=>assert_equals(
      act = value
      exp = `&lt;a href=&quot;x&quot;&gt;Q&amp;A&lt;/a&gt;` ).

  ENDMETHOD.

  METHOD fields_encode_base64url.

    DATA lt_fields TYPE tihttpnvp.

    APPEND VALUE #(
      name  = 'access_token'
      value = 'abc_def.ghi-jkl' ) TO lt_fields.

    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>fields_to_string( lt_fields )
      exp = 'access_token=abc_def.ghi-jkl' ).

  ENDMETHOD.


  METHOD fields_decode_base64url.

    DATA(lt_fields) =
      cl_http_utility=>string_to_fields( 'access_token=abc%5fdef.ghi-jkl' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_fields[ 1 ]-value
      exp = 'abc_def.ghi-jkl' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_escaping DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    CONSTANTS c_ascii TYPE string
      VALUE ` !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_``abcdefghijklmnopqrstuvwxyz{|}~`.

    METHODS escape_url_ascii FOR TESTING RAISING cx_static_check.
    METHODS escape_url_utf8 FOR TESTING RAISING cx_static_check.
    METHODS unescape_url_plus FOR TESTING RAISING cx_static_check.
    METHODS unescape_url_utf8 FOR TESTING RAISING cx_static_check.
    METHODS unescape_url_invalid FOR TESTING RAISING cx_static_check.
    METHODS escape_html_ascii FOR TESTING RAISING cx_static_check.
    METHODS escape_html_keep_references FOR TESTING RAISING cx_static_check.
    METHODS encode_base64_latin1 FOR TESTING RAISING cx_static_check.
    METHODS decode_base64_latin1 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_escaping IMPLEMENTATION.

  METHOD escape_url_ascii.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_url( c_ascii )
      exp = `%20%21%22%23%24%25%26%27()%2a%2b%2c-.%2f0123456789%3a%3b%3c%3d%3e%3f%40ABCDEFGHIJKLMNOPQRSTUVWXYZ`
         && `%5b%5c%5d%5e_%60abcdefghijklmnopqrstuvwxyz%7b%7c%7d%7e` ).
  ENDMETHOD.

  METHOD escape_url_utf8.
    DATA lv_input TYPE string.
    lv_input = |a{ cl_abap_char_utilities=>horizontal_tab }b{ cl_abap_char_utilities=>newline }|
      && |{ cl_abap_conv_in_ce=>uccp( '00E4' ) }{ cl_abap_conv_in_ce=>uccp( '20AC' ) }|.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_url( lv_input )
      exp = `a%09b%0a%c3%a4%e2%82%ac` ).
  ENDMETHOD.

  METHOD unescape_url_plus.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>unescape_url( `%41+%42%20` )
      exp = `A B ` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>unescape_url( `a+b%2Bc` )
      exp = `a b+c` ).
  ENDMETHOD.

  METHOD unescape_url_utf8.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>unescape_url( `%c3%A4%E2%82%AC` )
      exp = |{ cl_abap_conv_in_ce=>uccp( '00E4' ) }{ cl_abap_conv_in_ce=>uccp( '20AC' ) }| ).
* characters outside ASCII are not expected in an escaped URL
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>unescape_url( |a{ cl_abap_conv_in_ce=>uccp( '00E9' ) }b| )
      exp = `a#b` ).
  ENDMETHOD.

  METHOD unescape_url_invalid.
    TYPES: BEGIN OF ty_case,
             input TYPE string,
             utf8  TYPE xstring,
           END OF ty_case.
    DATA lt_cases TYPE STANDARD TABLE OF ty_case WITH EMPTY KEY.
    DATA ls_case LIKE LINE OF lt_cases.
    DATA lv_result TYPE string.

* an invalid escape or a UTF-8 sequence cut off by the end gives an empty result,
* other invalid UTF-8 gives U+FFFD
    lt_cases = VALUE #(
      ( input = `ok`             utf8 = '6F6B' )
      ( input = `%zz%` )
      ( input = `%gg` )
      ( input = `%00a` )
      ( input = `a%2` )
      ( input = `%` )
      ( input = `%g1` )
      ( input = `%1g` )
      ( input = `%e4` )
      ( input = `%E2%82` )
      ( input = `%C3%A4%E4x` )
      ( input = `%80`            utf8 = 'EFBFBD' )
      ( input = `%FF`            utf8 = 'EFBFBD' )
      ( input = `%E2%82x`        utf8 = 'EFBFBDEFBFBD78' )
      ( input = `%C3%C3%A4`      utf8 = 'EFBFBDC3A4' )
      ( input = `%C0%80`         utf8 = 'EFBFBD' )
      ( input = `%E0%80%80`      utf8 = 'EFBFBD' )
      ( input = `%F4%90%80%80`   utf8 = 'EFBFBD' )
      ( input = `%F0%9F%98%80`   utf8 = 'F09F9880' ) ).

    LOOP AT lt_cases INTO ls_case.
      lv_result = cl_http_utility=>unescape_url( ls_case-input ).
      cl_abap_unit_assert=>assert_equals(
        act = cl_abap_codepage=>convert_to( lv_result )
        exp = ls_case-utf8
        msg = ls_case-input ).
    ENDLOOP.
  ENDMETHOD.

  METHOD escape_html_ascii.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_html( c_ascii )
      exp = ` !&quot;#$%&amp;&#39;()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_``abcdefghijklmnopqrstuvwxyz{|}~` ).
  ENDMETHOD.

  METHOD escape_html_keep_references.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_html( unescaped         = `a&#65;&#66;b&amp;`
                                          keep_num_char_ref = abap_true )
      exp = `a&#65;&#66;b&amp;amp;` ).
* up to five decimal or four hex digits, x in either case, the semicolon required
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_html( unescaped         = `&#00065;&#000065;&#99999;&#xFFFF;&#x10000;&#X41;&#x;&#65`
                                          keep_num_char_ref = abap_true )
      exp = `&#00065;&amp;#000065;&#99999;&#xFFFF;&amp;#x10000;&#X41;&amp;#x;&amp;#65` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_html( unescaped         = `&&#65;;`
                                          keep_num_char_ref = abap_true )
      exp = `&amp;&#65;;` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_html( `&#65;` )
      exp = `&amp;#65;` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_html( unescaped         = `&#65;`
                                          keep_num_char_ref = abap_false )
      exp = `&amp;#65;` ).
  ENDMETHOD.


  METHOD encode_base64_latin1.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>encode_base64( |{ cl_abap_conv_in_ce=>uccp( '00E4' ) }b| )
      exp = `5GI=` ).
* characters outside ISO-8859-1 become "#"
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>encode_base64( |{ cl_abap_conv_in_ce=>uccp( '20AC' ) }| )
      exp = `Iw==` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>encode_base64( |{ cl_abap_conv_in_ce=>uccp( '0100' ) }a| )
      exp = `I2E=` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>encode_base64( `` )
      exp = `` ).
  ENDMETHOD.

  METHOD decode_base64_latin1.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_codepage=>convert_to( cl_http_utility=>decode_base64( `w6Ri` ) )
      exp = 'C383C2A462' ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_codepage=>convert_to( cl_http_utility=>decode_base64( `gA==` ) )
      exp = 'C280' ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_codepage=>convert_to( cl_http_utility=>decode_base64( `/w==` ) )
      exp = 'C3BF' ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>decode_base64( `QQ` )
      exp = `A` ).
  ENDMETHOD.

ENDCLASS.