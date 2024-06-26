CLASS cl_abap_hmac DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS calculate_hmac_for_raw
      IMPORTING
        if_algorithm     TYPE string DEFAULT 'SHA1'
        if_key           TYPE xstring
        if_data          TYPE xstring
        if_length        TYPE i OPTIONAL
      EXPORTING
        ef_hmacstring    TYPE string
        ef_hmacxstring   TYPE xstring
        ef_hmacb64string TYPE string
      RAISING
        cx_abap_message_digest.

    CLASS-METHODS calculate_hmac_for_char
      IMPORTING
        if_algorithm     TYPE string DEFAULT 'SHA1'
        if_key           TYPE xstring
        if_data          TYPE string
      EXPORTING
        ef_hmacstring    TYPE string
        ef_hmacxstring   TYPE xstring
        ef_hmacb64string TYPE string
      RAISING
        cx_abap_message_digest.

    CLASS-METHODS string_to_xstring
      IMPORTING
        if_input         TYPE string
      RETURNING
        VALUE(er_output) TYPE xstring
      RAISING
        cx_abap_message_digest.
ENDCLASS.

CLASS cl_abap_hmac IMPLEMENTATION.
  METHOD calculate_hmac_for_raw.

    DATA lv_algorithm TYPE string.

    CLEAR ef_hmacstring.
    CLEAR ef_hmacxstring.

    " todo,
    ASSERT if_length = 0.

    lv_algorithm = to_lower( if_algorithm ).
    ASSERT lv_algorithm = 'sha1' OR lv_algorithm = 'md5' OR lv_algorithm = 'sha256'.

* todo, this doesnt work in browser?
    WRITE '@KERNEL const crypto = await import("crypto");'.
    IF if_key IS INITIAL.
      WRITE '@KERNEL var shasum = crypto.createHash(lv_algorithm.get());'.
      WRITE '@KERNEL shasum.update(if_data.get(), "hex");'.
      WRITE '@KERNEL ef_hmacstring.set(shasum.digest("hex").toUpperCase());'.
    ELSE.
      WRITE '@KERNEL let hmac = crypto.createHmac(lv_algorithm.get(), Buffer.from(if_key.get(), "hex")).update(if_data.get(), "hex").digest("hex").toUpperCase();'.
      WRITE '@KERNEL ef_hmacstring.set(hmac);'.
    ENDIF.

    WRITE '@KERNEL ef_hmacb64string.set(Buffer.from(ef_hmacstring.get(), "hex").toString("base64"));'.

    ef_hmacxstring = ef_hmacstring.

  ENDMETHOD.

  METHOD calculate_hmac_for_char.
    DATA lv_xstr TYPE xstring.

* convert to utf8
    lv_xstr = string_to_xstring( if_data ).

    calculate_hmac_for_raw(
      EXPORTING
        if_algorithm     = if_algorithm
        if_key           = if_key
        if_data          = lv_xstr
      IMPORTING
        ef_hmacstring    = ef_hmacstring
        ef_hmacxstring   = ef_hmacxstring
        ef_hmacb64string = ef_hmacb64string ).
  ENDMETHOD.

  METHOD string_to_xstring.
    er_output = cl_abap_codepage=>convert_to( if_input ).
  ENDMETHOD.
ENDCLASS.