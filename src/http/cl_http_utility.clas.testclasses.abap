CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS decode_x_base64 FOR TESTING RAISING cx_static_check.
    METHODS decode_x_base64_2 FOR TESTING RAISING cx_static_check.
    METHODS decode_x_base64_intf FOR TESTING RAISING cx_static_check.
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

  METHOD decode_x_base64_intf.

    DATA decoded TYPE xstring.

    decoded = cl_http_utility=>if_http_utility~decode_x_base64( 'qrvM' ).

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
    METHODS unescape_url_error_codes FOR TESTING RAISING cx_static_check.
    METHODS last_error_reset FOR TESTING RAISING cx_static_check.
    METHODS string_to_fields_error FOR TESTING RAISING cx_static_check.
    METHODS escape_javascript_ascii FOR TESTING RAISING cx_static_check.
    METHODS escape_javascript_html FOR TESTING RAISING cx_static_check.
    METHODS escape_javascript_control FOR TESTING RAISING cx_static_check.
    METHODS escape_javascript_script FOR TESTING RAISING cx_static_check.
    METHODS escape_xml_attr_value FOR TESTING RAISING cx_static_check.
    METHODS normalize_url FOR TESTING RAISING cx_static_check.

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

  METHOD unescape_url_error_codes.
* an escaped NUL, also two non-hex digits, gives 3 and wins over an invalid or
* cut-off escape, 29, which wins over a UTF-8 sequence cut off by the end, 512
    TYPES: BEGIN OF ty_case,
             input TYPE string,
             rc    TYPE i,
           END OF ty_case.
    DATA lt_cases TYPE STANDARD TABLE OF ty_case WITH EMPTY KEY.
    DATA ls_case LIKE LINE OF lt_cases.
    DATA lv_result TYPE string.

    lt_cases = VALUE #(
      ( input = `ok`         rc = 0 )
      ( input = `%80`        rc = 0 )
      ( input = `%zz%`       rc = 3 )
      ( input = `%gg`        rc = 3 )
      ( input = `%00a`       rc = 3 )
      ( input = `%g1%zz`     rc = 3 )
      ( input = `%zz%g1`     rc = 3 )
      ( input = `a%2`        rc = 29 )
      ( input = `%`          rc = 29 )
      ( input = `%g1`        rc = 29 )
      ( input = `%1g`        rc = 29 )
      ( input = `%e4%g1`     rc = 29 )
      ( input = `%e4`        rc = 512 )
      ( input = `%E2%82`     rc = 512 )
      ( input = `%C3%A4%E4x` rc = 512 ) ).

    LOOP AT lt_cases INTO ls_case.
      lv_result = cl_http_utility=>unescape_url( ls_case-input ).
      cl_abap_unit_assert=>assert_equals(
        act = cl_http_utility=>get_last_error( )
        exp = ls_case-rc
        msg = ls_case-input ).
    ENDLOOP.
  ENDMETHOD.

  METHOD last_error_reset.
    DATA lv_result TYPE string.

    lv_result = cl_http_utility=>unescape_url( `%zz` ).
    lv_result = cl_http_utility=>escape_xml_attr_value( `a` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 3 ).

    lv_result = cl_http_utility=>escape_url( `a` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 0 ).

    lv_result = cl_http_utility=>unescape_url( `%zz` ).
    lv_result = cl_http_utility=>encode_base64( `a` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 0 ).

    lv_result = cl_http_utility=>unescape_url( `%zz` ).
    lv_result = cl_http_utility=>normalize_url( `/a` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 0 ).
  ENDMETHOD.

  METHOD string_to_fields_error.
    DATA lt_fields TYPE tihttpnvp.
    DATA ls_field LIKE LINE OF lt_fields.

* the field that fails is kept with an empty value, the fields after it are dropped
    lt_fields = cl_http_utility=>string_to_fields( `a=1&b=%zz&c=3` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 28 ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_fields )
      exp = 2 ).
    READ TABLE lt_fields INDEX 2 INTO ls_field.
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-name
      exp = `b` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-value
      exp = `` ).

* a name that fails gives an empty name and value
    lt_fields = cl_http_utility=>string_to_fields( `a%zz=1&b=2` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 28 ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_fields )
      exp = 1 ).
    CLEAR ls_field.
    READ TABLE lt_fields INDEX 1 INTO ls_field.
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-name
      exp = `` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-value
      exp = `` ).

    lt_fields = cl_http_utility=>string_to_fields( `a=1` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 0 ).
  ENDMETHOD.

  METHOD escape_javascript_ascii.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_javascript( c_ascii )
      exp = ` !\"#$%&\'()*+,-./0123456789:;\x3c=\x3e?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_``abcdefghijklmnopqrstuvwxyz{|}~` ).
  ENDMETHOD.

  METHOD escape_javascript_html.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_javascript( unescaped   = c_ascii
                                                inside_html = abap_true )
      exp = ` !&quot;#$%&amp;\'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_``abcdefghijklmnopqrstuvwxyz{|}~` ).
  ENDMETHOD.

  METHOD escape_javascript_control.
    DATA lv_input TYPE string.
    DATA lv_expected TYPE string.

    lv_input = |a{ cl_abap_char_utilities=>horizontal_tab }b{ cl_abap_char_utilities=>newline }c|
      && |{ cl_abap_char_utilities=>cr_lf(1) }d{ cl_abap_conv_in_ce=>uccp( '2028' ) }|
      && |{ cl_abap_conv_in_ce=>uccp( '2029' ) }{ cl_abap_conv_in_ce=>uccp( '00E4' ) }|.
