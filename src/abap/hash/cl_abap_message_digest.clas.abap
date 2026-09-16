CLASS cl_abap_message_digest DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING
        if_algorithm TYPE string
      RAISING
        cx_abap_message_digest.

    CLASS-METHODS get_instance
      IMPORTING
        if_algorithm     TYPE string DEFAULT 'SHA1'
      RETURNING
        VALUE(ro_object) TYPE REF TO cl_abap_message_digest
      RAISING
        cx_abap_message_digest.

    METHODS get_algorithm
      RETURNING
        VALUE(rf_algorithm) TYPE string.

    METHODS get_digest_length
      RETURNING
        VALUE(ri_length) TYPE i
      RAISING
        cx_abap_message_digest.

    METHODS get_digest
      RETURNING
        VALUE(er_hash) TYPE xstring
      RAISING
        cx_abap_message_digest.

    METHODS update
      IMPORTING
        if_data   TYPE xstring
        if_offset TYPE i DEFAULT 0
        if_length TYPE i DEFAULT 0
      RAISING
        cx_abap_message_digest.

    METHODS digest
      IMPORTING
        if_data          TYPE xstring OPTIONAL
        if_offset        TYPE i DEFAULT 0
        if_length        TYPE i DEFAULT 0
      EXPORTING
        ef_hashstring    TYPE string
        ef_hashxstring   TYPE xstring
        ef_hashb64string TYPE string
        ef_hashx         TYPE xsequence
      RAISING
        cx_abap_message_digest.

    METHODS reset
      RAISING
        cx_abap_message_digest.

    METHODS to_string
      RETURNING
        VALUE(er_hashstring) TYPE string
      RAISING
        cx_abap_message_digest.

    METHODS to_base64
      RETURNING
        VALUE(er_hashb64string) TYPE string
      RAISING
        cx_abap_message_digest.

    CLASS-METHODS is_equal
      IMPORTING
        if_digesta      TYPE xstring
        if_digestb      TYPE xstring
      RETURNING
        VALUE(er_equal) TYPE abap_bool.

    CLASS-METHODS calculate_hash_for_char
      IMPORTING
        if_algorithm     TYPE string DEFAULT 'SHA1'
        if_data          TYPE string
        if_length        TYPE i DEFAULT 0
      EXPORTING
        ef_hashstring    TYPE string
        ef_hashxstring   TYPE xstring
        ef_hashb64string TYPE string
        ef_hashx         TYPE xsequence
      RAISING
        cx_abap_message_digest.

    CLASS-METHODS calculate_hash_for_raw
      IMPORTING
        if_algorithm     TYPE string DEFAULT 'SHA1'
        if_data          TYPE xstring
        if_length        TYPE i DEFAULT 0
      EXPORTING
        ef_hashstring    TYPE string
        ef_hashxstring   TYPE xstring
        ef_hashb64string TYPE string
        ef_hashx         TYPE xsequence
      RAISING
        cx_abap_message_digest.

    CLASS-METHODS string_to_xstring
      IMPORTING
        if_input         TYPE string
      RETURNING
        VALUE(er_output) TYPE xstring
      RAISING
        cx_abap_message_digest.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_algorithm,
             name   TYPE string,
             node   TYPE string,
             length TYPE i,
           END OF ty_algorithm.
    TYPES ty_algorithms TYPE STANDARD TABLE OF ty_algorithm WITH KEY name.

    CLASS-DATA gt_algorithms TYPE ty_algorithms.

    DATA mv_algorithm TYPE string.
    DATA ms_algorithm TYPE ty_algorithm.
    DATA mv_buffer    TYPE xstring.
    DATA mv_digest    TYPE xstring.

    CLASS-METHODS resolve
      IMPORTING
        if_algorithm        TYPE string
      RETURNING
        VALUE(rs_algorithm) TYPE ty_algorithm
      RAISING
        cx_abap_message_digest.

    CLASS-METHODS slice
      IMPORTING
        if_data        TYPE xstring
        if_offset      TYPE i
        if_length      TYPE i
      RETURNING
        VALUE(rv_data) TYPE xstring
      RAISING
        cx_abap_message_digest.

    CLASS-METHODS hash
      IMPORTING
        iv_node        TYPE string
        iv_data        TYPE xstring
      RETURNING
        VALUE(rv_hash) TYPE xstring.

    CLASS-METHODS to_hex
      IMPORTING
        iv_data          TYPE xstring
      RETURNING
        VALUE(rv_string) TYPE string.

    CLASS-METHODS base64
      IMPORTING
        iv_data          TYPE xstring
      RETURNING
        VALUE(rv_base64) TYPE string.
ENDCLASS.

CLASS cl_abap_message_digest IMPLEMENTATION.

  METHOD class_constructor.
    DATA ls_algorithm TYPE ty_algorithm.

