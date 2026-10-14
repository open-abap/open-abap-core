CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_instance FOR TESTING RAISING cx_static_check.
    METHODS enqueue_dequeue FOR TESTING RAISING cx_static_check.
    METHODS enqueue_twice FOR TESTING RAISING cx_static_check.
    METHODS dequeue_all FOR TESTING RAISING cx_static_check.
    METHODS constants FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_instance.
    DATA lo_lock_object TYPE REF TO if_abap_lock_object.

    lo_lock_object = cl_abap_lock_object_factory=>get_instance( 'EZLOCK' ).

    cl_abap_unit_assert=>assert_bound( lo_lock_object ).
  ENDMETHOD.

  METHOD enqueue_dequeue.
    DATA lo_lock_object TYPE REF TO if_abap_lock_object.
    DATA lt_parameter   TYPE if_abap_lock_object=>tt_parameter.
    DATA lt_table_mode  TYPE if_abap_lock_object=>tt_table_mode.
    DATA ls_parameter   LIKE LINE OF lt_parameter.
    DATA ls_table_mode  LIKE LINE OF lt_table_mode.

    ls_parameter-name = 'CARRID'.
    GET REFERENCE OF ls_parameter-name INTO ls_parameter-value.
    INSERT ls_parameter INTO TABLE lt_parameter.

    ls_table_mode-table_name = 'SCARR'.
    ls_table_mode-mode = if_abap_lock_object=>cs_mode-exclusive_lock.
    INSERT ls_table_mode INTO TABLE lt_table_mode.

    lo_lock_object = cl_abap_lock_object_factory=>get_instance( 'EZLOCK' ).

    lo_lock_object->enqueue(
      it_table_mode = lt_table_mode
      it_parameter  = lt_parameter
      _scope        = if_abap_lock_object=>cs_scope-no_update_program
      _wait         = if_abap_lock_object=>cs_wait-yes ).

    lo_lock_object->dequeue(
      it_table_mode = lt_table_mode
      it_parameter  = lt_parameter
      _scope        = if_abap_lock_object=>cs_scope-no_update_program
      _synchronous  = if_abap_lock_object=>cs_synchronous-yes ).
  ENDMETHOD.

  METHOD enqueue_twice.
* single session, so the second enqueue never meets a foreign lock
    DATA lo_lock_object TYPE REF TO if_abap_lock_object.

    lo_lock_object = cl_abap_lock_object_factory=>get_instance( 'EZLOCK' ).

    lo_lock_object->enqueue( ).
    lo_lock_object->enqueue( ).
    lo_lock_object->dequeue( ).
  ENDMETHOD.

  METHOD dequeue_all.
    DATA lo_lock_object TYPE REF TO if_abap_lock_object.

    lo_lock_object = cl_abap_lock_object_factory=>get_instance( 'EZLOCK' ).
    lo_lock_object->enqueue( ).

    cl_abap_lock_object_factory=>dequeue_all( ).
    cl_abap_lock_object_factory=>dequeue_all( if_abap_lock_object=>cs_synchronous-yes ).
  ENDMETHOD.

  METHOD constants.
    cl_abap_unit_assert=>assert_equals(
      act = if_abap_lock_object=>cs_mode-write_lock
      exp = 'E' ).
    cl_abap_unit_assert=>assert_equals(
      act = if_abap_lock_object=>cs_mode-promote_optimistic_lock
      exp = 'R' ).
    cl_abap_unit_assert=>assert_equals(
      act = if_abap_lock_object=>cs_scope-interactive_and_update_program
      exp = '3' ).
    cl_abap_unit_assert=>assert_equals(
      act = if_abap_lock_object=>cs_wait-yes
      exp = 'X' ).
  ENDMETHOD.

ENDCLASS.
