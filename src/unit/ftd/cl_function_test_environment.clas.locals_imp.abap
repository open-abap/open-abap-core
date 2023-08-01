CLASS lcl_input_arguments DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_input_arguments.

    TYPES: BEGIN OF ty_name_value,
             name  TYPE abap_parmname,
             value TYPE REF TO data,
           END OF ty_name_value.

    DATA mt_importing TYPE STANDARD TABLE OF ty_name_value WITH DEFAULT KEY.
ENDCLASS.

CLASS lcl_input_arguments IMPLEMENTATION.
  METHOD if_ftd_input_arguments~get_importing_parameter.
    DATA ls_row LIKE LINE OF mt_importing.
    READ TABLE mt_importing INTO ls_row WITH KEY name = name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_ftd_parameter_not_found.
    ENDIF.
    result = ls_row-value.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_invocation_result DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_result.
    INTERFACES if_ftd_output_configuration.

    TYPES: BEGIN OF ty_name_value,
             name  TYPE abap_parmname,
             value TYPE REF TO data,
           END OF ty_name_value.

    DATA mt_exporting TYPE STANDARD TABLE OF ty_name_value WITH DEFAULT KEY.
ENDCLASS.

CLASS lcl_invocation_result IMPLEMENTATION.
  METHOD if_ftd_invocation_result~get_output_configuration.
    result = me.
  ENDMETHOD.

  METHOD if_ftd_output_configuration~set_exporting_parameter.
    DATA ls_row LIKE LINE OF mt_exporting.

    ls_row-name = name.
* note: in javascript the referenced data will not be deallocated,
* todo: actually want to copy the data,
    GET REFERENCE OF value INTO ls_row-value.
    INSERT ls_row INTO TABLE mt_exporting.

    self = me.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_invoker DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS invoke
      IMPORTING
        fminput TYPE any
        answer  TYPE REF TO if_ftd_invocation_answer.
ENDCLASS.

CLASS lcl_invoker IMPLEMENTATION.
  METHOD invoke.
    DATA lo_result    TYPE REF TO lcl_invocation_result.
    DATA li_result    TYPE REF TO if_ftd_invocation_result.
    DATA lo_arguments TYPE REF TO lcl_input_arguments.
    DATA li_arguments TYPE REF TO if_ftd_input_arguments.
    DATA ls_exporting LIKE LINE OF lo_result->mt_exporting.
    DATA ls_importing LIKE LINE OF lo_arguments->mt_importing.

    CREATE OBJECT lo_result.
    li_result = lo_result.

    CREATE OBJECT lo_arguments.
    li_arguments = lo_arguments.

* todo, set arguments
    WRITE '@KERNEL for (const importing in fminput.exporting) {'.
*    WRITE '@KERNEL   console.dir(importing);'.
    WRITE '@KERNEL   ls_importing.get().name.set(importing.toUpperCase());'.
*    WRITE '@KERNEL   console.dir(ls_importing.get().value);'.
    WRITE '@KERNEL   ls_importing.get().value.pointer = fminput.exporting[importing];'.
    INSERT ls_importing INTO TABLE lo_arguments->mt_importing.
    WRITE '@KERNEL }'.

    answer->answer(
      EXPORTING
        arguments = li_arguments
      CHANGING
        result    = li_result ).

    LOOP AT lo_result->mt_exporting INTO ls_exporting.
      WRITE '@KERNEL fminput.importing[ls_exporting.get().name.get().toLowerCase().trimEnd()].set(ls_exporting.get().value.dereference());'.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_double DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_function_testdouble.
    INTERFACES if_ftd_input_config_setter.
    INTERFACES if_ftd_output_config_setter.

    METHODS constructor IMPORTING iv_name TYPE sxco_fm_name.
  PRIVATE SECTION.
    DATA mv_name TYPE sxco_fm_name.
ENDCLASS.

CLASS lcl_double IMPLEMENTATION.
  METHOD constructor.
    ASSERT iv_name IS NOT INITIAL.
    mv_name = iv_name.
  ENDMETHOD.

  METHOD if_function_testdouble~configure_call.
    input_configuration_setter = me.
  ENDMETHOD.

  METHOD if_ftd_input_config_setter~ignore_all_parameters.
    output_configuration_setter = me.
  ENDMETHOD.

  METHOD if_ftd_output_config_setter~then_answer.
    WRITE '@KERNEL abap.FunctionModules[this.mv_name.get().trimEnd()] = (INPUT) => lcl_invoker.invoke({fminput: INPUT, answer});'.
  ENDMETHOD.
ENDCLASS.