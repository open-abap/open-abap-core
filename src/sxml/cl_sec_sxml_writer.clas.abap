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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.