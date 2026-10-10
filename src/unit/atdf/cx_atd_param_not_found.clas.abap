CLASS cx_atd_param_not_found DEFINITION PUBLIC INHERITING FROM cx_dynamic_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    DATA parameter_name TYPE abap_parmname.

    METHODS constructor
      IMPORTING
        previous   LIKE previous OPTIONAL
        param_name TYPE abap_parmname OPTIONAL.

    METHODS if_message~get_text REDEFINITION.

ENDCLASS.

CLASS cx_atd_param_not_found IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    parameter_name = param_name.
  ENDMETHOD.

  METHOD if_message~get_text.
    result = |Parameter { parameter_name } not found|.
  ENDMETHOD.

ENDCLASS.