* tabs and characters outside ASCII stay as they are
    lv_expected = `a` && cl_abap_char_utilities=>horizontal_tab && `b\nc\rd\x2028\x2029`
      && cl_abap_conv_in_ce=>uccp( '00E4' ).

    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_javascript( lv_input )
      exp = lv_expected ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_javascript( unescaped   = lv_input
                                                inside_html = abap_true )
      exp = lv_expected ).
  ENDMETHOD.

  METHOD escape_javascript_script.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_javascript( `</script><!-- ]]>` )
      exp = `\x3c/script\x3e\x3c!-- ]]\x3e` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_javascript( unescaped   = `</script><!-- ]]>`
                                                inside_html = abap_true )
      exp = `&lt;/script&gt;&lt;!-- ]]&gt;` ).
  ENDMETHOD.

  METHOD escape_xml_attr_value.
    DATA lv_input TYPE string.

    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_xml_attr_value( c_ascii )
      exp = ` !&quot;#$%&amp;&apos;()*+,-./0123456789:;&lt;=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_``abcdefghijklmnopqrstuvwxyz{|}~` ).

    lv_input = |a{ cl_abap_char_utilities=>horizontal_tab }b{ cl_abap_char_utilities=>newline }c|.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_xml_attr_value( lv_input )
      exp = lv_input ).

    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_xml_attr_value( `&amp;&#65;` )
      exp = `&amp;amp;&amp;#65;` ).
  ENDMETHOD.

  METHOD normalize_url.
    TYPES: BEGIN OF ty_case,
             input    TYPE string,
             expected TYPE string,
           END OF ty_case.
    DATA lt_cases TYPE STANDARD TABLE OF ty_case WITH EMPTY KEY.
    DATA ls_case LIKE LINE OF lt_cases.

    lt_cases = VALUE #(
      ( input = `HTTP://Example.COM:80/a/./b/../c?X=1#F` expected = `HTTP://Example.COM:80/a/c?X=1#F` )
      ( input = `/a//b/./c/../d`        expected = `/a//b/d` )
      ( input = `/%7e%41%2f%2F%20`      expected = `/%7e%41%2f%2F%20` )
      ( input = `/a b/c`                expected = `/a b/c` )
      ( input = `a/../../b`             expected = `b` )
      ( input = `https://h:443/`        expected = `https://h:443/` )
      ( input = ``                      expected = `` )
      ( input = `/A/B/`                 expected = `/A/B/` )
      ( input = `/a/..`                 expected = `/` )
      ( input = `/a/.`                  expected = `/a/` )
      ( input = `/../a`                 expected = `/a` )
      ( input = `/..`                   expected = `/` )
      ( input = `//a`                   expected = `//a` )
      ( input = `//..`                  expected = `//..` )
      ( input = `//h/a/../b`            expected = `//h/b` )
      ( input = `a/./b`                 expected = `a/b` )
      ( input = `./a`                   expected = `a` )
      ( input = `../a`                  expected = `a` )
      ( input = `a/..`                  expected = `` )
      ( input = `a/.`                   expected = `a/` )
      ( input = `a/b/..`                expected = `a/` )
      ( input = `./`                    expected = `` )
      ( input = `a/../`                 expected = `` )
      ( input = `.`                     expected = `` )
      ( input = `..`                    expected = `` )
      ( input = `/`                     expected = `/` )
      ( input = `/.`                    expected = `/` )
      ( input = `/a/b/c/./../../g`      expected = `/a/g` )
      ( input = `/a/b/.././../c/./d`    expected = `/c/d` )
      ( input = `/a/b/..c/.d/...`       expected = `/a/b/..c/.d/...` )
      ( input = `/a/%2e%2e/b`           expected = `/a/%2e%2e/b` )
      ( input = `a//../b`               expected = `b` )
      ( input = `a/b//../c`             expected = `a/c` )
      ( input = `/a//..`                expected = `/` )
      ( input = `/a?x=/../b`            expected = `/b` )
      ( input = `/a/./b#/../c`          expected = `/a/c` )
      ( input = `?x=../y`               expected = `?x=../y` )
      ( input = `http://h/../a`         expected = `http://h/a` )
      ( input = `http://h//../a`        expected = `http://h/a` )
      ( input = `http://h/a/..`         expected = `http://h/` )
      ( input = `http://h`              expected = `http://h` )
      ( input = `http://h/.`            expected = `http://h/` )
      ( input = `http://h:80/a/./../b/` expected = `http://h:80/b/` )
      ( input = `http://h?x/../y`       expected = `http://hy` )
      ( input = `/x?u=http://h/../a`    expected = `/x?u=http://a` )
      ( input = `a?b://h/../c`          expected = `a?b://c` )
      ( input = `://b/../c`             expected = `://b/c` )
      ( input = `x:/a/../b`             expected = `x:/b` )
      ( input = `http:a/../b`           expected = `b` ) ).

    LOOP AT lt_cases INTO ls_case.
      cl_abap_unit_assert=>assert_equals(
        act = cl_http_utility=>normalize_url( ls_case-input )
        exp = ls_case-expected
        msg = ls_case-input ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_more_escaping DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS escape_url_non_bmp FOR TESTING RAISING cx_static_check.
    METHODS unescape_url_non_bmp FOR TESTING RAISING cx_static_check.
    METHODS get_last_error FOR TESTING RAISING cx_static_check.
    METHODS string_to_fields_stops FOR TESTING RAISING cx_static_check.
    METHODS string_to_fields_names FOR TESTING RAISING cx_static_check.
    METHODS fields_to_string_names FOR TESTING RAISING cx_static_check.

    METHODS emoji
      RETURNING VALUE(rv) TYPE string.

ENDCLASS.

CLASS ltcl_more_escaping IMPLEMENTATION.

  METHOD emoji.
* U+1F600, a surrogate pair
    DATA lv_utf8 TYPE xstring.
    lv_utf8 = 'F09F9880'.
    rv = cl_abap_codepage=>convert_from( lv_utf8 ).
  ENDMETHOD.

  METHOD escape_url_non_bmp.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_url( emoji( ) )
      exp = `%f0%9f%98%80` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>escape_url( |a{ emoji( ) }b| )
      exp = `a%f0%9f%98%80b` ).
  ENDMETHOD.

  METHOD unescape_url_non_bmp.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>unescape_url( `%f0%9f%98%80` )
      exp = emoji( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>unescape_url( cl_http_utility=>escape_url( emoji( ) ) )
      exp = emoji( ) ).
  ENDMETHOD.

  METHOD get_last_error.
    DATA lv_result TYPE string.

    lv_result = cl_http_utility=>unescape_url( `50%+off` ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = `` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 3 ).

