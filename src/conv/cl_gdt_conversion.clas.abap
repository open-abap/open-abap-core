CLASS cl_gdt_conversion DEFINITION PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS language_code_outbound
      IMPORTING
        im_value TYPE spras
      EXPORTING
        ex_value TYPE laiso.

    CLASS-METHODS language_code_inbound
      IMPORTING
        im_value TYPE csequence
      EXPORTING
        ex_value TYPE spras
      RAISING
        cx_gdt_conversion.

    CLASS-METHODS amount_outbound
      IMPORTING
        im_value         TYPE p
        im_currency_code TYPE clike
      EXPORTING
        ex_value         TYPE p
        ex_currency_code TYPE isocd
      RAISING
        cx_gdt_conversion.

    CLASS-METHODS country_code_outbound
      IMPORTING
        im_value TYPE land1
      EXPORTING
        ex_value TYPE csequence
      RAISING
        cx_gdt_conversion.

    CLASS-METHODS date_time_inbound
      IMPORTING
        im_value       TYPE csequence
      EXPORTING
        ex_value_short TYPE timestamp
      RAISING
        cx_gdt_conversion.

    CLASS-METHODS unit_code_inbound
      IMPORTING
        im_value TYPE csequence
      EXPORTING
        ex_value TYPE msehi
      RAISING
        cx_gdt_conversion.

    CLASS-METHODS unit_code_outbound
      IMPORTING
        im_value TYPE msehi
      EXPORTING
        ex_value TYPE csequence
      RAISING
        cx_gdt_conversion.

ENDCLASS.

CLASS cl_gdt_conversion IMPLEMENTATION.

  METHOD amount_outbound.
    CASE im_currency_code.
      WHEN 'DKK' OR 'EUR' OR 'USD'.
        ex_value = im_value.
      WHEN 'VND'.
        ex_value = im_value * 100.
      WHEN OTHERS.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

  METHOD language_code_inbound.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD unit_code_outbound.
    CASE im_value.
      WHEN ''.
        RAISE EXCEPTION TYPE cx_gdt_conversion.
      WHEN 'ST'.
        ex_value = 'PCE'.
      WHEN 'KG'.
        ex_value = 'KGM'.
      WHEN 'CDM'.
        ex_value = 'DMQ'.
      WHEN OTHERS.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

  METHOD country_code_outbound.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD date_time_inbound.
    DATA lv_str TYPE string.

    IF im_value NP '*Z'.
      ASSERT 1 = 'todo, only handles UTC for now'.
    ENDIF.

    lv_str = im_value.
    REPLACE ALL OCCURRENCES OF '-' IN lv_str WITH ''.
    REPLACE ALL OCCURRENCES OF ':' IN lv_str WITH ''.
    REPLACE ALL OCCURRENCES OF 'T' IN lv_str WITH ''.
    REPLACE ALL OCCURRENCES OF 'Z' IN lv_str WITH ''.
    ex_value_short = lv_str.
  ENDMETHOD.

  METHOD unit_code_inbound.

* todo, first look up in database, if there is no database connected, fallback to below

    CASE im_value.
      WHEN 'MTR'.
        ex_value = 'M'.
      WHEN 'PCE'.
        ex_value = 'PC'.
      WHEN 'KGM'.
        ex_value = 'KG'.
      WHEN 'LTR'.
        ex_value = 'L'.
      WHEN OTHERS.
        ASSERT 1 = 'todo'.
    ENDCASE.

  ENDMETHOD.

  METHOD language_code_outbound.

    cl_i18n_languages=>sap1_to_sap2(
      EXPORTING
        im_lang_sap1  = im_value
      RECEIVING
        re_lang_sap2  = ex_value
      EXCEPTIONS
        no_assignment = 1
        OTHERS        = 2 ).
    TRANSLATE ex_value TO LOWER CASE.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_gdt_conversion.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
