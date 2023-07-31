CLASS cl_function_test_environment DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_function_test_environment.

    "! Note: open-abap function module test doubles allows creating doubles for non-existing
    "! function modules
    CLASS-METHODS create
      IMPORTING
        function_modules                 TYPE if_function_test_environment=>tt_function_dependencies
      RETURNING
        VALUE(function_test_environment) TYPE REF TO if_function_test_environment.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_backup,
             name   TYPE sxco_fm_name,
             backup TYPE i,
           END OF ty_backup.
    CLASS-DATA gt_backup TYPE SORTED TABLE OF ty_backup WITH UNIQUE KEY name.
ENDCLASS.

CLASS cl_function_test_environment IMPLEMENTATION.

  METHOD create.
    DATA lv_module LIKE LINE OF function_modules.
    DATA ls_row    LIKE LINE OF gt_backup.

    ASSERT lines( function_modules ) > 0.
    LOOP AT function_modules INTO lv_module.
      ls_row-name = lv_module.
      WRITE '@KERNEL ls_row.get().backup = abap.FunctionModules[lv_module.get().trimEnd()];'.
      INSERT ls_row INTO gt_backup.
    ENDLOOP.

    CREATE OBJECT function_test_environment TYPE cl_function_test_environment.
  ENDMETHOD.

  METHOD if_function_test_environment~get_double.
    CREATE OBJECT result TYPE lcl_double.
  ENDMETHOD.

  METHOD if_function_test_environment~clear_doubles.
    FIELD-SYMBOLS <ls_row> LIKE LINE OF gt_backup.

    LOOP AT gt_backup ASSIGNING <ls_row>.
      WRITE '@KERNEL abap.FunctionModules[fs_ls_row_.get().name.get().trimEnd()] = fs_ls_row_.get().backup;'.
    ENDLOOP.
    CLEAR gt_backup.
  ENDMETHOD.

ENDCLASS.