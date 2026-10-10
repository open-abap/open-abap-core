"! The parameters of a call or of a configuration, by kind: importing, exporting, changing
"! or tables, from the view of the function module
CLASS lcl_parameters DEFINITION.
  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF gc_kind,
        importing TYPE c LENGTH 1 VALUE 'I',
        exporting TYPE c LENGTH 1 VALUE 'E',
        changing  TYPE c LENGTH 1 VALUE 'C',
        tables    TYPE c LENGTH 1 VALUE 'T',
      END OF gc_kind.

    TYPES: BEGIN OF ty_parameter,
             kind  TYPE c LENGTH 1,
             name  TYPE abap_parmname,
             value TYPE REF TO data,
           END OF ty_parameter.
    TYPES ty_parameters TYPE STANDARD TABLE OF ty_parameter WITH DEFAULT KEY.

    DATA mt_parameters TYPE ty_parameters READ-ONLY.

    CLASS-METHODS copy
      IMPORTING
        iv_value       TYPE any
      RETURNING
        VALUE(rr_copy) TYPE REF TO data.

    "! Keeps a copy of the value, a later value for the same parameter replaces it
    METHODS set
      IMPORTING
        iv_kind  TYPE c
        iv_name  TYPE abap_parmname
        iv_value TYPE any.
ENDCLASS.

CLASS lcl_parameters IMPLEMENTATION.

  METHOD copy.
    FIELD-SYMBOLS <lg_copy> TYPE any.

    CREATE DATA rr_copy LIKE iv_value.
    ASSIGN rr_copy->* TO <lg_copy>.
    <lg_copy> = iv_value.
  ENDMETHOD.

  METHOD set.
    DATA ls_parameter LIKE LINE OF mt_parameters.

    ls_parameter-kind = iv_kind.
    ls_parameter-name = to_upper( iv_name ).
    ls_parameter-value = copy( iv_value ).
    DELETE mt_parameters WHERE kind = ls_parameter-kind AND name = ls_parameter-name.
    APPEND ls_parameter TO mt_parameters.
  ENDMETHOD.

ENDCLASS.

*************************************************************

CLASS lcl_input_arguments DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_input_arguments.

    TYPES: BEGIN OF ty_name_value,
             name  TYPE abap_parmname,
             value TYPE REF TO data,
           END OF ty_name_value.

    DATA mt_importing TYPE STANDARD TABLE OF ty_name_value WITH DEFAULT KEY.
    DATA mt_tables    TYPE STANDARD TABLE OF ty_name_value WITH DEFAULT KEY.
    DATA mt_changing  TYPE STANDARD TABLE OF ty_name_value WITH DEFAULT KEY.
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

  METHOD if_ftd_input_arguments~get_table_parameter.
    DATA ls_row LIKE LINE OF mt_tables.
    READ TABLE mt_tables INTO ls_row WITH KEY name = name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_ftd_parameter_not_found.
    ENDIF.
    result = ls_row-value.
  ENDMETHOD.

  METHOD if_ftd_input_arguments~get_changing_parameter.
    DATA ls_row LIKE LINE OF mt_changing.
    READ TABLE mt_changing INTO ls_row WITH KEY name = name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_ftd_parameter_not_found.
    ENDIF.
    result = ls_row-value.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_output_configuration DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_output_configuration.

    DATA mo_parameters TYPE REF TO lcl_parameters READ-ONLY.

    METHODS constructor.
ENDCLASS.

