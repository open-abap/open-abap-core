INTERFACE if_abap_testdouble_config PUBLIC.

  METHODS returning
    IMPORTING
      value                TYPE any
    RETURNING
      VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

  METHODS set_parameter
    IMPORTING
      name                 TYPE abap_parmname
      value                TYPE any
    RETURNING
      VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

  METHODS raise_exception
    IMPORTING
      exception_object     TYPE REF TO cx_root
    RETURNING
      VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

  METHODS raise_event
    IMPORTING
      name                 TYPE abap_evntname
      parameters           TYPE abap_parmbind_tab OPTIONAL
    RETURNING
      VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

  METHODS times
    IMPORTING
      number               TYPE i
    RETURNING
      VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

  METHODS ignore_parameter
    IMPORTING
      name                 TYPE abap_parmname
    RETURNING
      VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

  METHODS ignore_all_parameters
    RETURNING
      VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

  METHODS and_expect
    RETURNING
      VALUE(verification) TYPE REF TO if_abap_testdouble_verify.

  METHODS set_answer
    IMPORTING
      answer TYPE REF TO if_abap_testdouble_answer.

  METHODS set_matcher
    IMPORTING
      matcher              TYPE REF TO if_abap_testdouble_matcher
    RETURNING
      VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

ENDINTERFACE.
