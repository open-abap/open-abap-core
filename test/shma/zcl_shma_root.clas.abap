CLASS zcl_shma_root DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  SHARED MEMORY ENABLED.

  PUBLIC SECTION.

    INTERFACES if_shm_build_instance.

    CLASS-METHODS read RETURNING VALUE(val) TYPE i.
    CLASS-METHODS update IMPORTING val TYPE i.

    METHODS set
      IMPORTING
        !value TYPE i.
    METHODS get
      RETURNING
        VALUE(value) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA value TYPE i.
ENDCLASS.



CLASS zcl_shma_root IMPLEMENTATION.


  METHOD get.

    value = me->value.

  ENDMETHOD.


  METHOD if_shm_build_instance~build.

    DATA area  TYPE REF TO zcl_shma_area.
    DATA root  TYPE REF TO zcl_shma_root.
    DATA excep TYPE REF TO cx_root.


    TRY.
        area = zcl_shma_area=>attach_for_write( ).
      CATCH cx_shm_error INTO excep.
        RAISE EXCEPTION TYPE cx_shm_build_failed
          EXPORTING
            previous = excep.
    ENDTRY.

    CREATE OBJECT root AREA HANDLE area.

    root->set( 2 ).

    area->set_root( root ).

    area->detach_commit( ).

  ENDMETHOD.


  METHOD read.
    DATA lo_area TYPE REF TO zcl_shma_area.
    TRY.
        lo_area = zcl_shma_area=>attach_for_read( ).
        val = lo_area->root->get( ).
        lo_area->detach( ).
      CATCH cx_shm_inconsistent
          cx_shm_no_active_version
          cx_shm_read_lock_active
          cx_shm_exclusive_lock_active
          cx_shm_parameter_error
          cx_shm_wrong_handle
          cx_shm_already_detached
          cx_shm_change_lock_active.
    ENDTRY.
  ENDMETHOD.


  METHOD set.

    me->value = value.

  ENDMETHOD.


  METHOD update.

    DATA lo_root TYPE REF TO zcl_shma_root.
    DATA lo_area TYPE REF TO zcl_shma_area.

    TRY.
        lo_area = zcl_shma_area=>attach_for_write( ).

        lo_root ?= lo_area->get_root( ).
        IF lo_root IS INITIAL.
          CREATE OBJECT lo_root AREA HANDLE lo_area.
        ENDIF.

        lo_root->set( val ).
        lo_area->set_root( lo_root ).
        lo_area->detach_commit( ).
      CATCH cx_shm_exclusive_lock_active
          cx_shm_version_limit_exceeded
          cx_shm_change_lock_active
          cx_shm_parameter_error
          cx_shm_already_detached
          cx_shm_initial_reference
          cx_shm_wrong_handle
          cx_shm_secondary_commit
          cx_shm_event_execution_failed
          cx_shm_completion_error
          cx_shm_pending_lock_removed.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.