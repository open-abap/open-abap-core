INTERFACE if_abap_lock_object PUBLIC.

  TYPES tv_name           TYPE c LENGTH 30.
  TYPES tv_table_name     TYPE tabname.
  TYPES tv_parameter_name TYPE c LENGTH 30.
  TYPES tv_mode           TYPE c.
  TYPES tv_scope          TYPE n LENGTH 1.
  TYPES tv_wait           TYPE c.
  TYPES tv_synchronous    TYPE c.

  TYPES: BEGIN OF ts_table_mode,
           table_name TYPE tv_table_name,
           mode       TYPE tv_mode,
         END OF ts_table_mode.
  TYPES tt_table_mode TYPE HASHED TABLE OF ts_table_mode WITH UNIQUE KEY table_name.

  TYPES: BEGIN OF ts_parameter,
           name  TYPE tv_parameter_name,
           value TYPE REF TO data,
         END OF ts_parameter.
  TYPES tt_parameter TYPE HASHED TABLE OF ts_parameter WITH UNIQUE KEY name.

  CONSTANTS: BEGIN OF cs_mode,
               write_lock                    TYPE tv_mode VALUE 'E',
               shared_lock                   TYPE tv_mode VALUE 'S',
               exclusive_lock                TYPE tv_mode VALUE 'X',
               optimistic_lock               TYPE tv_mode VALUE 'O',
               promote_optimistic_lock       TYPE tv_mode VALUE 'R',
               check_write_lock              TYPE tv_mode VALUE 'V',
               check_shared_lock             TYPE tv_mode VALUE 'W',
               check_exclusive_lock          TYPE tv_mode VALUE 'U',
               check_promote_optimistic_lock TYPE tv_mode VALUE 'C',
             END OF cs_mode.

  CONSTANTS: BEGIN OF cs_scope,
               no_update_program              TYPE tv_scope VALUE '1',
               update_program                 TYPE tv_scope VALUE '2',
               interactive_and_update_program TYPE tv_scope VALUE '3',
             END OF cs_scope.

  CONSTANTS: BEGIN OF cs_synchronous,
               yes TYPE tv_synchronous VALUE 'X',
               no  TYPE tv_synchronous VALUE ' ',
             END OF cs_synchronous.

  CONSTANTS: BEGIN OF cs_wait,
               no  TYPE tv_wait VALUE ' ',
               yes TYPE tv_wait VALUE 'X',
             END OF cs_wait.

  METHODS enqueue
    IMPORTING
      it_table_mode TYPE tt_table_mode OPTIONAL
      it_parameter  TYPE tt_parameter OPTIONAL
      _scope        TYPE tv_scope DEFAULT cs_scope-update_program
      _wait         TYPE tv_wait DEFAULT cs_wait-no
    RAISING
      cx_abap_foreign_lock
      cx_abap_lock_failure.

  METHODS dequeue
    IMPORTING
      it_table_mode TYPE tt_table_mode OPTIONAL
      it_parameter  TYPE tt_parameter OPTIONAL
      _scope        TYPE tv_scope DEFAULT cs_scope-interactive_and_update_program
      _synchronous  TYPE tv_synchronous DEFAULT cs_synchronous-no
    RAISING
      cx_abap_lock_failure.

ENDINTERFACE.
