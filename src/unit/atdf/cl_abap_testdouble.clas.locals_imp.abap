CLASS lcl_configuration DEFINITION DEFERRED.

*************************************************************

"! The parameters of one call of a double. Importing parameters hold a copy of the actual
"! parameter converted to the type of the formal parameter, exporting, changing and returning
"! parameters reference the variables of the caller.
CLASS lcl_arguments DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_testdouble_arguments.

    TYPES: BEGIN OF ty_parameter,
             name     TYPE abap_parmname,
             kind     TYPE abap_parmkind,
             supplied TYPE abap_bool,
             ignored  TYPE abap_bool,
             value    TYPE REF TO data,
           END OF ty_parameter.
    TYPES ty_parameters TYPE STANDARD TABLE OF ty_parameter WITH DEFAULT KEY.

    DATA mt_parameters TYPE ty_parameters READ-ONLY.

    CLASS-METHODS copy
      IMPORTING
        iv_value       TYPE any
      RETURNING
        VALUE(rr_copy) TYPE REF TO data.

    METHODS constructor
      IMPORTING
        it_parameters TYPE ty_parameters.

  PRIVATE SECTION.
    DATA mv_position TYPE i.

    METHODS read
      IMPORTING
        iv_name             TYPE abap_parmname
        iv_kind             TYPE abap_parmkind
      RETURNING
        VALUE(rs_parameter) TYPE ty_parameter
      RAISING
        cx_atd_param_not_found.

    METHODS next_position
      RETURNING
        VALUE(rv_position) TYPE i.
ENDCLASS.

CLASS lcl_arguments IMPLEMENTATION.

  METHOD copy.
    FIELD-SYMBOLS <lg_copy> TYPE any.

    CREATE DATA rr_copy LIKE iv_value.
    ASSIGN rr_copy->* TO <lg_copy>.
    <lg_copy> = iv_value.
  ENDMETHOD.

  METHOD constructor.
    mt_parameters = it_parameters.
  ENDMETHOD.

  METHOD read.
    DATA lv_name TYPE abap_parmname.

    lv_name = to_upper( iv_name ).
    READ TABLE mt_parameters INTO rs_parameter WITH KEY name = lv_name kind = iv_kind.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_atd_param_not_found
        EXPORTING
          param_name = lv_name.
    ENDIF.
  ENDMETHOD.

  METHOD next_position.
    " the position of the next importing or changing parameter after mv_position, 0 if there is none
    DATA ls_parameter LIKE LINE OF mt_parameters.

    LOOP AT mt_parameters INTO ls_parameter FROM mv_position + 1.
      IF ls_parameter-kind = cl_abap_objectdescr=>importing OR ls_parameter-kind = cl_abap_objectdescr=>changing.
        rv_position = sy-tabix.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_abap_testdouble_arguments~get_param_importing.
    value = read( iv_name = name
                  iv_kind = cl_abap_objectdescr=>importing )-value.
  ENDMETHOD.

  METHOD if_abap_testdouble_arguments~is_importing_param_supplied.
    result = read( iv_name = name
                   iv_kind = cl_abap_objectdescr=>importing )-supplied.
  ENDMETHOD.

  METHOD if_abap_testdouble_arguments~get_param_changing.
    value = read( iv_name = name
                  iv_kind = cl_abap_objectdescr=>changing )-value.
  ENDMETHOD.

  METHOD if_abap_testdouble_arguments~is_changing_param_supplied.
    result = read( iv_name = name
                   iv_kind = cl_abap_objectdescr=>changing )-supplied.
  ENDMETHOD.

  METHOD if_abap_testdouble_arguments~next_parameter.
    DATA ls_parameter LIKE LINE OF mt_parameters.
    DATA lv_position  TYPE i.

    lv_position = next_position( ).
    IF lv_position = 0.
      RAISE EXCEPTION TYPE cx_atd_exception_core.
    ENDIF.
    mv_position = lv_position.
    READ TABLE mt_parameters INTO ls_parameter INDEX mv_position.
    name = ls_parameter-name.
    kind = ls_parameter-kind.
    ignore = ls_parameter-ignored.
  ENDMETHOD.

  METHOD if_abap_testdouble_arguments~has_next_parameter.
    result = boolc( next_position( ) > 0 ).
  ENDMETHOD.

  METHOD if_abap_testdouble_arguments~reset_iterator.
    mv_position = 0.
  ENDMETHOD.

  METHOD if_abap_testdouble_arguments~size_of.
    DATA ls_parameter LIKE LINE OF mt_parameters.

    LOOP AT mt_parameters INTO ls_parameter.
      IF ls_parameter-kind = cl_abap_objectdescr=>importing OR ls_parameter-kind = cl_abap_objectdescr=>changing.
        size = size + 1.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

