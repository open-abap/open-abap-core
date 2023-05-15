CLASS cl_i18n_languages DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS sap1_to_sap2
      IMPORTING
        im_lang_sap1        TYPE sy-langu
      RETURNING
        VALUE(re_lang_sap2) TYPE string
      EXCEPTIONS
        no_assignment.

    CLASS-METHODS sap2_to_sap1
      IMPORTING
        im_lang_sap2 TYPE laiso
      RETURNING
        VALUE(re_lang_sap1) TYPE sy-langu
      EXCEPTIONS
        no_assignment.

    CLASS-METHODS sap2_to_iso639_1
      IMPORTING
        im_lang_sap2   TYPE laiso
      EXPORTING
        ex_lang_iso639 TYPE string
        ex_country     TYPE land1
      EXCEPTIONS
        no_assignment.
ENDCLASS.

CLASS cl_i18n_languages IMPLEMENTATION.
  METHOD sap2_to_sap1.
    CASE to_upper( im_lang_sap2 ).
      WHEN 'SR'.
        re_lang_sap1 = '0'.
      WHEN 'ZH'.
        re_lang_sap1 = '1'.
      WHEN 'TH'.
        re_lang_sap1 = '2'.
      WHEN 'KO'.
        re_lang_sap1 = '3'.
      WHEN 'RO'.
        re_lang_sap1 = '4'.
      WHEN 'SL'.
        re_lang_sap1 = '5'.
      WHEN 'HR'.
        re_lang_sap1 = '6'.
      WHEN 'MS'.
        re_lang_sap1 = '7'.
      WHEN 'UK'.
        re_lang_sap1 = '8'.
      WHEN 'ET'.
        re_lang_sap1 = '9'.
      WHEN 'AR'.
        re_lang_sap1 = 'A'.
      WHEN 'HE'.
        re_lang_sap1 = 'B'.
      WHEN 'CS'.
        re_lang_sap1 = 'C'.
      WHEN 'DE'.
        re_lang_sap1 = 'D'.
      WHEN 'EN'.
        re_lang_sap1 = 'E'.
      WHEN 'FR'.
        re_lang_sap1 = 'F'.
      WHEN 'EL'.
        re_lang_sap1 = 'G'.
      WHEN 'HU'.
        re_lang_sap1 = 'H'.
      WHEN 'IT'.
        re_lang_sap1 = 'I'.
      WHEN 'JA'.
        re_lang_sap1 = 'J'.
      WHEN 'DA'.
        re_lang_sap1 = 'K'.
      WHEN 'PL'.
        re_lang_sap1 = 'L'.
      WHEN 'ZF'.
        re_lang_sap1 = 'M'.
      WHEN 'NL'.
        re_lang_sap1 = 'N'.
      WHEN 'NO'.
        re_lang_sap1 = 'O'.
      WHEN 'PT'.
        re_lang_sap1 = 'P'.
      WHEN 'SK'.
        re_lang_sap1 = 'Q'.
      WHEN 'RU'.
        re_lang_sap1 = 'R'.
      WHEN 'ES'.
        re_lang_sap1 = 'S'.
      WHEN 'TR'.
        re_lang_sap1 = 'T'.
      WHEN 'FI'.
        re_lang_sap1 = 'U'.
      WHEN 'SV'.
        re_lang_sap1 = 'V'.
      WHEN 'BG'.
        re_lang_sap1 = 'W'.
      WHEN 'LT'.
        re_lang_sap1 = 'X'.
      WHEN 'LV'.
        re_lang_sap1 = 'Y'.
      WHEN 'Z1'.
        re_lang_sap1 = 'Z'.
      WHEN 'AF'.
        re_lang_sap1 = 'a'.
      WHEN 'IS'.
        re_lang_sap1 = 'b'.
      WHEN 'CA'.
        re_lang_sap1 = 'c'.
      WHEN 'SH'.
        re_lang_sap1 = 'd'.
      WHEN 'ID'.
        re_lang_sap1 = 'i'.
      WHEN '1Q'.
        re_lang_sap1 = ''.
      WHEN OTHERS.
        RAISE no_assignment.
    ENDCASE.
  ENDMETHOD.

  METHOD sap1_to_sap2.