* Names as the kernel accepts them; the node column is the Node.js crypto name
    ls_algorithm-name   = 'MD5'.
    ls_algorithm-node   = 'md5'.
    ls_algorithm-length = 16.
    APPEND ls_algorithm TO gt_algorithms.

    ls_algorithm-name   = 'SHA1'.
    ls_algorithm-node   = 'sha1'.
    ls_algorithm-length = 20.
    APPEND ls_algorithm TO gt_algorithms.

    ls_algorithm-name   = 'SHA224'.
    ls_algorithm-node   = 'sha224'.
    ls_algorithm-length = 28.
    APPEND ls_algorithm TO gt_algorithms.

    ls_algorithm-name   = 'SHA256'.
    ls_algorithm-node   = 'sha256'.
    ls_algorithm-length = 32.
    APPEND ls_algorithm TO gt_algorithms.

    ls_algorithm-name   = 'SHA384'.
    ls_algorithm-node   = 'sha384'.
    ls_algorithm-length = 48.
    APPEND ls_algorithm TO gt_algorithms.

    ls_algorithm-name   = 'SHA512'.
    ls_algorithm-node   = 'sha512'.
    ls_algorithm-length = 64.
    APPEND ls_algorithm TO gt_algorithms.
  ENDMETHOD.

  METHOD resolve.
    DATA lv_name TYPE string.

* the kernel accepts both "SHA256" and "SHA-256", in any case
    lv_name = to_upper( if_algorithm ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_name WITH ''.
    CONDENSE lv_name NO-GAPS.

    READ TABLE gt_algorithms INTO rs_algorithm WITH KEY name = lv_name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_message_digest
        EXPORTING
          textid    = cx_abap_message_digest=>unknown_algorithm
          algorithm = if_algorithm.
    ENDIF.
  ENDMETHOD.

  METHOD slice.
    DATA lv_available TYPE i.

    lv_available = xstrlen( if_data ) - if_offset.
    IF if_offset < 0 OR if_length < 0 OR lv_available < 0 OR if_length > lv_available.
      RAISE EXCEPTION TYPE cx_abap_message_digest
        EXPORTING
          textid = cx_abap_message_digest=>param_error.
    ENDIF.

    IF if_length = 0.
      rv_data = if_data+if_offset.
    ELSE.
      rv_data = if_data+if_offset(if_length).
    ENDIF.
  ENDMETHOD.

  METHOD hash.
* todo, this doesnt work in browser?
    WRITE '@KERNEL const crypto = await import("crypto");'.
    WRITE '@KERNEL rv_hash.set(crypto.createHash(iv_node.get()).update(iv_data.get(), "hex").digest("hex").toUpperCase());'.
  ENDMETHOD.

  METHOD to_hex.
    rv_string = iv_data.
  ENDMETHOD.

  METHOD base64.
    WRITE '@KERNEL rv_base64.set(Buffer.from(iv_data.get(), "hex").toString("base64"));'.
  ENDMETHOD.

  METHOD constructor.
    ms_algorithm = resolve( if_algorithm ).
    mv_algorithm = if_algorithm.
  ENDMETHOD.

  METHOD get_instance.
    ro_object = NEW #( if_algorithm ).
  ENDMETHOD.

  METHOD get_algorithm.
    rf_algorithm = mv_algorithm.
  ENDMETHOD.

  METHOD get_digest_length.
    ri_length = ms_algorithm-length.
  ENDMETHOD.

  METHOD get_digest.
    er_hash = mv_digest.
  ENDMETHOD.

  METHOD update.
    DATA lv_data TYPE xstring.

    lv_data = slice(
      if_data   = if_data
      if_offset = if_offset
      if_length = if_length ).
    CONCATENATE mv_buffer lv_data INTO mv_buffer IN BYTE MODE.
  ENDMETHOD.

  METHOD digest.
    IF if_data IS SUPPLIED.
      update(
        if_data   = if_data
        if_offset = if_offset
        if_length = if_length ).
    ENDIF.

    mv_digest = hash(
      iv_node = ms_algorithm-node
      iv_data = mv_buffer ).
    CLEAR mv_buffer.

    ef_hashxstring   = mv_digest.
    ef_hashstring    = to_hex( mv_digest ).
    ef_hashb64string = base64( mv_digest ).
    ef_hashx         = mv_digest.
  ENDMETHOD.

  METHOD reset.
    CLEAR mv_buffer.
    CLEAR mv_digest.
  ENDMETHOD.

  METHOD to_string.
    er_hashstring = to_hex( mv_digest ).
  ENDMETHOD.

  METHOD to_base64.
    er_hashb64string = base64( mv_digest ).
  ENDMETHOD.

  METHOD is_equal.
    er_equal = xsdbool( if_digesta = if_digestb ).
  ENDMETHOD.

  METHOD calculate_hash_for_raw.
    DATA ls_algorithm TYPE ty_algorithm.
    DATA lv_data      TYPE xstring.

    ls_algorithm = resolve( if_algorithm ).
    lv_data = slice(
      if_data   = if_data
      if_offset = 0
      if_length = if_length ).

    ef_hashxstring = hash(
      iv_node = ls_algorithm-node
      iv_data = lv_data ).
    ef_hashstring    = to_hex( ef_hashxstring ).
    ef_hashb64string = base64( ef_hashxstring ).
    ef_hashx         = ef_hashxstring.
  ENDMETHOD.

  METHOD calculate_hash_for_char.
    DATA lv_data TYPE string.

    IF if_length > 0.
      lv_data = if_data(if_length).
    ELSE.
      lv_data = if_data.
    ENDIF.

    calculate_hash_for_raw(
      EXPORTING
        if_algorithm     = if_algorithm
        if_data          = string_to_xstring( lv_data )
      IMPORTING
        ef_hashstring    = ef_hashstring
        ef_hashxstring   = ef_hashxstring
        ef_hashb64string = ef_hashb64string
        ef_hashx         = ef_hashx ).
  ENDMETHOD.

  METHOD string_to_xstring.
    er_output = cl_abap_codepage=>convert_to( if_input ).
  ENDMETHOD.

ENDCLASS.