*************************************************************

"! Shared by the classes of the framework
CLASS lcl_error DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS raise
      IMPORTING
        iv_text           TYPE string
        iv_object_name    TYPE abap_intfname OPTIONAL
        iv_method_name    TYPE abap_methname OPTIONAL
        iv_parameter_name TYPE abap_parmname OPTIONAL
        iv_expected       TYPE i OPTIONAL
        iv_actual         TYPE i OPTIONAL
      RAISING
        cx_atd_exception_core.
ENDCLASS.

CLASS lcl_error IMPLEMENTATION.

  METHOD raise.
    DATA lx_error TYPE REF TO cx_atd_exception_core.

    CREATE OBJECT lx_error
      EXPORTING
        object_name    = iv_object_name
        method_name    = iv_method_name
        parameter_name = iv_parameter_name
        expected       = iv_expected
        actual         = iv_actual.
    lx_error->message_prefix = iv_text.
    RAISE EXCEPTION lx_error.
  ENDMETHOD.

ENDCLASS.

*************************************************************

"! Writes the output of a call into the variables of the caller
CLASS lcl_result DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_testdouble_result.

    DATA mo_exception TYPE REF TO cx_root READ-ONLY.

    METHODS constructor
      IMPORTING
        it_parameters TYPE lcl_arguments=>ty_parameters.

  PRIVATE SECTION.
    DATA mt_parameters TYPE lcl_arguments=>ty_parameters.

    METHODS write
      IMPORTING
        iv_name  TYPE abap_parmname
        iv_kind  TYPE abap_parmkind
        iv_value TYPE any
      RAISING
        cx_atd_exception_core.
ENDCLASS.

CLASS lcl_result IMPLEMENTATION.

  METHOD constructor.
    mt_parameters = it_parameters.
  ENDMETHOD.

  METHOD write.
    DATA ls_parameter LIKE LINE OF mt_parameters.
    DATA lv_name      TYPE abap_parmname.

    FIELD-SYMBOLS <lg_target> TYPE any.

    lv_name = to_upper( iv_name ).
    READ TABLE mt_parameters INTO ls_parameter WITH KEY name = lv_name kind = iv_kind.
    IF sy-subrc <> 0.
      lcl_error=>raise(
        iv_text           = |{ lv_name } is not a parameter of kind { iv_kind } of the method|
        iv_parameter_name = lv_name ).
    ENDIF.
    ASSIGN ls_parameter-value->* TO <lg_target>.
    <lg_target> = iv_value.
  ENDMETHOD.

  METHOD if_abap_testdouble_result~set_param_exporting.
    write( iv_name  = name
           iv_kind  = cl_abap_objectdescr=>exporting
           iv_value = value ).
  ENDMETHOD.

  METHOD if_abap_testdouble_result~set_param_changing.
    write( iv_name  = name
           iv_kind  = cl_abap_objectdescr=>changing
           iv_value = value ).
  ENDMETHOD.

  METHOD if_abap_testdouble_result~set_param_returning.
    DATA ls_parameter LIKE LINE OF mt_parameters.

    READ TABLE mt_parameters INTO ls_parameter WITH KEY kind = cl_abap_objectdescr=>returning.
    IF sy-subrc <> 0.
      lcl_error=>raise( 'The method has no returning parameter' ).
    ENDIF.
    write( iv_name  = ls_parameter-name
           iv_kind  = cl_abap_objectdescr=>returning
           iv_value = value ).
  ENDMETHOD.

  METHOD if_abap_testdouble_result~raise_exception.
    mo_exception = exception.
  ENDMETHOD.