CLASS lcl_output_configuration IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT mo_parameters.
  ENDMETHOD.

  METHOD if_ftd_output_configuration~set_exporting_parameter.
    mo_parameters->set( iv_kind  = lcl_parameters=>gc_kind-exporting
                        iv_name  = name
                        iv_value = value ).
    self = me.
  ENDMETHOD.

  METHOD if_ftd_output_configuration~set_changing_parameter.
    mo_parameters->set( iv_kind  = lcl_parameters=>gc_kind-changing
                        iv_name  = name
                        iv_value = value ).
    self = me.
  ENDMETHOD.

  METHOD if_ftd_output_configuration~set_table_parameter.
    mo_parameters->set( iv_kind  = lcl_parameters=>gc_kind-tables
                        iv_name  = name
                        iv_value = value ).
    self = me.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_input_configuration DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_input_configuration.

    METHODS constructor.

    "! The parameters set in the configuration have the values of the call, the call may have
    "! more parameters. A parameter the call leaves out is compared as initial value
    METHODS matches
      IMPORTING
        io_call           TYPE REF TO lcl_parameters
      RETURNING
        VALUE(rv_matches) TYPE abap_bool.

  PRIVATE SECTION.
    DATA mo_parameters TYPE REF TO lcl_parameters.
ENDCLASS.

CLASS lcl_input_configuration IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT mo_parameters.
  ENDMETHOD.

  METHOD matches.
    DATA ls_expected LIKE LINE OF mo_parameters->mt_parameters.
    DATA ls_actual   LIKE LINE OF io_call->mt_parameters.

    FIELD-SYMBOLS <lg_expected> TYPE any.
    FIELD-SYMBOLS <lg_actual>   TYPE any.

    LOOP AT mo_parameters->mt_parameters INTO ls_expected.
      ASSIGN ls_expected-value->* TO <lg_expected>.
      READ TABLE io_call->mt_parameters INTO ls_actual
        WITH KEY kind = ls_expected-kind name = ls_expected-name.
      IF sy-subrc <> 0.
        IF <lg_expected> IS NOT INITIAL.
          RETURN.
        ENDIF.
        CONTINUE.
      ENDIF.
      ASSIGN ls_actual-value->* TO <lg_actual>.
      IF <lg_expected> <> <lg_actual>.
        RETURN.
      ENDIF.
    ENDLOOP.

    rv_matches = abap_true.
  ENDMETHOD.

  METHOD if_ftd_input_configuration~set_importing_parameter.
    mo_parameters->set( iv_kind  = lcl_parameters=>gc_kind-importing
                        iv_name  = name
                        iv_value = value ).
    self = me.
  ENDMETHOD.

  METHOD if_ftd_input_configuration~set_changing_parameter.
    mo_parameters->set( iv_kind  = lcl_parameters=>gc_kind-changing
                        iv_name  = name
                        iv_value = value ).
    self = me.
  ENDMETHOD.

  METHOD if_ftd_input_configuration~set_table_parameter.
    mo_parameters->set( iv_kind  = lcl_parameters=>gc_kind-tables
                        iv_name  = name
                        iv_value = value ).
    self = me.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_invocation_result DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_result.

    DATA mo_output TYPE REF TO lcl_output_configuration READ-ONLY.
    DATA mv_classic_exception TYPE abap_excpname READ-ONLY.
    DATA mo_exception TYPE REF TO cx_root READ-ONLY.

    METHODS constructor.
ENDCLASS.

CLASS lcl_invocation_result IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT mo_output.
  ENDMETHOD.

  METHOD if_ftd_invocation_result~get_output_configuration.
    result = mo_output.
  ENDMETHOD.

  METHOD if_ftd_invocation_result~raise_classic_exception.
    mv_classic_exception = to_upper( classic_exception ).
  ENDMETHOD.

  METHOD if_ftd_invocation_result~raise_exception.
    mo_exception = exception.
  ENDMETHOD.
ENDCLASS.

*************************************************************

