CLASS cl_abap_hmac DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS calculate_hmac_for_raw
      IMPORTING
        if_key        TYPE xstring
        if_data       TYPE xstring
      EXPORTING
        ef_hmacstring TYPE string.
ENDCLASS.

CLASS cl_abap_hmac IMPLEMENTATION.
  METHOD calculate_hmac_for_raw.
    ASSERT if_key IS INITIAL.
    CLEAR ef_hmacstring.

    WRITE '@KERNEL var crypto = require("crypto");'.
    WRITE '@KERNEL var shasum = crypto.createHash("sha1");'.
    WRITE '@KERNEL shasum.update(if_data.get(), "hex");'.
    WRITE '@KERNEL ef_hmacstring.set(shasum.digest("hex").toUpperCase());'.

  ENDMETHOD.
ENDCLASS.