ENDCLASS.

*************************************************************

CLASS lcl_handle DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_testdouble_handle.
ENDCLASS.

CLASS lcl_handle IMPLEMENTATION.

  METHOD if_abap_testdouble_handle~raise_event.
    lcl_error=>raise( 'raise_event is not supported by open-abap' ).
  ENDMETHOD.

ENDCLASS.

*************************************************************

CLASS lcl_verification DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_testdouble_verify.

    METHODS constructor
      IMPORTING
        io_configuration TYPE REF TO lcl_configuration.

  PRIVATE SECTION.
    DATA mo_configuration TYPE REF TO lcl_configuration.
ENDCLASS.

*************************************************************

"! One configuration of a double: configure_call( ) creates it, the next call of a method
"! of the double registers it for that method and its arguments
CLASS lcl_configuration DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_testdouble_config.

    DATA mv_method_name TYPE abap_methname READ-ONLY.
    DATA mv_calls TYPE i READ-ONLY.
    DATA mv_has_expectation TYPE abap_bool READ-ONLY.
    DATA mv_expected TYPE i READ-ONLY.

    METHODS constructor.

    METHODS expect
      IMPORTING
        iv_times TYPE i.

    METHODS register
      IMPORTING
        iv_method_name TYPE abap_methname
        it_parameters  TYPE lcl_arguments=>ty_parameters
      RAISING
        cx_atd_exception_core.

    METHODS applies_to
      IMPORTING
        iv_method_name    TYPE abap_methname
        io_arguments      TYPE REF TO lcl_arguments
      RETURNING
        VALUE(rv_applies) TYPE abap_bool
      RAISING
        cx_atd_exception_core.

    METHODS has_calls_left
      RETURNING
        VALUE(rv_left) TYPE abap_bool.

    METHODS answer
      IMPORTING
        iv_method_name TYPE abap_methname
        io_arguments   TYPE REF TO lcl_arguments
        it_parameters  TYPE lcl_arguments=>ty_parameters
        ii_handle      TYPE REF TO if_abap_testdouble_handle
      RAISING
        cx_static_check.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_output,
             name  TYPE abap_parmname,
             kind  TYPE abap_parmkind,
             value TYPE REF TO data,
           END OF ty_output.

    DATA mv_times TYPE i.
    DATA mv_ignore_all TYPE abap_bool.
    DATA mt_ignored TYPE STANDARD TABLE OF abap_parmname WITH DEFAULT KEY.
    DATA mt_outputs TYPE STANDARD TABLE OF ty_output WITH DEFAULT KEY.
    DATA mr_returning TYPE REF TO data.
    DATA mo_exception TYPE REF TO cx_root.
    DATA mi_answer TYPE REF TO if_abap_testdouble_answer.
    DATA mi_matcher TYPE REF TO if_abap_testdouble_matcher.
    DATA mo_configured TYPE REF TO lcl_arguments.

    METHODS is_same
      IMPORTING
        is_configured  TYPE lcl_arguments=>ty_parameter
        is_actual      TYPE lcl_arguments=>ty_parameter
      RETURNING
        VALUE(rv_same) TYPE abap_bool.
ENDCLASS.