* a successful call resets the error
    lv_result = cl_http_utility=>unescape_url( `abc` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 0 ).
  ENDMETHOD.

  METHOD string_to_fields_stops.
* processing stops at the invalid escape, the following fields are dropped
    DATA lt_fields TYPE tihttpnvp.
    DATA ls_field  LIKE LINE OF lt_fields.

    lt_fields = cl_http_utility=>string_to_fields( `discount=100%&a=b` ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_fields )
      exp = 1 ).
    READ TABLE lt_fields INDEX 1 INTO ls_field.
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-name
      exp = `discount` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-value
      exp = `` ).
  ENDMETHOD.

  METHOD string_to_fields_names.
    DATA lt_fields TYPE tihttpnvp.
    DATA ls_field  LIKE LINE OF lt_fields.

    lt_fields = cl_http_utility=>string_to_fields( `first+name=a+b` ).
    READ TABLE lt_fields INDEX 1 INTO ls_field.
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-name
      exp = `first name` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-value
      exp = `a b` ).

    lt_fields = cl_http_utility=>string_to_fields( `a%5Bb%5D=1` ).
    CLEAR ls_field.
    READ TABLE lt_fields INDEX 1 INTO ls_field.
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-name
      exp = `a[b]` ).

    lt_fields = cl_http_utility=>string_to_fields( `x%20y=1&z+w=2` ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_fields )
      exp = 2 ).
    CLEAR ls_field.
    READ TABLE lt_fields INDEX 2 INTO ls_field.
    cl_abap_unit_assert=>assert_equals(
      act = ls_field-name
      exp = `z w` ).
  ENDMETHOD.

  METHOD fields_to_string_names.
    DATA lt_fields TYPE tihttpnvp.

    lt_fields = VALUE #( ( name = `a b&c` value = `d e&f` ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>fields_to_string( lt_fields )
      exp = `a%20b%26c=d%20e%26f` ).

    lt_fields = VALUE #(
      ( name = `a b` value = `1` )
      ( name = `c&d` value = `2` ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>fields_to_string( lt_fields )
      exp = `a%20b=1&c%26d=2` ).
  ENDMETHOD.

ENDCLASS.