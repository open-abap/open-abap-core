CLASS cl_sec_sxml_writer DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS co_aes128_algorithm TYPE string VALUE 'http://www.w3.org/2001/04/xmlenc#aes128-cbc' ##NO_TEXT.
    CONSTANTS co_aes192_algorithm TYPE string VALUE 'http://www.w3.org/2001/04/xmlenc#aes192-cbc' ##NO_TEXT.
    CONSTANTS co_aes256_algorithm TYPE string VALUE 'http://www.w3.org/2001/04/xmlenc#aes256-cbc' ##NO_TEXT.

    CLASS-METHODS crypt_aes_ctr
      IMPORTING
        input     TYPE xstring
        key       TYPE xstring
        iv        TYPE xstring
        algorithm TYPE string DEFAULT co_aes128_algorithm
      EXPORTING
        result    TYPE xstring.
ENDCLASS.

CLASS cl_sec_sxml_writer IMPLEMENTATION.

  METHOD crypt_aes_ctr.
    DATA lv_algo TYPE string.

    CASE algorithm.
      WHEN co_aes128_algorithm.
        lv_algo = 'aes-128-ctr'.
      WHEN co_aes256_algorithm.
        lv_algo = 'aes-256-ctr'.
      WHEN OTHERS.
        ASSERT 1 = 'todo'.
    ENDCASE.

    WRITE '@KERNEL const crypto = await import("crypto");'.

    WRITE '@KERNEL const js_key = Buffer.from(key.get(), "hex");'.
    WRITE '@KERNEL const js_iv = Buffer.from(iv.get(), "hex");'.
    WRITE '@KERNEL const js_input = Buffer.from(input.get(), "hex");'.

    WRITE '@KERNEL const cipher = crypto.createDecipheriv(lv_algo.get(), js_key, js_iv);'.
    WRITE '@KERNEL const encrypted = cipher.update(js_input);'.

    WRITE '@KERNEL result.set(encrypted.toString("hex").toUpperCase());'.
  ENDMETHOD.

ENDCLASS.