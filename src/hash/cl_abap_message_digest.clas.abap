CLASS cl_abap_message_digest DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS calculate_hash_for_raw
      IMPORTING
        if_algorithm   TYPE string DEFAULT 'SHA1'
        if_data        TYPE xstring
      EXPORTING
        ef_hashxstring TYPE xstring
      RAISING
        cx_abap_message_digest.
ENDCLASS.

CLASS cl_abap_message_digest IMPLEMENTATION.
  METHOD calculate_hash_for_raw.

    DATA lv_algorithm TYPE string.

    lv_algorithm = to_lower( if_algorithm ).
    ASSERT lv_algorithm = 'sha1' OR lv_algorithm = 'md5' OR lv_algorithm = 'sha256'.

* todo, this doesnt work in browser?
    WRITE '@KERNEL const crypto = await import("crypto");'.
    WRITE '@KERNEL var shasum = crypto.createHash(lv_algorithm.get());'.
    WRITE '@KERNEL shasum.update(if_data.get(), "hex");'.
    WRITE '@KERNEL ef_hashxstring.set(shasum.digest("hex").toUpperCase());'.

  ENDMETHOD.
ENDCLASS.