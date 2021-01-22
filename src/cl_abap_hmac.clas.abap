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
ENDCLASS.

CLASS cl_abap_hmac IMPLEMENTATION.
  METHOD calculate_hmac_for_raw.

    DATA lv_algorithm TYPE string.

    ASSERT if_key IS INITIAL.
    CLEAR ef_hmacstring.
    CLEAR ef_hmacxstring.

    lv_algorithm = to_lower( if_algorithm ).
    ASSERT lv_algorithm = 'sha1' OR lv_algorithm = 'md5'.

    WRITE '@KERNEL var crypto = require("crypto");'.
    WRITE '@KERNEL var shasum = crypto.createHash(lv_algorithm.get());'.
    WRITE '@KERNEL shasum.update(if_data.get(), "hex");'.
    WRITE '@KERNEL ef_hmacstring.set(shasum.digest("hex").toUpperCase());'.

    ef_hmacxstring = ef_hmacstring.

  ENDMETHOD.
ENDCLASS.