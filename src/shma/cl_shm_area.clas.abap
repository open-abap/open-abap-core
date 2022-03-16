CLASS cl_shm_area DEFINITION PUBLIC INHERITING FROM cx_shm_general_error.
  PUBLIC SECTION.
    CONSTANTS default_instance TYPE shm_inst_name VALUE '$DEFAULT_INSTANCE$'.
    CONSTANTS invocation_mode_explicit TYPE shm_constr_invocation_mode VALUE 319200300.
    CONSTANTS life_context_appserver TYPE shm_life_context VALUE 109200001.
    CONSTANTS attach_mode_default TYPE shm_attach_mode VALUE 1302197000.
    CONSTANTS attach_mode_wait TYPE shm_attach_mode VALUE 1302197002.
    CONSTANTS affect_local_server TYPE shm_affect_server VALUE 281119720.

    DATA properties TYPE shm_properties READ-ONLY.
    DATA inst_name TYPE shm_inst_name READ-ONLY.
    DATA client TYPE mandt READ-ONLY.

  PROTECTED SECTION.
    DATA inst_trace_active TYPE abap_bool VALUE abap_false.
    DATA inst_trace_service TYPE REF TO if_shm_trace.
    DATA _lock TYPE %_c_pointer.
    CONSTANTS attach_mode_wait_2nd_try TYPE shm_attach_mode VALUE 1302197003.

    METHODS _attach_read71
      IMPORTING
        sneak_mode   TYPE abap_bool DEFAULT abap_false
        area_name    TYPE shm_area_name
        life_context TYPE shm_life_context
      EXPORTING
        root         TYPE REF TO object
      RAISING
        cx_shm_inconsistent
        cx_shm_no_active_version
        cx_shm_read_lock_active
        cx_shm_exclusive_lock_active
        cx_shm_parameter_error
        cx_shm_change_lock_active.    

    METHODS _attach_update70
      IMPORTING
        area_name TYPE shm_area_name
        mode      TYPE shm_attach_mode
      EXPORTING
        root      TYPE REF TO object
      CHANGING
        wait_time TYPE i OPTIONAL
      RAISING
        cx_shm_inconsistent
        cx_shm_exclusive_lock_active
        cx_shm_change_lock_active
        cx_shm_version_limit_exceeded
        cx_shm_no_active_version
        cx_shm_parameter_error
        cx_shm_pending_lock_removed.        

    METHODS _attach_write70
      IMPORTING
        area_name TYPE shm_area_name
        mode      TYPE shm_attach_mode
      EXPORTING
        root      TYPE REF TO object
      CHANGING
        wait_time TYPE i OPTIONAL
      RAISING
        cx_shm_version_limit_exceeded
        cx_shm_exclusive_lock_active
        cx_shm_change_lock_active
        cx_shm_parameter_error
        cx_shm_pending_lock_removed. 

    CLASS-METHODS _invalidate_area71
      IMPORTING
        area_name TYPE shm_area_name
        client TYPE shm_client
        client_supplied TYPE abap_bool DEFAULT abap_false
        transactional TYPE abap_bool DEFAULT abap_false
        client_dependent TYPE abap_bool DEFAULT abap_false
        terminate_changer TYPE abap_bool
        affect_server TYPE shm_affect_server
        life_context TYPE shm_life_context DEFAULT life_context_appserver
      RETURNING
        VALUE(rc) TYPE shm_rc
      RAISING
        cx_shm_parameter_error.

    CLASS-METHODS _invalidate_instance71
      IMPORTING
        area_name TYPE shm_area_name
        inst_name TYPE shm_inst_name
        client TYPE shm_client
        client_supplied TYPE abap_bool DEFAULT abap_false
        transactional TYPE abap_bool DEFAULT abap_false
        client_dependent TYPE abap_bool DEFAULT abap_false
        terminate_changer TYPE abap_bool
        affect_server TYPE shm_affect_server
        life_context TYPE shm_life_context DEFAULT life_context_appserver
      RETURNING
        VALUE(rc) TYPE shm_rc
      RAISING
        cx_shm_parameter_error.   

    METHODS _set_root
      IMPORTING
        root TYPE REF TO object
      RAISING
        cx_shm_wrong_handle
        cx_shm_initial_reference.

    CLASS-METHODS _detach_area71
      IMPORTING
        area_name        TYPE shm_area_name
        client           TYPE shm_client
        client_supplied  TYPE abap_bool
        client_dependent TYPE abap_bool DEFAULT abap_false
        life_context     TYPE shm_life_context
      RETURNING
        VALUE(rc)        TYPE shm_rc.       
          
    CLASS-METHODS _free_area71
      IMPORTING
        area_name TYPE shm_area_name
        client TYPE shm_client
        client_supplied TYPE abap_bool DEFAULT abap_false
        transactional TYPE abap_bool DEFAULT abap_false
        client_dependent TYPE abap_bool DEFAULT abap_false
        terminate_changer TYPE abap_bool
        affect_server TYPE shm_affect_server
        life_context TYPE shm_life_context DEFAULT life_context_appserver
      RETURNING
        VALUE(rc) TYPE shm_rc
      RAISING
        cx_shm_parameter_error.          
        
    CLASS-METHODS _get_instance_infos71
      IMPORTING
        area_name TYPE shm_area_name
        client TYPE shm_client
        client_supplied TYPE abap_bool DEFAULT abap_false
        client_dependent TYPE abap_bool DEFAULT abap_false
        life_context TYPE shm_life_context
      RETURNING
        VALUE(infos) TYPE shm_inst_infos.        
ENDCLASS.

CLASS cl_shm_area IMPLEMENTATION.

  METHOD _attach_read71.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD _get_instance_infos71.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD _detach_area71.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD _free_area71.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD _set_root.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD _invalidate_instance71.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD _invalidate_area71.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD _attach_update70.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
  
  METHOD _attach_write70.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.