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
        im_currency_code TYPE string
      EXPORTING
        ex_value         TYPE p
      RAISING
        cx_gdt_conversion.

    CLASS-METHODS country_code_outbound
      IMPORTING
        im_value TYPE string
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
        ex_value TYPE csequence
      RAISING
        cx_gdt_conversion.

    CLASS-METHODS unit_code_outbound
      IMPORTING
        im_value TYPE csequence
      EXPORTING
        ex_value TYPE csequence
      RAISING
        cx_gdt_conversion.

ENDCLASS.

CLASS cl_gdt_conversion IMPLEMENTATION.

  METHOD amount_outbound.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD language_code_inbound.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD unit_code_outbound.
    ASSERT 1 = 'todo'.
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

* todo, first look up in database, if there is no database connected, fallback to below

    CASE im_value.
      WHEN 'E'.
        ex_value = 'en'.
      WHEN 'K'.
        ex_value = 'da'.
      WHEN 'D'.
        ex_value = 'de'.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.