"! What configure_call( ) configures: the input it applies to and how the double answers
CLASS lcl_configuration DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_input_config_setter.
    INTERFACES if_ftd_output_config_setter.

    DATA mi_answer TYPE REF TO if_ftd_invocation_answer READ-ONLY.
    DATA mo_output TYPE REF TO lcl_output_configuration READ-ONLY.
    DATA mv_classic_exception TYPE abap_excpname READ-ONLY.
    DATA mo_exception TYPE REF TO cx_root READ-ONLY.

    METHODS applies_to
      IMPORTING
        io_call           TYPE REF TO lcl_parameters
      RETURNING
        VALUE(rv_applies) TYPE abap_bool.

    "! for_times( ) limits the calls a configuration answers, without it there is no limit
    METHODS has_calls_left
      RETURNING
        VALUE(rv_left) TYPE abap_bool.

    METHODS count_call.

  PRIVATE SECTION.
    DATA mv_ignore_all TYPE abap_bool.
    DATA mo_input TYPE REF TO lcl_input_configuration.
    DATA mv_answered TYPE abap_bool.
    DATA mv_times TYPE i.
    DATA mv_calls TYPE i.

    "! A configuration answers with one of then_answer( ), then_set_output( ),
    "! then_raise_classic_exception( ) or then_raise_exception( ), the last one counts
    METHODS replace_answer.
ENDCLASS.

CLASS lcl_configuration IMPLEMENTATION.
  METHOD applies_to.
    IF mv_answered = abap_false.
      " configure_call( ) without then_..( ) yet
      rv_applies = abap_false.
    ELSEIF mv_ignore_all = abap_true.
      rv_applies = abap_true.
    ELSEIF mo_input IS BOUND.
      rv_applies = mo_input->matches( io_call ).
    ENDIF.
  ENDMETHOD.

  METHOD has_calls_left.
    rv_left = boolc( mv_times = 0 OR mv_calls < mv_times ).
  ENDMETHOD.

  METHOD count_call.
    mv_calls = mv_calls + 1.
  ENDMETHOD.

  METHOD replace_answer.
    CLEAR mi_answer.
    CLEAR mo_output.
    CLEAR mv_classic_exception.
    CLEAR mo_exception.
    mv_answered = abap_true.
  ENDMETHOD.

  METHOD if_ftd_input_config_setter~when.
    mo_input ?= input_configuration.
    output_configuration_setter = me.
  ENDMETHOD.

  METHOD if_ftd_input_config_setter~ignore_all_parameters.
    mv_ignore_all = abap_true.
    output_configuration_setter = me.
  ENDMETHOD.

  METHOD if_ftd_output_config_setter~then_answer.
    replace_answer( ).
    mi_answer = answer.
    self = me.
  ENDMETHOD.

  METHOD if_ftd_output_config_setter~then_set_output.
    replace_answer( ).
    mo_output ?= output_configuration.
    self = me.
  ENDMETHOD.

  METHOD if_ftd_output_config_setter~then_raise_classic_exception.
    replace_answer( ).
    mv_classic_exception = to_upper( classic_exception ).
    self = me.
  ENDMETHOD.

  METHOD if_ftd_output_config_setter~then_raise_exception.
    replace_answer( ).
    mo_exception = exception.
    self = me.
  ENDMETHOD.

  METHOD if_ftd_output_config_setter~for_times.
    mv_times = times.
    self = me.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_behavior_verification DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_behavior_verification.

    METHODS constructor
      IMPORTING
        iv_name       TYPE sxco_fm_name
        iv_calls      TYPE i
        iv_with_input TYPE abap_bool.

  PRIVATE SECTION.
    DATA mv_name TYPE sxco_fm_name.
    DATA mv_calls TYPE i.
    DATA mv_with_input TYPE abap_bool.

    METHODS check
      IMPORTING
        iv_ok       TYPE abap_bool
        iv_expected TYPE string.
ENDCLASS.