* todo, ideally this should look up in a database table first
* if there is no database attached, fallback to the CASE below
    CASE im_lang_sap1.
      WHEN '0'.
        re_lang_sap2 = 'SR'.
      WHEN '1'.
        re_lang_sap2 = 'ZH'.
      WHEN '2'.
        re_lang_sap2 = 'TH'.
      WHEN '3'.
        re_lang_sap2 = 'KO'.
      WHEN '4'.
        re_lang_sap2 = 'RO'.
      WHEN '5'.
        re_lang_sap2 = 'SL'.
      WHEN '6'.
        re_lang_sap2 = 'HR'.
      WHEN '7'.
        re_lang_sap2 = 'MS'.
      WHEN '8'.
        re_lang_sap2 = 'UK'.
      WHEN '9'.
        re_lang_sap2 = 'ET'.
      WHEN 'A'.
        re_lang_sap2 = 'AR'.
      WHEN 'B'.
        re_lang_sap2 = 'HE'.
      WHEN 'C'.
        re_lang_sap2 = 'CS'.
      WHEN 'D'.
        re_lang_sap2 = 'DE'.
      WHEN 'E'.
        re_lang_sap2 = 'EN'.
      WHEN 'F'.
        re_lang_sap2 = 'FR'.
      WHEN 'G'.
        re_lang_sap2 = 'EL'.
      WHEN 'H'.
        re_lang_sap2 = 'HU'.
      WHEN 'I'.
        re_lang_sap2 = 'IT'.
      WHEN 'J'.
        re_lang_sap2 = 'JA'.
      WHEN 'K'.
        re_lang_sap2 = 'DA'.
      WHEN 'L'.
        re_lang_sap2 = 'PL'.
      WHEN 'M'.
        re_lang_sap2 = 'ZF'.
      WHEN 'N'.
        re_lang_sap2 = 'NL'.
      WHEN 'O'.
        re_lang_sap2 = 'NO'.
      WHEN 'P'.
        re_lang_sap2 = 'PT'.
      WHEN 'Q'.
        re_lang_sap2 = 'SK'.
      WHEN 'R'.
        re_lang_sap2 = 'RU'.
      WHEN 'S'.
        re_lang_sap2 = 'ES'.
      WHEN 'T'.
        re_lang_sap2 = 'TR'.
      WHEN 'U'.
        re_lang_sap2 = 'FI'.
      WHEN 'V'.
        re_lang_sap2 = 'SV'.
      WHEN 'W'.
        re_lang_sap2 = 'BG'.
      WHEN 'X'.
        re_lang_sap2 = 'LT'.
      WHEN 'Y'.
        re_lang_sap2 = 'LV'.
      WHEN 'Z'.
        re_lang_sap2 = 'Z1'.
      WHEN 'a'.
        re_lang_sap2 = 'AF'.
      WHEN 'b'.
        re_lang_sap2 = 'IS'.
      WHEN 'c'.
        re_lang_sap2 = 'CA'.
      WHEN 'd'.
        re_lang_sap2 = 'SH'.
      WHEN 'i'.
        re_lang_sap2 = 'ID'.
      WHEN OTHERS.
        RAISE no_assignment.
    ENDCASE.
  ENDMETHOD.

  METHOD sap2_to_iso639_1.
    CASE im_lang_sap2.
      WHEN 'SR'.
        ex_lang_iso639 = 'sr'.
      WHEN 'ZH'.
        ex_lang_iso639 = 'zh'.
        ex_country = 'CN'.
      WHEN 'TH'.
        ex_lang_iso639 = 'th'.
      WHEN 'KO'.
        ex_lang_iso639 = 'ko'.
        ex_country = 'KR'.
      WHEN 'RO'.
        ex_lang_iso639 = 'ro'.
        ex_country = 'RO'.
      WHEN 'SL'.
        ex_lang_iso639 = 'sl'.
      WHEN 'HR'.
        ex_lang_iso639 = 'hr'.
      WHEN 'MS'.
        ex_lang_iso639 = 'ms'.
        ex_country = 'MY'.
      WHEN 'UK'.
        ex_lang_iso639 = 'uk'.
      WHEN 'ET'.
        ex_lang_iso639 = 'et'.
      WHEN 'AR'.
        ex_lang_iso639 = 'ar'.
        ex_country = 'SA'.
      WHEN 'HE'.
        ex_lang_iso639 = 'he'.
      WHEN 'CS'.
        ex_lang_iso639 = 'cs'.
      WHEN 'DE'.
        ex_lang_iso639 = 'de'.
        ex_country = 'DE'.
      WHEN 'EN'.
        ex_lang_iso639 = 'en'.
        ex_country = 'US'.
      WHEN 'FR'.
        ex_lang_iso639 = 'fr'.
        ex_country = 'FR'.
      WHEN 'EL'.
        ex_lang_iso639 = 'el'.
      WHEN 'HU'.
        ex_lang_iso639 = 'hu'.
      WHEN 'IT'.
        ex_lang_iso639 = 'it'.
        ex_country = 'IT'.
      WHEN 'JA'.
        ex_lang_iso639 = 'ja'.
      WHEN 'DA'.
        ex_lang_iso639 = 'da'.
      WHEN 'PL'.
        ex_lang_iso639 = 'pl'.
      WHEN 'ZF'.
        ex_lang_iso639 = 'zh'.
        ex_country = 'TW'.
      WHEN 'NL'.
        ex_lang_iso639 = 'nl'.
        ex_country = 'NL'.
      WHEN 'NO'.
        ex_lang_iso639 = 'no'.
      WHEN 'PT'.
        ex_lang_iso639 = 'pt'.
        ex_country = 'BR'.
      WHEN 'SK'.
        ex_lang_iso639 = 'sk'.
      WHEN 'RU'.
        ex_lang_iso639 = 'ru'.
        ex_country = 'RU'.
      WHEN 'ES'.
        ex_lang_iso639 = 'es'.
        ex_country = 'ES'.
      WHEN 'TR'.
        ex_lang_iso639 = 'tr'.
      WHEN 'FI'.
        ex_lang_iso639 = 'fi'.
      WHEN 'SV'.
        ex_lang_iso639 = 'sv'.
      WHEN 'BG'.
        ex_lang_iso639 = 'bg'.
      WHEN 'LT'.
        ex_lang_iso639 = 'lt'.
      WHEN 'LV'.
        ex_lang_iso639 = 'lv'.
      WHEN 'AF'.
        ex_lang_iso639 = 'af'.
      WHEN 'IS'.
        ex_lang_iso639 = 'is'.
      WHEN 'CA'.
        ex_lang_iso639 = 'ca'.
      WHEN 'SH'.
        ex_lang_iso639 = 'sr'.
      WHEN 'ID'.
        ex_lang_iso639 = 'id'.
      WHEN OTHERS.
        RAISE no_assignment.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.