CLASS lcl_configuration IMPLEMENTATION.

  METHOD constructor.
    mv_times = 1.
  ENDMETHOD.

  METHOD expect.
    mv_has_expectation = abap_true.
    mv_expected = iv_times.
  ENDMETHOD.

  METHOD register.
    DATA ls_parameter LIKE LINE OF it_parameters.
    DATA ls_argument  LIKE LINE OF it_parameters.
    DATA lt_arguments TYPE lcl_arguments=>ty_parameters.
    DATA lv_ignored   TYPE abap_parmname.

    FIELD-SYMBOLS <ls_output> LIKE LINE OF mt_outputs.
    FIELD-SYMBOLS <lg_value>  TYPE any.

    mv_method_name = iv_method_name.

    LOOP AT it_parameters INTO ls_parameter.
      IF ls_parameter-kind <> cl_abap_objectdescr=>importing AND ls_parameter-kind <> cl_abap_objectdescr=>changing.
        CONTINUE.
      ENDIF.
      " the arguments of the registration call are kept, the variables of the caller change later
      ls_argument = ls_parameter.
      ASSIGN ls_parameter-value->* TO <lg_value>.
      ls_argument-value = lcl_arguments=>copy( <lg_value> ).
      READ TABLE mt_ignored WITH KEY table_line = ls_parameter-name TRANSPORTING NO FIELDS.
      IF mv_ignore_all = abap_true OR sy-subrc = 0.
        ls_argument-ignored = abap_true.
      ENDIF.
      APPEND ls_argument TO lt_arguments.
    ENDLOOP.
    CREATE OBJECT mo_configured
      EXPORTING
        it_parameters = lt_arguments.

    LOOP AT mt_ignored INTO lv_ignored.
      READ TABLE lt_arguments WITH KEY name = lv_ignored TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        lcl_error=>raise(
          iv_text           = |{ lv_ignored } is not an importing or changing parameter of { iv_method_name }|
          iv_method_name    = iv_method_name
          iv_parameter_name = lv_ignored ).
      ENDIF.
    ENDLOOP.

    LOOP AT mt_outputs ASSIGNING <ls_output>.
      READ TABLE it_parameters INTO ls_parameter WITH KEY name = <ls_output>-name.
      IF sy-subrc <> 0
          OR ( ls_parameter-kind <> cl_abap_objectdescr=>exporting
          AND ls_parameter-kind <> cl_abap_objectdescr=>changing ).
        lcl_error=>raise(
          iv_text           = |{ <ls_output>-name } is not an exporting or changing parameter of { iv_method_name }|
          iv_method_name    = iv_method_name
          iv_parameter_name = <ls_output>-name ).
      ENDIF.
      <ls_output>-kind = ls_parameter-kind.
    ENDLOOP.

    IF mr_returning IS BOUND.
      READ TABLE it_parameters WITH KEY kind = cl_abap_objectdescr=>returning TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        lcl_error=>raise(
          iv_text        = |{ iv_method_name } has no returning parameter|
          iv_method_name = iv_method_name ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD applies_to.
    DATA ls_configured LIKE LINE OF mo_configured->mt_parameters.
    DATA ls_actual     LIKE LINE OF io_arguments->mt_parameters.

    IF iv_method_name <> mv_method_name.
      rv_applies = abap_false.
      RETURN.
    ENDIF.

    IF mi_matcher IS BOUND.
      rv_applies = mi_matcher->matches(
        method_name          = iv_method_name
        configured_arguments = mo_configured
        actual_arguments     = io_arguments ).
      RETURN.
    ENDIF.

    rv_applies = abap_true.
    LOOP AT mo_configured->mt_parameters INTO ls_configured WHERE ignored = abap_false.
      READ TABLE io_arguments->mt_parameters INTO ls_actual WITH KEY name = ls_configured-name.
      IF sy-subrc <> 0 OR is_same( is_configured = ls_configured
                                   is_actual     = ls_actual ) = abap_false.
        rv_applies = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD is_same.
    FIELD-SYMBOLS <lg_configured> TYPE any.
    FIELD-SYMBOLS <lg_actual>     TYPE any.

    ASSIGN is_configured-value->* TO <lg_configured>.
    ASSIGN is_actual-value->* TO <lg_actual>.

    " a parameter that was left out is compared as initial value
    IF is_configured-supplied = abap_false AND is_actual-supplied = abap_false.
      rv_same = abap_true.
    ELSEIF is_configured-supplied = abap_false.
      IF <lg_actual> IS INITIAL.
        rv_same = abap_true.
      ENDIF.
    ELSEIF is_actual-supplied = abap_false.
      IF <lg_configured> IS INITIAL.
        rv_same = abap_true.
      ENDIF.
    ELSEIF <lg_configured> = <lg_actual>.
      rv_same = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD has_calls_left.
    rv_left = boolc( mv_calls < mv_times ).
  ENDMETHOD.

  METHOD answer.
    DATA lo_result TYPE REF TO lcl_result.
    DATA li_result TYPE REF TO if_abap_testdouble_result.
    DATA ls_output LIKE LINE OF mt_outputs.

    FIELD-SYMBOLS <lg_value> TYPE any.

    mv_calls = mv_calls + 1.
    IF mv_has_expectation = abap_true AND mv_calls > mv_expected.
      " reported at once, verify_expectations( ) would report it too
      cl_abap_unit_assert=>fail( msg = |{ mv_method_name } is called { mv_calls } times, expected { mv_expected }| ).
    ENDIF.

    CREATE OBJECT lo_result
      EXPORTING
        it_parameters = it_parameters.
    li_result = lo_result.

    IF mi_answer IS BOUND.
      mi_answer->answer(
        EXPORTING
          method_name   = iv_method_name
          double_handle = ii_handle
          arguments     = io_arguments
        CHANGING
          result        = li_result ).
      IF lo_result->mo_exception IS BOUND.
        RAISE EXCEPTION lo_result->mo_exception.
      ENDIF.
      RETURN.
    ENDIF.

    IF mo_exception IS BOUND.
      RAISE EXCEPTION mo_exception.
    ENDIF.

    LOOP AT mt_outputs INTO ls_output.
      ASSIGN ls_output-value->* TO <lg_value>.
      IF ls_output-kind = cl_abap_objectdescr=>exporting.
        li_result->set_param_exporting( name  = ls_output-name
                                        value = <lg_value> ).
      ELSE.
        li_result->set_param_changing( name  = ls_output-name
                                       value = <lg_value> ).
      ENDIF.
    ENDLOOP.

    IF mr_returning IS BOUND.
      ASSIGN mr_returning->* TO <lg_value>.
      li_result->set_param_returning( <lg_value> ).
    ENDIF.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~returning.
    IF mo_exception IS BOUND OR mi_answer IS BOUND.
      lcl_error=>raise( 'returning( ) cannot be combined with raise_exception( ) or set_answer( )' ).
    ENDIF.
    mr_returning = lcl_arguments=>copy( value ).
    configuration = me.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~set_parameter.
    DATA ls_output LIKE LINE OF mt_outputs.

    IF mo_exception IS BOUND OR mi_answer IS BOUND.
      lcl_error=>raise( 'set_parameter( ) cannot be combined with raise_exception( ) or set_answer( )' ).
    ENDIF.
    ls_output-name = to_upper( name ).
    ls_output-value = lcl_arguments=>copy( value ).
    APPEND ls_output TO mt_outputs.
    configuration = me.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~raise_exception.
    IF mo_exception IS BOUND OR mr_returning IS BOUND OR lines( mt_outputs ) > 0 OR mi_answer IS BOUND.
      lcl_error=>raise( 'raise_exception( ) cannot be combined with returning( ), set_parameter( ), set_answer( ) or another raise_exception( )' ).
    ENDIF.
    mo_exception = exception_object.
    configuration = me.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~raise_event.
    lcl_error=>raise( 'raise_event is not supported by open-abap' ).
  ENDMETHOD.

  METHOD if_abap_testdouble_config~times.
    IF number <= 0.
      lcl_error=>raise(
        iv_text     = |times( ) needs a number greater than 0, got { number }|
        iv_expected = number ).
    ENDIF.
    mv_times = number.
    configuration = me.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~ignore_parameter.
    APPEND to_upper( name ) TO mt_ignored.
    configuration = me.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~ignore_all_parameters.
    mv_ignore_all = abap_true.
    configuration = me.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~and_expect.
    CREATE OBJECT verification TYPE lcl_verification
      EXPORTING
        io_configuration = me.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~set_answer.
    IF mo_exception IS BOUND OR mr_returning IS BOUND OR lines( mt_outputs ) > 0.
      lcl_error=>raise( 'set_answer( ) cannot be combined with returning( ), set_parameter( ) or raise_exception( )' ).
    ENDIF.
    mi_answer = answer.
  ENDMETHOD.

  METHOD if_abap_testdouble_config~set_matcher.
    mi_matcher = matcher.
    configuration = me.
  ENDMETHOD.

ENDCLASS.

*************************************************************

CLASS lcl_verification IMPLEMENTATION.

  METHOD constructor.
    mo_configuration = io_configuration.
  ENDMETHOD.

  METHOD if_abap_testdouble_verify~is_called_times.
    mo_configuration->expect( times ).
  ENDMETHOD.

  METHOD if_abap_testdouble_verify~is_called_once.
    mo_configuration->expect( 1 ).
  ENDMETHOD.

  METHOD if_abap_testdouble_verify~is_never_called.
    mo_configuration->expect( 0 ).
  ENDMETHOD.

ENDCLASS.

*************************************************************

"! A double: an object that implements the doubled interface, and its configurations
CLASS lcl_double DEFINITION.
  PUBLIC SECTION.
    DATA mo_object TYPE REF TO object READ-ONLY.

    CLASS-METHODS find
      IMPORTING
        io_object        TYPE REF TO object
      RETURNING
        VALUE(ro_double) TYPE REF TO lcl_double
      RAISING
        cx_atd_exception_core.

    "! Called by every method of a double, input holds the actual parameters of the call
    CLASS-METHODS invoke
      IMPORTING
        io_object      TYPE REF TO object
        iv_method_name TYPE string
        input          TYPE any
      RAISING
        cx_static_check.

    METHODS constructor
      IMPORTING
        iv_interface TYPE string.

    METHODS configure_call
      RETURNING
        VALUE(ri_configuration) TYPE REF TO if_abap_testdouble_config.

    METHODS verify.

  PRIVATE SECTION.
    CLASS-DATA gt_doubles TYPE STANDARD TABLE OF REF TO lcl_double WITH DEFAULT KEY.

    DATA mt_configurations TYPE STANDARD TABLE OF REF TO lcl_configuration WITH DEFAULT KEY.
    DATA mo_pending TYPE REF TO lcl_configuration.
    DATA mi_handle TYPE REF TO if_abap_testdouble_handle.

    METHODS dispatch
      IMPORTING
        iv_method_name TYPE abap_methname
        it_parameters  TYPE lcl_arguments=>ty_parameters
      RAISING
        cx_static_check.
ENDCLASS.

CLASS lcl_double IMPLEMENTATION.

  METHOD find.
    LOOP AT gt_doubles INTO ro_double.
      IF ro_double->mo_object = io_object.
        RETURN.
      ENDIF.
    ENDLOOP.
    CLEAR ro_double.
    lcl_error=>raise( 'The object is not a test double of cl_abap_testdouble' ).
  ENDMETHOD.

  METHOD constructor.
    DATA lv_interface TYPE string.

    lv_interface = iv_interface.
    CREATE OBJECT mi_handle TYPE lcl_handle.

    " a class that implements the interface and the interfaces it includes, every instance method
    " hands its call to lcl_double=>invoke. The static methods of an interface cannot be doubled
    WRITE '@KERNEL const family = [];'.
    WRITE '@KERNEL const visit = (name) => {'.
    WRITE '@KERNEL   const intf = abap.Classes[name];'.
    WRITE '@KERNEL   if (intf === undefined || family.some(member => member.name === name)) { return; }'.
    WRITE '@KERNEL   family.push({name, intf});'.
    WRITE '@KERNEL   for (const component of intf.IMPLEMENTED_INTERFACES ?? []) { visit(component); }'.
    WRITE '@KERNEL };'.
    WRITE '@KERNEL visit(lv_interface.get());'.
    WRITE '@KERNEL const double = class {'.
    WRITE '@KERNEL   static INTERNAL_TYPE = "CLAS";'.
    WRITE '@KERNEL   static INTERNAL_NAME = "CL_ABAP_TESTDOUBLE=>" + lv_interface.get();'.
    WRITE '@KERNEL   static IMPLEMENTED_INTERFACES = family.map(member => member.name);'.
    WRITE '@KERNEL   static ATTRIBUTES = {};'.
    WRITE '@KERNEL   static METHODS = {};'.
    WRITE '@KERNEL   constructor() { this.INTERNAL_ID = abap.internalIdCounter++; }'.
    WRITE '@KERNEL   async constructor_() { return this; }'.
    WRITE '@KERNEL };'.
    WRITE '@KERNEL for (const member of family) {'.
    WRITE '@KERNEL   for (const [method, meta] of Object.entries(member.intf.METHODS ?? {})) {'.
    WRITE '@KERNEL     if (meta.is_class === "X") { continue; }'.
    WRITE '@KERNEL     const target = meta.alias_for ?? (member.name + "~" + method);'.
    WRITE '@KERNEL     double.prototype[member.name.toLowerCase() + "$" + method.toLowerCase()] = async function (INPUT) {'.
    WRITE '@KERNEL       return lcl_double.invoke({'.
    WRITE '@KERNEL         io_object: new abap.types.ABAPObject().set(this),'.
    WRITE '@KERNEL         iv_method_name: new abap.types.String().set(target),'.
    WRITE '@KERNEL         input: INPUT ?? {}});'.
    WRITE '@KERNEL     };'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL }'.
    WRITE '@KERNEL this.mo_object.set(new double());'.

    APPEND me TO gt_doubles.
  ENDMETHOD.

  METHOD invoke.
    DATA lt_parameters TYPE lcl_arguments=>ty_parameters.
    DATA ls_parameter  LIKE LINE OF lt_parameters.
    DATA lv_interface  TYPE string.
    DATA lv_method     TYPE string.

    SPLIT iv_method_name AT '~' INTO lv_interface lv_method.

    " importing parameters are copied with the type of the formal parameter, like a call of a
    " method does. A generic formal parameter keeps the type of the actual parameter
    WRITE '@KERNEL const generic = ["AnyType", "CLikeType", "CSequenceType", "DataType", "SimpleType",'.
    WRITE '@KERNEL   "NumericGenericType", "XSequenceType", "XGenericType", "CGenericType", "NGenericType",'.
    WRITE '@KERNEL   "PGenericType", "GenericObjectReferenceType", "UnknownType", "VoidType"];'.
    WRITE '@KERNEL const valueOf = (parameter, actual) => {'.
    WRITE '@KERNEL   if (actual instanceof abap.types.FieldSymbol) { actual = actual.getPointer(); }'.
    WRITE '@KERNEL   if (parameter.parm_kind === "R") { return parameter.type(); }'.
    WRITE '@KERNEL   if (actual !== undefined && (parameter.parm_kind === "E" || parameter.parm_kind === "C")) { return actual; }'.
    WRITE '@KERNEL   if (generic.includes(parameter.type_name)) { return actual?.clone?.() ?? new abap.types.String(); }'.
    WRITE '@KERNEL   const formal = parameter.type();'.
    WRITE '@KERNEL   if (actual === undefined) { return formal; }'.
    WRITE '@KERNEL   if (parameter.type_name === "TableType" && formal.getRowType?.() instanceof abap.types.Character'.
    WRITE '@KERNEL       && formal.getRowType().getQualifiedName?.() === undefined) { return actual.clone(); }'.
    WRITE '@KERNEL   formal.set(actual);'.
    WRITE '@KERNEL   return formal;'.
    WRITE '@KERNEL };'.
    WRITE '@KERNEL const meta = abap.Classes[lv_interface.get()]?.METHODS?.[lv_method.get()];'.
    WRITE '@KERNEL let returning = undefined;'.
    WRITE '@KERNEL for (const [name, parameter] of Object.entries(meta?.parameters ?? {})) {'.
    WRITE '@KERNEL   const actual = input[name.toLowerCase()];'.
    CLEAR ls_parameter.
    WRITE '@KERNEL   ls_parameter.get().name.set(name);'.
    WRITE '@KERNEL   ls_parameter.get().kind.set(parameter.parm_kind);'.
    WRITE '@KERNEL   ls_parameter.get().supplied.set(actual === undefined ? "" : "X");'.
    WRITE '@KERNEL   ls_parameter.get().value.assign(valueOf(parameter, actual));'.
    WRITE '@KERNEL   if (parameter.parm_kind === "R") { returning = ls_parameter.get().value.getPointer(); }'.
    APPEND ls_parameter TO lt_parameters.
    WRITE '@KERNEL }'.

    find( io_object )->dispatch(
      iv_method_name = |{ lv_interface }~{ lv_method }|
      it_parameters  = lt_parameters ).

    WRITE '@KERNEL return returning;'.
  ENDMETHOD.

  METHOD dispatch.
    DATA lo_arguments     TYPE REF TO lcl_arguments.
    DATA lo_configuration TYPE REF TO lcl_configuration.
    DATA lo_candidate     TYPE REF TO lcl_configuration.
    DATA lo_last          TYPE REF TO lcl_configuration.

    IF mo_pending IS BOUND.
      " the first call after configure_call( ) registers the configuration and is not answered
      lo_configuration = mo_pending.
      CLEAR mo_pending.
      lo_configuration->register( iv_method_name = iv_method_name
                                  it_parameters  = it_parameters ).
      APPEND lo_configuration TO mt_configurations.
      RETURN.
    ENDIF.

    CREATE OBJECT lo_arguments
      EXPORTING
        it_parameters = it_parameters.

    " the first configuration, in the order of creation, that applies and has calls left,
    " when every one is used up the last one that applies
    LOOP AT mt_configurations INTO lo_candidate.
      IF lo_candidate->applies_to( iv_method_name = iv_method_name
                                   io_arguments   = lo_arguments ) = abap_true.
        IF lo_candidate->has_calls_left( ) = abap_true.
          lo_configuration = lo_candidate.
          EXIT.
        ENDIF.
        lo_last = lo_candidate.
      ENDIF.
    ENDLOOP.
    IF lo_configuration IS NOT BOUND.
      lo_configuration = lo_last.
    ENDIF.
    IF lo_configuration IS NOT BOUND.
      " not configured: exporting and changing parameters stay as they are, returning is initial
      RETURN.
    ENDIF.

    lo_configuration->answer(
      iv_method_name = iv_method_name
      io_arguments   = lo_arguments
      it_parameters  = it_parameters
      ii_handle      = mi_handle ).
  ENDMETHOD.

  METHOD configure_call.
    CREATE OBJECT mo_pending.
    ri_configuration = mo_pending.
  ENDMETHOD.

  METHOD verify.
    DATA lo_configuration TYPE REF TO lcl_configuration.

    LOOP AT mt_configurations INTO lo_configuration.
      IF lo_configuration->mv_has_expectation = abap_true
          AND lo_configuration->mv_calls <> lo_configuration->mv_expected.
        cl_abap_unit_assert=>fail(
          msg = |{ lo_configuration->mv_method_name } is called { lo_configuration->mv_calls } times, expected { lo_configuration->mv_expected }| ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