CLASS lcl_behavior_verification IMPLEMENTATION.
  METHOD constructor.
    mv_name = iv_name.
    mv_calls = iv_calls.
    mv_with_input = iv_with_input.
  ENDMETHOD.

  METHOD check.
    DATA lv_message TYPE string.

    IF iv_ok = abap_true.
      RETURN.
    ENDIF.
    lv_message = |{ mv_name } is called { mv_calls } times|.
    IF mv_with_input = abap_true.
      lv_message = |{ lv_message } with the input configuration|.
    ENDIF.
    cl_abap_unit_assert=>fail( msg = |{ lv_message }, expected { iv_expected }| ).
  ENDMETHOD.

  METHOD if_ftd_behavior_verification~is_called_times.
    check( iv_ok       = boolc( mv_calls = times )
           iv_expected = |{ times }| ).
  ENDMETHOD.

  METHOD if_ftd_behavior_verification~is_called_once.
    if_ftd_behavior_verification~is_called_times( 1 ).
  ENDMETHOD.

  METHOD if_ftd_behavior_verification~is_never_called.
    if_ftd_behavior_verification~is_called_times( 0 ).
  ENDMETHOD.

  METHOD if_ftd_behavior_verification~is_called_at_least.
    check( iv_ok       = boolc( mv_calls >= times )
           iv_expected = |at least { times }| ).
  ENDMETHOD.

  METHOD if_ftd_behavior_verification~is_called_at_least_once.
    if_ftd_behavior_verification~is_called_at_least( 1 ).
  ENDMETHOD.

  METHOD if_ftd_behavior_verification~is_called_at_most.
    check( iv_ok       = boolc( mv_calls <= times )
           iv_expected = |at most { times }| ).
  ENDMETHOD.

  METHOD if_ftd_behavior_verification~is_called_at_most_once.
    if_ftd_behavior_verification~is_called_at_most( 1 ).
  ENDMETHOD.
ENDCLASS.

*************************************************************

"! The double of one function module: its configurations and the calls it received
CLASS lcl_double DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_function_testdouble.

    METHODS constructor
      IMPORTING
        iv_name TYPE sxco_fm_name.

    "! Called instead of the function module, fminput holds the parameters of CALL FUNCTION:
    "! exporting, importing, tables and changing, from the view of the caller
    METHODS invoke
      IMPORTING
        fminput TYPE any
      RAISING
        cx_static_check.

  PRIVATE SECTION.
    DATA mv_name TYPE sxco_fm_name.
    DATA mt_configurations TYPE STANDARD TABLE OF REF TO lcl_configuration WITH DEFAULT KEY.
    DATA mt_calls TYPE STANDARD TABLE OF REF TO lcl_parameters WITH DEFAULT KEY.

    METHODS record
      IMPORTING
        fminput        TYPE any
      RETURNING
        VALUE(ro_call) TYPE REF TO lcl_parameters.

    METHODS answer
      IMPORTING
        fminput          TYPE any
        ii_answer        TYPE REF TO if_ftd_invocation_answer
      RETURNING
        VALUE(ro_result) TYPE REF TO lcl_invocation_result.

    "! An exception goes to the caller, otherwise the output is written
    METHODS respond
      IMPORTING
        fminput              TYPE any
        io_output            TYPE REF TO lcl_output_configuration
        iv_classic_exception TYPE abap_excpname
        io_exception         TYPE REF TO cx_root
      RAISING
        cx_static_check.

    METHODS write_output
      IMPORTING
        fminput   TYPE any
        io_output TYPE REF TO lcl_output_configuration.
ENDCLASS.

