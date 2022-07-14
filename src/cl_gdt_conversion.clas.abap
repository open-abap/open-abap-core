CLASS cl_gdt_conversion DEFINITION PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS language_code_outbound
      IMPORTING
        im_value TYPE spras
      EXPORTING
        ex_value TYPE laiso.

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
        ex_value TYPE string
      RAISING
        cx_gdt_conversion.

ENDCLASS.

CLASS cl_gdt_conversion IMPLEMENTATION.

  METHOD amount_outbound.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD country_code_outbound.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD date_time_inbound.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD unit_code_inbound.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD language_code_outbound.
    CASE im_value.
      WHEN 'E'.
        ex_value = 'en'.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.