* JSON specification, https://www.ecma-international.org/publications-and-standards/standards/ecma-404/

CLASS lcl_json_parser DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_node,
             type    TYPE if_sxml_node=>node_type,
             name    TYPE string,
             key     TYPE string,
             has_key TYPE abap_bool,
             value   TYPE string,
           END OF ty_node.

    TYPES ty_nodes TYPE STANDARD TABLE OF ty_node WITH DEFAULT KEY.

    METHODS parse
      IMPORTING
        iv_json  TYPE string
        it_nodes TYPE REF TO ty_nodes.

  PRIVATE SECTION.
    DATA mt_nodes TYPE REF TO ty_nodes.

    METHODS append
      IMPORTING
        iv_type    TYPE if_sxml_node=>node_type
        iv_name    TYPE string OPTIONAL
        iv_key     TYPE string OPTIONAL
        iv_has_key TYPE abap_bool DEFAULT abap_false
        iv_value   TYPE string OPTIONAL.

    METHODS traverse
      IMPORTING
        iv_json    TYPE any
        iv_key     TYPE string OPTIONAL
        iv_has_key TYPE abap_bool DEFAULT abap_false.
    METHODS traverse_object
      IMPORTING
        iv_json    TYPE any
        iv_key     TYPE string OPTIONAL
        iv_has_key TYPE abap_bool DEFAULT abap_false.
    METHODS traverse_array
      IMPORTING
        iv_json    TYPE any
        iv_key     TYPE string OPTIONAL
        iv_has_key TYPE abap_bool DEFAULT abap_false.

ENDCLASS.

CLASS lcl_json_parser IMPLEMENTATION.

  METHOD parse.

    DATA lv_error         TYPE abap_bool.
    DATA lv_error_message TYPE string.
    DATA lv_xml_offset    TYPE i.
    DATA lv_json          TYPE i.

* Note: iv_json is an object to avoid problems with the ANY importing parameter

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   lv_json = {value: JSON.parse(iv_json.get())};'.
    WRITE '@KERNEL } catch(e) {'.
    WRITE '@KERNEL   lv_error_message.set(e.message);'.
    WRITE '@KERNEL   lv_error.set("X")'.
    WRITE '@KERNEL }'.
    IF lv_error = abap_true.