CLASS lcl_double IMPLEMENTATION.
  METHOD constructor.
    ASSERT iv_name IS NOT INITIAL.
    mv_name = iv_name.
  ENDMETHOD.

  METHOD if_function_testdouble~clear.
    CLEAR mt_configurations.
    CLEAR mt_calls.
  ENDMETHOD.

  METHOD invoke.
    DATA lo_call          TYPE REF TO lcl_parameters.
    DATA lo_configuration TYPE REF TO lcl_configuration.
    DATA lo_candidate     TYPE REF TO lcl_configuration.
    DATA lo_result        TYPE REF TO lcl_invocation_result.
    DATA lo_no_output     TYPE REF TO lcl_output_configuration.
    DATA lv_index         TYPE i.

    lo_call = record( fminput ).
    APPEND lo_call TO mt_calls.

    " the latest configuration that applies answers. When for_times( ) used it up, or none
    " applies, the call only returns its exporting parameters initial, as in SAP
    lv_index = lines( mt_configurations ).
    WHILE lv_index > 0.
      READ TABLE mt_configurations INDEX lv_index INTO lo_candidate.
      IF lo_candidate->applies_to( lo_call ) = abap_true.
        lo_configuration = lo_candidate.
        EXIT.
      ENDIF.
      lv_index = lv_index - 1.
    ENDWHILE.
    IF lo_configuration IS NOT BOUND OR lo_configuration->has_calls_left( ) = abap_false.
      write_output( fminput   = fminput
                    io_output = lo_no_output ).
      RETURN.
    ENDIF.
    lo_configuration->count_call( ).

    IF lo_configuration->mi_answer IS BOUND.
      lo_result = answer( fminput   = fminput
                          ii_answer = lo_configuration->mi_answer ).
      respond( fminput              = fminput
               io_output            = lo_result->mo_output
               iv_classic_exception = lo_result->mv_classic_exception
               io_exception         = lo_result->mo_exception ).
    ELSE.
      respond( fminput              = fminput
               io_output            = lo_configuration->mo_output
               iv_classic_exception = lo_configuration->mv_classic_exception
               io_exception         = lo_configuration->mo_exception ).
    ENDIF.
  ENDMETHOD.

  METHOD respond.
    DATA lv_exception TYPE abap_excpname.

    IF io_exception IS BOUND.
      RAISE EXCEPTION io_exception.
    ELSEIF iv_classic_exception IS NOT INITIAL.
      " CALL FUNCTION .. EXCEPTIONS turns this into the sy-subrc of the exception
      lv_exception = iv_classic_exception.
      WRITE '@KERNEL throw new abap.ClassicError({classic: lv_exception.get().trimEnd()});'.
    ENDIF.

    write_output( fminput   = fminput
                  io_output = io_output ).
  ENDMETHOD.

  METHOD record.
    DATA ls_parameter LIKE LINE OF ro_call->mt_parameters.
    DATA lr_actual    TYPE REF TO data.

    FIELD-SYMBOLS <lg_actual> TYPE any.

    " copies, the variables of the caller change after the call
    CREATE OBJECT ro_call.
    WRITE '@KERNEL const kinds = {exporting: "I", changing: "C", tables: "T"};'.
    WRITE '@KERNEL for (const [group, kind] of Object.entries(kinds)) {'.
    WRITE '@KERNEL   for (const [name, actual] of Object.entries(fminput?.[group] ?? {})) {'.
    WRITE '@KERNEL     if (actual === undefined) { continue; }'.
    CLEAR ls_parameter.
    WRITE '@KERNEL     ls_parameter.get().kind.set(kind);'.
    WRITE '@KERNEL     ls_parameter.get().name.set(name.toUpperCase());'.
    WRITE '@KERNEL     lr_actual.assign(actual instanceof abap.types.FieldSymbol ? actual.getPointer() : actual);'.
    ASSIGN lr_actual->* TO <lg_actual>.
    ro_call->set( iv_kind  = ls_parameter-kind
                  iv_name  = ls_parameter-name
                  iv_value = <lg_actual> ).
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD answer.
    DATA lo_result    TYPE REF TO lcl_invocation_result.
    DATA li_result    TYPE REF TO if_ftd_invocation_result.
    DATA lo_arguments TYPE REF TO lcl_input_arguments.
    DATA li_arguments TYPE REF TO if_ftd_input_arguments.
    DATA ls_importing LIKE LINE OF lo_arguments->mt_importing.
    DATA ls_table     LIKE LINE OF lo_arguments->mt_tables.
    DATA ls_changing  LIKE LINE OF lo_arguments->mt_changing.

    CREATE OBJECT lo_result.
    li_result = lo_result.

    CREATE OBJECT lo_arguments.
    li_arguments = lo_arguments.

    WRITE '@KERNEL for (const importing in fminput?.exporting || []) {'.
    WRITE '@KERNEL   ls_importing.get().name.set(importing.toUpperCase());'.
    WRITE '@KERNEL   ls_importing.get().value.pointer = fminput.exporting[importing];'.
    INSERT ls_importing INTO TABLE lo_arguments->mt_importing.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL for (const table in fminput?.tables || []) {'.
    WRITE '@KERNEL   ls_table.get().name.set(table.toUpperCase());'.
    WRITE '@KERNEL   ls_table.get().value.pointer = fminput.tables[table];'.
    INSERT ls_table INTO TABLE lo_arguments->mt_tables.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL for (const changing in fminput?.changing || []) {'.
    WRITE '@KERNEL   ls_changing.get().name.set(changing.toUpperCase());'.
    WRITE '@KERNEL   ls_changing.get().value.pointer = fminput.changing[changing];'.
    INSERT ls_changing INTO TABLE lo_arguments->mt_changing.
    WRITE '@KERNEL }'.

    ii_answer->answer(
      EXPORTING
        arguments = li_arguments
      CHANGING
        result    = li_result ).

    ro_result = lo_result.
  ENDMETHOD.

  METHOD write_output.
    DATA ls_parameter LIKE LINE OF io_output->mo_parameters->mt_parameters.

    " as in SAP, the exporting parameters start initial: what the double does not set reaches
    " the caller as initial value. Changing and tables parameters keep the values of the caller
    WRITE '@KERNEL for (const target of Object.values(fminput?.importing ?? {})) { target?.clear?.(); }'.

    IF io_output IS NOT BOUND.
      RETURN.
    ENDIF.

    " a parameter the caller does not pass is not written, as in SAP
    LOOP AT io_output->mo_parameters->mt_parameters INTO ls_parameter.
      WRITE '@KERNEL const group = {E: "importing", C: "changing", T: "tables"}[ls_parameter.get().kind.get()];'.
      WRITE '@KERNEL const target = fminput?.[group]?.[ls_parameter.get().name.get().trimEnd().toLowerCase()];'.
      WRITE '@KERNEL if (target !== undefined) { target.set(ls_parameter.get().value.getPointer()); }'.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_function_testdouble~configure_call.
    DATA lo_configuration TYPE REF TO lcl_configuration.

    CREATE OBJECT lo_configuration.
    APPEND lo_configuration TO mt_configurations.
    input_configuration_setter = lo_configuration.
  ENDMETHOD.

  METHOD if_function_testdouble~create_input_configuration.
    CREATE OBJECT result TYPE lcl_input_configuration.
  ENDMETHOD.

  METHOD if_function_testdouble~create_output_configuration.
    CREATE OBJECT result TYPE lcl_output_configuration.
  ENDMETHOD.

  METHOD if_function_testdouble~verify.
    DATA lo_input TYPE REF TO lcl_input_configuration.
    DATA lo_call  TYPE REF TO lcl_parameters.
    DATA lv_calls TYPE i.

    IF input_configuration IS BOUND.
      lo_input ?= input_configuration.
    ENDIF.
    LOOP AT mt_calls INTO lo_call.
      IF lo_input IS NOT BOUND OR lo_input->matches( lo_call ) = abap_true.
        lv_calls = lv_calls + 1.
      ENDIF.
    ENDLOOP.

    CREATE OBJECT behavior_verification TYPE lcl_behavior_verification
      EXPORTING
        iv_name       = mv_name
        iv_calls      = lv_calls
        iv_with_input = boolc( lo_input IS BOUND ).
  ENDMETHOD.
ENDCLASS.