CLASS cl_abap_hmac DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS calculate_hmac_for_raw
      IMPORTING
        if_algorithm   TYPE string DEFAULT 'SHA1'
        if_key         TYPE xstring
        if_data        TYPE xstring
      EXPORTING
        ef_hmacstring  TYPE string
        ef_hmacxstring TYPE xstring
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
ENDCLASS.

CLASS cl_abap_hmac IMPLEMENTATION.
  METHOD calculate_hmac_for_raw.

    DATA lv_algorithm TYPE string.

    CLEAR ef_hmacstring.
    CLEAR ef_hmacxstring.

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

    ef_hmacxstring = ef_hmacstring.

  ENDMETHOD.

  METHOD calculate_hmac_for_char.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.