* NodeJS 16 will set the postion, but NodeJS 20 does not
      FIND REGEX ' position (\d+)' IN lv_error_message SUBMATCHES lv_xml_offset.
      RAISE EXCEPTION TYPE cx_sxml_parse_error
        EXPORTING
          xml_offset = lv_xml_offset.
    ENDIF.

    mt_nodes = it_nodes.
    CLEAR mt_nodes->*.
    traverse( lv_json ).
  ENDMETHOD.

  METHOD append.
    DATA ls_node LIKE LINE OF mt_nodes->*.
    ls_node-type = iv_type.
    ls_node-name = iv_name.
    ls_node-key = iv_key.
    ls_node-has_key = iv_has_key.
    ls_node-value = iv_value.
    APPEND ls_node TO mt_nodes->*.
  ENDMETHOD.

  METHOD traverse.

    DATA lv_type TYPE string.

    WRITE '@KERNEL lv_type.set(Array.isArray(iv_json.value) ? "array" : typeof iv_json.value);'.
    WRITE '@KERNEL if (iv_json.value === null) lv_type.set("null");'.

    CASE lv_type.
      WHEN 'object'.
        traverse_object( iv_json    = iv_json
                         iv_key     = iv_key
                         iv_has_key = iv_has_key ).
      WHEN 'array'.
        traverse_array( iv_json    = iv_json
                        iv_key     = iv_key
                        iv_has_key = iv_has_key ).
      WHEN 'string' OR 'boolean' OR 'number' OR 'null'.
        WRITE '@KERNEL iv_json = iv_json.value + "";'.

        CASE lv_type.
          WHEN 'string'.
            lv_type = 'str'.
          WHEN 'number'.
            lv_type = 'num'.
          WHEN 'boolean'.
            lv_type = 'bool'.
        ENDCASE.

        append( iv_type    = if_sxml_node=>co_nt_element_open
                iv_name    = lv_type
                iv_key     = iv_key
                iv_has_key = iv_has_key ).
        IF lv_type <> 'null'.
          append( iv_type  = if_sxml_node=>co_nt_value
                  iv_value = iv_json ).
        ENDIF.
        append( iv_type = if_sxml_node=>co_nt_element_close
                iv_name = lv_type ).
      WHEN OTHERS.
        ASSERT 2 = 'todo'.
    ENDCASE.

  ENDMETHOD.


  METHOD traverse_array.

    DATA lv_value  TYPE string.
    DATA lv_length TYPE i.
    DATA lv_index  TYPE i.

    WRITE '@KERNEL let parsed = iv_json.value;'.
    WRITE '@KERNEL lv_length.set(parsed.length);'.

    append( iv_type    = if_sxml_node=>co_nt_element_open
            iv_name    = 'array'
            iv_key     = iv_key
            iv_has_key = iv_has_key ).

    DO lv_length TIMES.
      lv_index = sy-index - 1.
      WRITE '@KERNEL lv_value = {value: parsed[lv_index.get()]};'.
      traverse( lv_value ).
    ENDDO.

    append( iv_type = if_sxml_node=>co_nt_element_close
            iv_name = 'array' ).

  ENDMETHOD.

  METHOD traverse_object.

    DATA lv_key   TYPE string.
    DATA lv_value TYPE string.

    WRITE '@KERNEL let parsed = iv_json.value;'.

    append( iv_type    = if_sxml_node=>co_nt_element_open
            iv_name    = 'object'
            iv_key     = iv_key
            iv_has_key = iv_has_key ).

    WRITE '@KERNEL for (const k of Object.keys(parsed)) {'.
    WRITE '@KERNEL   lv_key.set(k);'.
    WRITE '@KERNEL   lv_value = {value: parsed[k]};'.
    traverse( iv_json    = lv_value
              iv_key     = lv_key
              iv_has_key = abap_true ).
    WRITE '@KERNEL };'.

    append( iv_type = if_sxml_node=>co_nt_element_close
            iv_name = 'object' ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_attribute DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_attribute.

    METHODS constructor
      IMPORTING
        name       TYPE string
        prefix     TYPE string OPTIONAL
        nsuri      TYPE string OPTIONAL
        value      TYPE string
        value_type TYPE if_sxml_value=>value_type.

  PRIVATE SECTION.
    DATA mv_value TYPE string.
ENDCLASS.

CLASS lcl_attribute IMPLEMENTATION.
  METHOD constructor.
    if_sxml_attribute~qname-name = name.
    if_sxml_attribute~prefix = prefix.
    if_sxml_attribute~qname-namespace = nsuri.
    if_sxml_attribute~value_type = value_type.
    mv_value = value.
  ENDMETHOD.

  METHOD if_sxml_attribute~get_value.
    value = mv_value.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_open_node DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_open_element.
    METHODS constructor
      IMPORTING
        name       TYPE string
        prefix     TYPE string OPTIONAL
        nsuri      TYPE string OPTIONAL
        attributes TYPE if_sxml_attribute=>attributes OPTIONAL.
  PRIVATE SECTION.
    DATA mt_attributes TYPE if_sxml_attribute=>attributes.
ENDCLASS.

CLASS lcl_open_node IMPLEMENTATION.

  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_element_open.
    if_sxml_open_element~qname-name = name.
    if_sxml_open_element~prefix = prefix.
    if_sxml_open_element~qname-namespace = nsuri.
    mt_attributes = attributes.
  ENDMETHOD.

  METHOD if_sxml_open_element~get_attribute_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_open_element~get_attributes.
    attr = mt_attributes.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_prefix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_attribute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_open_element~set_attributes.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_close_node DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_close_element.
    METHODS constructor
      IMPORTING name TYPE string prefix TYPE string OPTIONAL nsuri TYPE string OPTIONAL.
ENDCLASS.

CLASS lcl_close_node IMPLEMENTATION.
  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_element_close.
    if_sxml_close_element~qname-name = name.
    if_sxml_close_element~qname-namespace = nsuri.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_value_node DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_sxml_value_node.
    METHODS constructor
      IMPORTING
        value TYPE string.
  PRIVATE SECTION.
    DATA mv_value TYPE string.
ENDCLASS.

CLASS lcl_value_node IMPLEMENTATION.

  METHOD constructor.
    if_sxml_node~type = if_sxml_node=>co_nt_value.
    mv_value = value.
  ENDMETHOD.

  METHOD if_sxml_value_node~get_value_raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_value_node~set_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_value_node~set_value_raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_value_node~get_value.
    value = mv_value.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_xml_parser DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_item,
             kind   TYPE i,
             name   TYPE string,
             prefix TYPE string,
             nsuri  TYPE string,
             value  TYPE string,
             attrs  TYPE if_sxml_attribute=>attributes,
           END OF ty_item.
    METHODS constructor IMPORTING source TYPE string OPTIONAL
                                  bytes  TYPE xstring OPTIONAL
                                  binary TYPE abap_bool DEFAULT abap_false.
    METHODS next RETURNING VALUE(item) TYPE ty_item RAISING cx_sxml_parse_error.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_element,
             name       TYPE string,
             local_name TYPE string,
             prefix     TYPE string,
             nsuri      TYPE string,
             has_child  TYPE abap_bool,
           END OF ty_element.
    TYPES: BEGIN OF ty_binding,
             depth        TYPE i,
             prefix       TYPE string,
             nsuri        TYPE string,
             previous     TYPE string,
             had_previous TYPE abap_bool,
           END OF ty_binding.
    DATA mv_source TYPE string.
    " a UTF-8 document is kept as its bytes: the markup is ASCII and no byte
    " of a multi-byte character is below 80, so '<', '>' and the quotes are
    " found in the bytes, and only the names and values between them are
    " decoded; positions are then bytes
    DATA mv_bytes TYPE xstring.
    DATA mv_binary TYPE abap_bool.
    DATA mv_length TYPE i.
    DATA mv_pos TYPE i.
    DATA mv_done TYPE abap_bool.
    DATA mv_pending_close TYPE abap_bool.
    DATA mt_elements TYPE STANDARD TABLE OF ty_element WITH DEFAULT KEY.
    DATA mt_bindings TYPE STANDARD TABLE OF ty_binding WITH DEFAULT KEY.
    DATA mt_current TYPE HASHED TABLE OF if_sxml_named=>nsbinding WITH UNIQUE KEY prefix.
    METHODS fail IMPORTING reason TYPE string RAISING cx_sxml_parse_error.
    METHODS starts IMPORTING needle TYPE string RETURNING VALUE(yes) TYPE abap_bool.
    METHODS take_name RETURNING VALUE(name) TYPE string RAISING cx_sxml_parse_error.
    METHODS whitespace.
    METHODS decode IMPORTING raw TYPE string RETURNING VALUE(decoded) TYPE string RAISING cx_sxml_parse_error.
    METHODS lookup IMPORTING prefix TYPE string RETURNING VALUE(nsuri) TYPE string.
    METHODS restore IMPORTING depth TYPE i.
    TYPES ty_char TYPE c LENGTH 1.
    METHODS at IMPORTING pos TYPE i RETURNING VALUE(c) TYPE ty_char.
    METHODS piece IMPORTING begin TYPE i length TYPE i RETURNING VALUE(text) TYPE string
      RAISING cx_sxml_parse_error.
    METHODS replaced IMPORTING part TYPE xstring begin TYPE i RETURNING VALUE(text) TYPE string
      RAISING cx_sxml_parse_error.
    METHODS seek IMPORTING sub TYPE string off TYPE i RETURNING VALUE(found) TYPE i.
ENDCLASS.

CLASS lcl_xml_parser IMPLEMENTATION.
  METHOD constructor.
    IF binary = abap_true.
      mv_binary = abap_true.
      mv_bytes = bytes.
      mv_length = xstrlen( bytes ).
      RETURN.
    ENDIF.
    mv_source = source.
    mv_length = strlen( source ).
  ENDMETHOD.

  METHOD at.
    DATA byte TYPE x LENGTH 1.
    DATA code TYPE i.
    IF mv_binary = abap_false.
      c = mv_source+pos(1).
      RETURN.
    ENDIF.
    byte = mv_bytes+pos(1).
    code = byte.
    IF code < 128.
      c = cl_abap_conv_in_ce=>uccpi( code ).
    ELSE.
      " part of a multi-byte character: never markup
      c = 'x'.
    ENDIF.
  ENDMETHOD.

  METHOD piece.
    DATA part TYPE xstring.
    IF mv_binary = abap_false.
      text = mv_source+begin(length).
      RETURN.
    ENDIF.
    IF length > 0.
      part = mv_bytes+begin(length).
      TRY.
          text = cl_abap_codepage=>convert_from( part ).
        CATCH cx_sy_conversion_codepage.
          text = replaced( part  = part
                           begin = begin ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD replaced.
    " a byte that does not start or continue a UTF-8 character reads as
    " U+FFFD, as a system reads it (<a>FF</a> is a value
    " U+FFFD; a lone 80 one U+FFFD; E2 82 before more text two; the overlong
    " C0 AF one). A sequence cut off by the markup after it is an error at
    " that markup (E2 82 then '<'). A system passes an encoded surrogate
    " (ED A0 80) through as a lone D800; here it is U+FFFD
    DATA pos TYPE i.
    DATA lead TYPE x LENGTH 1.
    DATA code TYPE i.
    DATA size TYPE i.
    DATA good TYPE abap_bool.
    DATA chunk TYPE xstring.
    WHILE pos < xstrlen( part ).
      lead = part+pos(1).
      code = lead.
      IF code < 128.
        size = 1.
      ELSEIF code = 192 OR code = 193.
        " an overlong form of an ASCII character: one U+FFFD for both bytes
        size = -2.
      ELSEIF code >= 194 AND code <= 223.
        size = 2.
      ELSEIF code >= 224 AND code <= 239.
        size = 3.
      ELSEIF code >= 240 AND code <= 244.
        size = 4.
      ELSE.
        size = 0.
      ENDIF.
      IF size = -2 AND pos + 2 <= xstrlen( part ).
        text = text && cl_abap_conv_in_ce=>uccpi( 65533 ).
        pos = pos + 2.
        CONTINUE.
      ENDIF.
      IF size > 1 AND pos + size > xstrlen( part ).
        mv_pos = begin + xstrlen( part ).
        fail( 'invalid UTF-8 sequence' ).
      ENDIF.
      " the conversion of the whole sequence checks its continuation bytes
      good = boolc( size > 0 AND pos + size <= xstrlen( part ) ).
      IF good = abap_true AND size > 1.
        TRY.
            chunk = part+pos(size).
            text = text && cl_abap_codepage=>convert_from( chunk ).
          CATCH cx_sy_conversion_codepage.
            good = abap_false.
        ENDTRY.
      ELSEIF good = abap_true.
        chunk = part+pos(1).
        text = text && cl_abap_codepage=>convert_from( chunk ).
      ENDIF.
      IF good = abap_true.
        pos = pos + size.
      ELSE.
        text = text && cl_abap_conv_in_ce=>uccpi( 65533 ).
        pos = pos + 1.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD seek.
    DATA needle TYPE xstring.
    IF mv_binary = abap_false.
      found = find( val = mv_source
                    sub = sub
                    off = off ).
      RETURN.
    ENDIF.
    needle = cl_abap_codepage=>convert_to( sub ).
    FIND needle IN SECTION OFFSET off OF mv_bytes IN BYTE MODE MATCH OFFSET found.
    IF sy-subrc <> 0.
      found = -1.
    ENDIF.
  ENDMETHOD.

  METHOD fail.
    DATA error TYPE REF TO cx_sxml_parse_error.
    CREATE OBJECT error EXPORTING xml_offset = mv_pos.
    error->error_text = reason.
    error->rawstring = 'Error while parsing an XML stream:' && | | && reason && '.'.
    RAISE EXCEPTION error.
  ENDMETHOD.

  METHOD starts.
    DATA n TYPE i.
    DATA k TYPE i.
    n = strlen( needle ).
    IF mv_pos + n > mv_length.
      RETURN.
    ENDIF.
    IF mv_binary = abap_false.
      IF mv_source+mv_pos(n) = needle.
        yes = abap_true.
      ENDIF.
      RETURN.
    ENDIF.
    WHILE k < n.
      IF at( mv_pos + k ) <> needle+k(1).
        RETURN.
      ENDIF.
      k = k + 1.
    ENDWHILE.
    yes = abap_true.
  ENDMETHOD.

  METHOD whitespace.
    DATA c TYPE c LENGTH 1.
    WHILE mv_pos < mv_length.
      c = at( mv_pos ).
      CASE c.
        WHEN space OR cl_abap_char_utilities=>horizontal_tab
            OR cl_abap_char_utilities=>newline OR cl_abap_char_utilities=>cr_lf(1).
          mv_pos = mv_pos + 1.
        WHEN OTHERS.
          EXIT.
      ENDCASE.
    ENDWHILE.
  ENDMETHOD.

  METHOD take_name.
    DATA begin TYPE i.
    DATA c TYPE c LENGTH 1.
    DATA length TYPE i.
    begin = mv_pos.
    WHILE mv_pos < mv_length.
      c = at( mv_pos ).
      IF c = space OR c = '/' OR c = '>' OR c = '=' OR c = '?' OR c = cl_abap_char_utilities=>newline
          OR c = cl_abap_char_utilities=>horizontal_tab OR c = cl_abap_char_utilities=>cr_lf(1).
        EXIT.
      ENDIF.
      mv_pos = mv_pos + 1.
    ENDWHILE.
    IF begin = mv_pos.
      fail( 'document not wellformed' ).
    ENDIF.
    length = mv_pos - begin.
    name = piece( begin  = begin
                  length = length ).
    c = name(1).
    IF ( c >= '0' AND c <= '9' ) OR c = '.' OR c = '-'.
      fail( 'invalid character after ''<''' ).
    ENDIF.
  ENDMETHOD.

  METHOD lookup.
    DATA current TYPE if_sxml_named=>nsbinding.
    IF prefix = 'xml'.
      nsuri = 'http://www.w3.org/XML/1998/namespace'.
      RETURN.
    ENDIF.
    READ TABLE mt_current WITH TABLE KEY prefix = prefix INTO current.
    IF sy-subrc = 0.
      nsuri = current-nsuri.
    ENDIF.
  ENDMETHOD.

  METHOD restore.
    DATA binding TYPE ty_binding.
    DATA current TYPE if_sxml_named=>nsbinding.
    DATA last TYPE i.
    last = lines( mt_bindings ).
    WHILE last > 0.
      READ TABLE mt_bindings INDEX last INTO binding.
      IF binding-depth <> depth.
        EXIT.
      ENDIF.
      DELETE mt_bindings INDEX last.
      DELETE TABLE mt_current WITH TABLE KEY prefix = binding-prefix.
      IF binding-had_previous = abap_true.
        current-prefix = binding-prefix.
        current-nsuri = binding-previous.
        INSERT current INTO TABLE mt_current.
      ENDIF.
      last = last - 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD decode.
    DATA pos TYPE i.
    DATA begin TYPE i.
    DATA n TYPE i.
    DATA code TYPE i.
    DATA digit TYPE i.
    DATA base TYPE i.
    DATA entity TYPE string.
    DATA part TYPE string.
    DATA parts TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA c TYPE c LENGTH 1.
    DATA length TYPE i.
    DATA chars TYPE string VALUE '0123456789ABCDEF'.
    n = strlen( raw ).
    WHILE pos < n.
      IF raw+pos(1) <> '&'.
        begin = pos.
        WHILE pos < n AND raw+pos(1) <> '&'.
          pos = pos + 1.
        ENDWHILE.
        length = pos - begin.
        part = raw+begin(length).
        APPEND part TO parts.
        CONTINUE.
      ENDIF.
      pos = pos + 1.
      begin = pos.
      WHILE pos < n AND raw+pos(1) <> ';'.
        pos = pos + 1.
      ENDWHILE.
      IF pos = n.
        fail( 'unresolveable entity reference in content' ).
      ENDIF.
      length = pos - begin.
      entity = raw+begin(length).
      pos = pos + 1.
      CASE entity.
        WHEN 'amp'.
          part = '&'.
        WHEN 'lt'.
          part = '<'.
        WHEN 'gt'.
          part = '>'.
        WHEN 'quot'.
          part = '"'.
        WHEN 'apos'.
          part = ''''.
        WHEN OTHERS.
          IF entity(1) <> '#' OR strlen( entity ) < 2.
            fail( 'unresolveable entity reference in content' ).
          ENDIF.
          base = 10.
          begin = 1.
          IF entity+1(1) = 'x' OR entity+1(1) = 'X'.
            base = 16.
            begin = 2.
          ENDIF.
          code = 0.
          WHILE begin < strlen( entity ).
            c = entity+begin(1).
            TRANSLATE c TO UPPER CASE.
            FIND c IN chars MATCH OFFSET digit.
            IF sy-subrc <> 0 OR digit >= base.
              fail( 'unresolveable entity reference in content' ).
            ENDIF.
            IF code > ( 1114111 - digit ) DIV base.
              fail( 'illegal charref value' ).
            ENDIF.
            code = code * base + digit.
            begin = begin + 1.
          ENDWHILE.
          IF code > 1114111 OR ( code >= 55296 AND code <= 57343 ).
            fail( 'illegal charref value' ).
          ENDIF.
          part = cl_abap_conv_in_ce=>uccpi( code ).
      ENDCASE.
      APPEND part TO parts.
    ENDWHILE.
    CONCATENATE LINES OF parts INTO decoded RESPECTING BLANKS.
  ENDMETHOD.

  METHOD next.
    DATA begin TYPE i.
    DATA i TYPE i.
    DATA j TYPE i.
    DATA name TYPE string.
    DATA attr_name TYPE string.
    DATA attr_value TYPE string.
    DATA prefix TYPE string.
    DATA attr_nsuri TYPE string.
    DATA local_name TYPE string.
    DATA quote TYPE c LENGTH 1.
    DATA quote_text TYPE string.
    DATA element TYPE ty_element.
    DATA binding TYPE ty_binding.
    DATA current TYPE if_sxml_named=>nsbinding.
    DATA attribute TYPE REF TO if_sxml_attribute.
    DATA attrs TYPE if_sxml_attribute=>attributes.
    DATA names TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA values TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lv_depth TYPE i.
    DATA close_at TYPE i.
    DATA length TYPE i.
    DATA only_space TYPE abap_bool.
    DATA has_entity TYPE abap_bool.
    DATA c TYPE c LENGTH 1.
    DATA c2 TYPE c LENGTH 1.
    DATA found TYPE i.
    DATA spaces TYPE string.
    FIELD-SYMBOLS <parent> TYPE ty_element.
    IF mv_done = abap_true.
      item-kind = if_sxml_node=>co_nt_final.
      RETURN.
    ENDIF.
    IF mv_pending_close = abap_true.
      mv_pending_close = abap_false.
      READ TABLE mt_elements INDEX lines( mt_elements ) INTO element.
      item-kind = if_sxml_node=>co_nt_element_close.
      item-name = element-local_name.
      item-prefix = element-prefix.
      item-nsuri = element-nsuri.
      lv_depth = lines( mt_elements ).
      DELETE mt_elements INDEX lv_depth.
      restore( lv_depth ).
      IF mt_elements IS INITIAL.
        mv_done = abap_true.
      ENDIF.
      RETURN.
    ENDIF.
    WHILE mv_pos < mv_length.
      " one look at the character after '<' decides the kind of markup, and
      " runs of text, comments and values are crossed with find( ) instead
      " of a character at a time
      CLEAR: c, c2.
      c = at( mv_pos ).
      IF c = '<' AND mv_pos + 1 < mv_length.
        i = mv_pos + 1.
        c2 = at( i ).
      ENDIF.
      IF c = '<' AND c2 = '?'.
        mv_pos = mv_pos + 2.
        found = seek( sub = '?>'
                      off = mv_pos ).
        IF found < 0.
          mv_pos = mv_length.
          fail( '<EOF> reached' ).
        ENDIF.
        mv_pos = found + 2.
        CONTINUE.
      ENDIF.
      IF c2 = '!' AND starts( '<!--' ) = abap_true.
        mv_pos = mv_pos + 4.
        " the first '--' ends the comment when it is '-->', and is an error
        " otherwise
        found = seek( sub = '--'
                      off = mv_pos ).
        IF found < 0.
          mv_pos = mv_length.
          fail( '<EOF> reached' ).
        ENDIF.
        mv_pos = found.
        IF starts( '-->' ) = abap_false.
          fail( '-- in comment' ).
        ENDIF.
        mv_pos = mv_pos + 3.
        CONTINUE.
      ENDIF.
      IF c2 = '!' AND starts( '<![CDATA[' ) = abap_true.
        mv_pos = mv_pos + 9.
        begin = mv_pos.
        found = seek( sub = ']]>'
                      off = mv_pos ).
        IF found < 0.
          mv_pos = mv_length.
          fail( '<EOF> reached' ).
        ENDIF.
        mv_pos = found.
        item-kind = if_sxml_node=>co_nt_value.
        length = mv_pos - begin.
        item-value = piece( begin  = begin
                            length = length ).
        mv_pos = mv_pos + 3.
        RETURN.
      ENDIF.
      IF c2 = '!'.
        fail( '''<!--'' or ''<![CDATA['' expected' ).
      ENDIF.
      IF c = '<' AND c2 = '/'.
        close_at = mv_pos.
        mv_pos = mv_pos + 2.
        name = take_name( ).
        whitespace( ).
        IF mv_pos = mv_length.

          fail( '<EOF> reached' ).

        ENDIF.
        IF starts( '>' ) = abap_false.

          fail( 'document not wellformed' ).

        ENDIF.
        mv_pos = mv_pos + 1.
        lv_depth = lines( mt_elements ).
        IF lv_depth = 0.

          fail( 'document not wellformed' ).

        ENDIF.
        READ TABLE mt_elements INDEX lv_depth INTO element.
        IF element-name <> name.
          " a system reports the close tag where it starts (<a>e</b> at 4)
          mv_pos = close_at.
          fail( 'document not wellformed' ).

        ENDIF.
        item-kind = if_sxml_node=>co_nt_element_close.
        item-name = element-local_name.
        item-prefix = element-prefix.
        item-nsuri = element-nsuri.
        DELETE mt_elements INDEX lv_depth.
        restore( lv_depth ).
        IF mt_elements IS INITIAL.
          mv_done = abap_true.
        ENDIF.
        RETURN.
      ENDIF.
      IF c = '<'.
        mv_pos = mv_pos + 1.
        name = take_name( ).
        CLEAR: attrs, names, values.
        lv_depth = lines( mt_elements ) + 1.
        DO.
          whitespace( ).
          IF mv_pos = mv_length.

            fail( '<EOF> reached' ).

          ENDIF.
          IF starts( '/>' ) = abap_true.
            mv_pos = mv_pos + 2.
            mv_pending_close = abap_true.
            EXIT.
          ENDIF.
          IF starts( '>' ) = abap_true.
            mv_pos = mv_pos + 1.
            EXIT.
          ENDIF.
          attr_name = take_name( ).
          whitespace( ).
          IF starts( '=' ) = abap_false.

            fail( 'document not wellformed' ).

          ENDIF.
          mv_pos = mv_pos + 1.
          whitespace( ).
          IF mv_pos = mv_length.

            fail( '<EOF> reached' ).

          ENDIF.
          quote = at( mv_pos ).
          IF quote <> '"' AND quote <> ''''.
            fail( 'opening ''"'' or '''''' expected' ).
          ENDIF.
          mv_pos = mv_pos + 1.
          begin = mv_pos.
          quote_text = quote.
          found = seek( sub = quote_text
                        off = mv_pos ).
          IF found < 0.
            found = seek( sub = '<'
                          off = mv_pos ).
            IF found >= 0.
              mv_pos = found.
              fail( 'closing ''"'' expected' ).
            ENDIF.
            mv_pos = mv_length.
            fail( '<EOF> reached' ).
          ENDIF.
          length = found - begin.
          attr_value = piece( begin  = begin
                              length = length ).
          " searched in the value, never on through the document; a system
          " reports it at the start of the value (<a x="ab<"/> at 6)
          IF find( val = attr_value
                   sub = '<' ) >= 0.
            mv_pos = begin.
            fail( 'closing ''"'' expected' ).
          ENDIF.
          mv_pos = found.
          has_entity = abap_false.
          IF find( val = attr_value
                   sub = '&' ) >= 0.
            has_entity = abap_true.
          ENDIF.
          IF has_entity = abap_true.
            attr_value = decode( attr_value ).
          ENDIF.
          mv_pos = mv_pos + 1.
          IF attr_name = 'xmlns' OR ( strlen( attr_name ) >= 6 AND attr_name(6) = 'xmlns:' ).
            CLEAR binding.
            binding-depth = lv_depth.
            IF attr_name <> 'xmlns'.
              binding-prefix = attr_name+6.
            ENDIF.
            binding-nsuri = attr_value.
            READ TABLE mt_current WITH TABLE KEY prefix = binding-prefix INTO current.
            IF sy-subrc = 0.
              binding-had_previous = abap_true.
              binding-previous = current-nsuri.
              DELETE TABLE mt_current WITH TABLE KEY prefix = binding-prefix.
            ENDIF.
            APPEND binding TO mt_bindings.
            current-prefix = binding-prefix.
            current-nsuri = binding-nsuri.
            INSERT current INTO TABLE mt_current.
          ELSE.
            APPEND attr_name TO names.
            APPEND attr_value TO values.
          ENDIF.
        ENDDO.
        CLEAR element.
        element-name = name.
        SPLIT name AT ':' INTO prefix local_name.
        IF local_name IS INITIAL.
          local_name = name.
          CLEAR prefix.
        ENDIF.
        element-local_name = local_name.
        element-prefix = prefix.
        element-nsuri = lookup( prefix ).
        IF prefix IS NOT INITIAL AND element-nsuri IS INITIAL.
          fail( 'undeclared namespace prefix' ).
        ENDIF.
        IF lv_depth > 1.
          i = lv_depth - 1.
          READ TABLE mt_elements INDEX i ASSIGNING <parent>.
          <parent>-has_child = abap_true.
        ENDIF.
        APPEND element TO mt_elements.
        LOOP AT names INTO attr_name.
          i = sy-tabix.
          READ TABLE values INDEX i INTO attr_value.
          SPLIT attr_name AT ':' INTO prefix local_name.
          IF local_name IS INITIAL.
            local_name = attr_name.
            CLEAR prefix.
          ENDIF.
          CLEAR attr_nsuri.
          IF prefix IS NOT INITIAL.
            attr_nsuri = lookup( prefix ).
            IF attr_nsuri IS INITIAL.
              fail( 'undeclared namespace prefix' ).
            ENDIF.
          ENDIF.
          CREATE OBJECT attribute TYPE lcl_attribute
            EXPORTING
              name       = local_name
              prefix     = prefix
              nsuri      = attr_nsuri
              value      = attr_value
              value_type = if_sxml_value=>co_vt_text.
          APPEND attribute TO attrs.
        ENDLOOP.
        item-kind = if_sxml_node=>co_nt_element_open.
        item-name = element-local_name.
        item-prefix = element-prefix.
        item-nsuri = element-nsuri.
        item-attrs = attrs.
        RETURN.
      ENDIF.
      begin = mv_pos.
      found = seek( sub = '<'
                    off = mv_pos ).
      IF found < 0.
        mv_pos = mv_length.
      ELSE.
        mv_pos = found.
      ENDIF.
      length = mv_pos - begin.
      name = piece( begin  = begin
                    length = length ).
      spaces = ` ` && cl_abap_char_utilities=>horizontal_tab && cl_abap_char_utilities=>newline && cl_abap_char_utilities=>cr_lf(1).
      only_space = abap_false.
      IF name CO spaces.
        only_space = abap_true.
      ENDIF.
      has_entity = abap_false.
      IF find( val = name
               sub = '&' ) >= 0.
        has_entity = abap_true.
      ENDIF.
      IF mt_elements IS INITIAL.

        CONTINUE.

      ENDIF.
      length = mv_pos - begin.
      IF length = 0.

        CONTINUE.

      ENDIF.
      IF mv_pos = mv_length.

        fail( '<EOF> reached' ).

      ENDIF.
      IF only_space = abap_true.
        IF starts( '</' ) = abap_false.
          CONTINUE.
        ENDIF.
        READ TABLE mt_elements INDEX lines( mt_elements ) INTO element.
        IF element-has_child = abap_true.
          CONTINUE.
        ENDIF.
      ENDIF.
      item-kind = if_sxml_node=>co_nt_value.
      IF has_entity = abap_true.
        item-value = decode( name ).
      ELSE.
        item-value = name.
      ENDIF.
      RETURN.
    ENDWHILE.
    IF mt_elements IS NOT INITIAL.
      fail( '<EOF> reached' ).
    ENDIF.
    IF mv_length = 0.

      fail( 'BOM / charset detection failed' ).

    ENDIF.
    mv_done = abap_true.
    item-kind = if_sxml_node=>co_nt_final.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_reader DEFINITION.
  PUBLIC SECTION.
    TYPES ty_nodes TYPE STANDARD TABLE OF REF TO if_sxml_node WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING
        iv_json  TYPE string
        iv_bytes TYPE xstring OPTIONAL
        iv_utf8  TYPE abap_bool DEFAULT abap_false.
    INTERFACES if_sxml_reader.
  PRIVATE SECTION.
    METHODS initialize.
    DATA mv_json    TYPE string.
    DATA mo_xml TYPE REF TO lcl_xml_parser.
    DATA mt_xml_attrs TYPE if_sxml_attribute=>attributes.
    DATA mv_xml_attr TYPE i.
    DATA mt_nodes   TYPE ty_nodes.
    DATA mv_pointer TYPE i.
    DATA mv_initialized TYPE abap_bool.
ENDCLASS.

CLASS lcl_reader IMPLEMENTATION.
  METHOD if_sxml_reader~current_node.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~read_current_node.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~get_nsuri_by_prefix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~get_prefix_by_nsuri.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~get_nsbindings.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_sxml_reader~get_path.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD constructor.
    DATA first TYPE i.
    DATA size TYPE i.
    DATA c TYPE c LENGTH 1.
    IF iv_utf8 = abap_true.
      CREATE OBJECT mo_xml
        EXPORTING
          bytes  = iv_bytes
          binary = abap_true.
      mv_initialized = abap_false.
      RETURN.
    ENDIF.
    mv_json = iv_json.
    size = strlen( iv_json ).
    WHILE first < size.
      c = iv_json+first(1).
      IF c = space OR c = cl_abap_char_utilities=>newline OR c = cl_abap_char_utilities=>horizontal_tab
          OR c = cl_abap_char_utilities=>cr_lf(1).
        first = first + 1.
      ELSE.
        EXIT.
      ENDIF.
    ENDWHILE.
    IF iv_json IS INITIAL OR ( first < size AND iv_json+first(1) = '<' ).
      CREATE OBJECT mo_xml EXPORTING source = iv_json.
      CLEAR mv_json.
    ENDIF.
    mv_initialized = abap_false.
  ENDMETHOD.

  METHOD if_sxml_reader~set_option.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD initialize.

    DATA lo_json       TYPE REF TO lcl_json_parser.
    DATA lt_parsed     TYPE REF TO lcl_json_parser=>ty_nodes.
    DATA li_node       TYPE REF TO if_sxml_node.
    DATA lt_attributes TYPE if_sxml_attribute=>attributes.
    DATA li_attribute  TYPE REF TO if_sxml_attribute.

    FIELD-SYMBOLS <ls_parsed> TYPE lcl_json_parser=>ty_node.

    ASSERT mv_initialized = abap_false.
    mv_initialized = abap_true.

* todo: for now this only handles json, but the class is really meant for XML
    CREATE OBJECT lo_json.
    CREATE DATA lt_parsed.
    lo_json->parse(
      iv_json  = mv_json
      it_nodes = lt_parsed ).
    CLEAR lo_json. " release memory

    LOOP AT lt_parsed->* ASSIGNING <ls_parsed>.
      CASE <ls_parsed>-type.
        WHEN if_sxml_node=>co_nt_element_open.
          CLEAR lt_attributes.
          IF <ls_parsed>-has_key = abap_true.
            CREATE OBJECT li_attribute TYPE lcl_attribute
              EXPORTING
                name       = 'name'
                value      = <ls_parsed>-key
                value_type = if_sxml_value=>co_vt_text.
            APPEND li_attribute TO lt_attributes.
          ENDIF.

          CREATE OBJECT li_node TYPE lcl_open_node
            EXPORTING
              name       = <ls_parsed>-name
              attributes = lt_attributes.
        WHEN if_sxml_node=>co_nt_element_close.
          CREATE OBJECT li_node TYPE lcl_close_node
            EXPORTING
              name = <ls_parsed>-name.
        WHEN if_sxml_node=>co_nt_value.
          CREATE OBJECT li_node TYPE lcl_value_node
            EXPORTING
              value = <ls_parsed>-value.
        WHEN OTHERS.
          ASSERT 1 = 2.
      ENDCASE.
      APPEND li_node TO mt_nodes.
    ENDLOOP.

    CLEAR mv_json.
    mv_pointer = 1.
  ENDMETHOD.

  METHOD if_sxml_reader~next_attribute.
    DATA attr TYPE REF TO if_sxml_attribute.
    mv_xml_attr = mv_xml_attr + 1.
    READ TABLE mt_xml_attrs INDEX mv_xml_attr INTO attr.
    IF sy-subrc = 0.
      if_sxml_reader~node_type = if_sxml_node=>co_nt_attribute.
      if_sxml_reader~name = attr->qname-name.
      if_sxml_reader~prefix = attr->prefix.
      if_sxml_reader~nsuri = attr->qname-namespace.
      if_sxml_reader~value = attr->get_value( ).
      if_sxml_reader~value_type = if_sxml_value=>co_vt_text.
    ELSE.
      if_sxml_reader~node_type = if_sxml_node=>co_nt_final.
    ENDIF.
  ENDMETHOD.

  METHOD if_sxml_reader~next_node.
    DATA xml TYPE lcl_xml_parser=>ty_item.
    IF mo_xml IS BOUND.
      xml = mo_xml->next( ).
      if_sxml_reader~node_type = xml-kind.
      IF xml-kind = if_sxml_node=>co_nt_final.
        RETURN.
      ENDIF.
      if_sxml_reader~name = xml-name.
      if_sxml_reader~prefix = xml-prefix.
      if_sxml_reader~nsuri = xml-nsuri.
      CLEAR mt_xml_attrs.
      mv_xml_attr = 0.
      IF xml-kind = if_sxml_node=>co_nt_element_open.
        mt_xml_attrs = xml-attrs.
      ELSEIF xml-kind = if_sxml_node=>co_nt_value.
        if_sxml_reader~value = xml-value.
        if_sxml_reader~value_type = if_sxml_value=>co_vt_text.
      ENDIF.
      RETURN.
    ENDIF.
    if_sxml_reader~read_next_node( ).
  ENDMETHOD.

  METHOD if_sxml_reader~skip_node.
    DATA level TYPE i.
    IF mo_xml IS NOT BOUND OR if_sxml_reader~node_type <> if_sxml_node=>co_nt_element_open.
      RETURN.
    ENDIF.
    level = 1.
    WHILE level > 0.
      if_sxml_reader~next_node( ).
      IF if_sxml_reader~node_type = if_sxml_node=>co_nt_element_open.
        level = level + 1.
      ELSEIF if_sxml_reader~node_type = if_sxml_node=>co_nt_element_close.
        level = level - 1.
      ELSEIF if_sxml_reader~node_type = if_sxml_node=>co_nt_final.
        EXIT.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD if_sxml_reader~read_next_node.
    DATA xml TYPE lcl_xml_parser=>ty_item.
    DATA open TYPE REF TO if_sxml_open_element.
    DATA close TYPE REF TO if_sxml_close_element.
    DATA value TYPE REF TO if_sxml_value_node.
    DATA attr TYPE REF TO if_sxml_attribute.
    DATA attrs TYPE if_sxml_attribute=>attributes.
    IF mo_xml IS BOUND.
      xml = mo_xml->next( ).
      if_sxml_reader~node_type = xml-kind.
      IF xml-kind = if_sxml_node=>co_nt_final.
        RETURN.
      ENDIF.
      if_sxml_reader~name = xml-name.
      if_sxml_reader~prefix = xml-prefix.
      if_sxml_reader~nsuri = xml-nsuri.
      CLEAR mt_xml_attrs.
      mv_xml_attr = 0.
      CASE xml-kind.
        WHEN if_sxml_node=>co_nt_element_open.
          mt_xml_attrs = xml-attrs.
          CREATE OBJECT node TYPE cl_sxml_open_element
            EXPORTING
              name       = xml-name
              prefix     = xml-prefix
              nsuri      = xml-nsuri
              attributes = xml-attrs.
        WHEN if_sxml_node=>co_nt_element_close.
          CREATE OBJECT node TYPE cl_sxml_close_element
            EXPORTING
              name  = xml-name
              nsuri = xml-nsuri.
        WHEN if_sxml_node=>co_nt_value.
          if_sxml_reader~value = xml-value.
          if_sxml_reader~value_type = if_sxml_value=>co_vt_text.
          CREATE OBJECT node TYPE cl_sxml_value EXPORTING value = xml-value.
      ENDCASE.
      RETURN.
    ENDIF.
    IF mv_initialized = abap_false.
      initialize( ).
    ENDIF.
    READ TABLE mt_nodes INDEX mv_pointer INTO node.
    mv_pointer = mv_pointer + 1.

    IF node IS NOT INITIAL.
      if_sxml_reader~node_type = node->type.

      CASE if_sxml_reader~node_type.
        WHEN if_sxml_node=>co_nt_element_open.
          open ?= node.
          if_sxml_reader~name = open->qname-name.

          attrs = open->get_attributes( ).
          READ TABLE attrs INDEX 1 INTO attr.
          IF sy-subrc = 0.
            if_sxml_reader~value = attr->get_value( ).
          ENDIF.
        WHEN if_sxml_node=>co_nt_element_close.
          close ?= node.
          if_sxml_reader~name = close->qname-name.
          CLEAR if_sxml_reader~value.
        WHEN if_sxml_node=>co_nt_value.
          value ?= node.
          if_sxml_reader~value = value->get_value( ).
        WHEN OTHERS.
          CLEAR if_sxml_reader~name.
      ENDCASE.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
