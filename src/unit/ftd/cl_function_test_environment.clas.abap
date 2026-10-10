CLASS cl_function_test_environment DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_function_test_environment.

    "! Note: open-abap function module test doubles allows creating doubles for non-existing
    "! function modules. One environment is active at a time: create( ) ends the doubles of the
    "! previous environment, its function modules are called again. In SAP the doubles end with
    "! the test class that created them, open-abap cannot see where a test class ends
    CLASS-METHODS create
      IMPORTING
        function_modules                 TYPE if_function_test_environment=>tt_function_dependencies
      RETURNING
        VALUE(function_test_environment) TYPE REF TO if_function_test_environment.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_double,
             name   TYPE sxco_fm_name,
             double TYPE REF TO if_function_testdouble,
           END OF ty_double.
    TYPES ty_doubles TYPE SORTED TABLE OF ty_double WITH UNIQUE KEY name.

    " the doubles of the active environment
    CLASS-DATA gt_active TYPE ty_doubles.

    DATA mt_doubles TYPE ty_doubles.

    CLASS-METHODS install
      IMPORTING
        it_doubles TYPE ty_doubles.

    CLASS-METHODS restore.
ENDCLASS.

CLASS cl_function_test_environment IMPLEMENTATION.

  METHOD create.
    DATA lo_environment TYPE REF TO cl_function_test_environment.
    DATA lv_module      LIKE LINE OF function_modules.
    DATA ls_double      TYPE ty_double.

    ASSERT lines( function_modules ) > 0.

    restore( ).

    CREATE OBJECT lo_environment.
    LOOP AT function_modules INTO lv_module.
      ls_double-name = to_upper( lv_module ).
      CREATE OBJECT ls_double-double TYPE lcl_double
        EXPORTING
          iv_name = ls_double-name.
      INSERT ls_double INTO TABLE lo_environment->mt_doubles.
    ENDLOOP.

    install( lo_environment->mt_doubles ).
    function_test_environment = lo_environment.
  ENDMETHOD.

  METHOD install.
    DATA ls_double LIKE LINE OF it_doubles.

    " from now on a call of the function module is a call of its double, until restore( )
    WRITE '@KERNEL cl_function_test_environment.REVERT = cl_function_test_environment.REVERT ?? {};'.
    LOOP AT it_doubles INTO ls_double.
      WRITE '@KERNEL const name = ls_double.get().name.get().trimEnd();'.
      WRITE '@KERNEL const testDouble = ls_double.get().double.get();'.
      WRITE '@KERNEL cl_function_test_environment.REVERT[name] = abap.FunctionModules[name];'.
      WRITE '@KERNEL abap.FunctionModules[name] = async (INPUT) => testDouble.invoke({fminput: INPUT});'.
    ENDLOOP.
    gt_active = it_doubles.
  ENDMETHOD.

  METHOD restore.
    DATA ls_double LIKE LINE OF gt_active.

    LOOP AT gt_active INTO ls_double.
      WRITE '@KERNEL const name = ls_double.get().name.get().trimEnd();'.
      WRITE '@KERNEL if (cl_function_test_environment.REVERT[name] === undefined) {'.
      WRITE '@KERNEL   delete abap.FunctionModules[name];'.
      WRITE '@KERNEL } else {'.
      WRITE '@KERNEL   abap.FunctionModules[name] = cl_function_test_environment.REVERT[name];'.
      WRITE '@KERNEL }'.
    ENDLOOP.
    CLEAR gt_active.
  ENDMETHOD.

  METHOD if_function_test_environment~get_double.
    DATA ls_double LIKE LINE OF mt_doubles.

    READ TABLE mt_doubles INTO ls_double WITH KEY name = to_upper( function_name ).
    ASSERT sy-subrc = 0.

    result = ls_double-double.
  ENDMETHOD.

  METHOD if_function_test_environment~clear_doubles.
    DATA ls_double LIKE LINE OF mt_doubles.

    " as in SAP, the doubles stay: only their configurations and the calls they recorded go
    LOOP AT mt_doubles INTO ls_double.
      ls_double-double->clear( ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.