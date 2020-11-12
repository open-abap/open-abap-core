CLASS cl_gdt_conversion DEFINITION PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS language_code_outbound
      IMPORTING
        im_value TYPE spras
      EXPORTING
        ex_value TYPE laiso.

ENDCLASS.

CLASS cl_gdt_conversion IMPLEMENTATION.

  METHOD language_code_outbound.

    CASE im_value.
      WHEN 'E'.
        ex_value = 'en'.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.