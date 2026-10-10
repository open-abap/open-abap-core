INTERFACE if_ftd_output_config_setter PUBLIC.

  METHODS then_answer
    IMPORTING
      answer      TYPE REF TO if_ftd_invocation_answer
    RETURNING
      VALUE(self) TYPE REF TO if_ftd_output_config_setter.

  METHODS then_set_output
    IMPORTING
      output_configuration TYPE REF TO if_ftd_output_configuration
    RETURNING
      VALUE(self)          TYPE REF TO if_ftd_output_config_setter.

  METHODS then_raise_classic_exception
    IMPORTING
      classic_exception TYPE abap_excpname
    RETURNING
      VALUE(self)       TYPE REF TO if_ftd_output_config_setter.

  METHODS then_raise_exception
    IMPORTING
      exception   TYPE REF TO cx_root
    RETURNING
      VALUE(self) TYPE REF TO if_ftd_output_config_setter.

  METHODS for_times
    IMPORTING
      times       TYPE i
    RETURNING
      VALUE(self) TYPE REF TO if_ftd_output_config_setter.

ENDINTERFACE.