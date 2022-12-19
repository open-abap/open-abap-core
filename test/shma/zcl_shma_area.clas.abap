CLASS zcl_shma_area DEFINITION
  PUBLIC
  INHERITING FROM cl_shm_area
  FINAL
  CREATE PRIVATE

  GLOBAL FRIENDS cl_shm_area .

  PUBLIC SECTION.

    CONSTANTS area_name TYPE shm_area_name VALUE 'ZCL_SHMA_AREA' ##NO_TEXT.
    DATA root TYPE REF TO zcl_shma_root READ-ONLY .

    CLASS-METHODS class_constructor .
    CLASS-METHODS get_generator_version
    RETURNING
      VALUE(generator_version) TYPE i .
    CLASS-METHODS attach_for_read
    IMPORTING
      !inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
    PREFERRED PARAMETER inst_name
    RETURNING
      VALUE(handle) TYPE REF TO zcl_shma_area
    RAISING
      cx_shm_inconsistent
      cx_shm_no_active_version
      cx_shm_read_lock_active
      cx_shm_exclusive_lock_active
      cx_shm_parameter_error
      cx_shm_change_lock_active .
    CLASS-METHODS attach_for_write
    IMPORTING
      !inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      !attach_mode TYPE shm_attach_mode DEFAULT cl_shm_area=>attach_mode_default
      !wait_time TYPE i DEFAULT 0
    PREFERRED PARAMETER inst_name
    RETURNING
      VALUE(handle) TYPE REF TO zcl_shma_area
    RAISING
      cx_shm_exclusive_lock_active
      cx_shm_version_limit_exceeded
      cx_shm_change_lock_active
      cx_shm_parameter_error
      cx_shm_pending_lock_removed .
    CLASS-METHODS attach_for_update
    IMPORTING
      !inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      !attach_mode TYPE shm_attach_mode DEFAULT cl_shm_area=>attach_mode_default
      !wait_time TYPE i DEFAULT 0
    PREFERRED PARAMETER inst_name
    RETURNING
      VALUE(handle) TYPE REF TO zcl_shma_area
    RAISING
      cx_shm_inconsistent
      cx_shm_no_active_version
      cx_shm_exclusive_lock_active
      cx_shm_version_limit_exceeded
      cx_shm_change_lock_active
      cx_shm_parameter_error
      cx_shm_pending_lock_removed .
    CLASS-METHODS detach_area
    RETURNING
      VALUE(rc) TYPE shm_rc .
    CLASS-METHODS invalidate_instance
    IMPORTING
      !inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      !terminate_changer TYPE abap_bool DEFAULT abap_true
    PREFERRED PARAMETER inst_name
    RETURNING
      VALUE(rc) TYPE shm_rc
    RAISING
      cx_shm_parameter_error .
    CLASS-METHODS invalidate_area
    IMPORTING
      !terminate_changer TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(rc) TYPE shm_rc
    RAISING
      cx_shm_parameter_error .
    CLASS-METHODS free_instance
    IMPORTING
      !inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      !terminate_changer TYPE abap_bool DEFAULT abap_true
    PREFERRED PARAMETER inst_name
    RETURNING
      VALUE(rc) TYPE shm_rc
    RAISING
      cx_shm_parameter_error .
    CLASS-METHODS free_area
    IMPORTING
      !terminate_changer TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(rc) TYPE shm_rc
    RAISING
      cx_shm_parameter_error .
    CLASS-METHODS get_instance_infos
    IMPORTING
      !inst_name TYPE shm_inst_name OPTIONAL
    RETURNING
      VALUE(infos) TYPE shm_inst_infos .
    CLASS-METHODS build
    IMPORTING
      !inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
    RAISING
      cx_shma_not_configured
      cx_shma_inconsistent
      cx_shm_build_failed .
    METHODS set_root
    IMPORTING
      !root TYPE REF TO zcl_shma_root
    RAISING
      cx_shm_initial_reference
      cx_shm_wrong_handle .

    METHODS get_root
    REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS _version_ TYPE i VALUE 23 ##NO_TEXT.
    CLASS-DATA _trace_service TYPE REF TO if_shm_trace .
    CLASS-DATA _trace_active TYPE abap_bool VALUE abap_false ##NO_TEXT.
    CONSTANTS _transactional TYPE abap_bool VALUE abap_false ##NO_TEXT.
    CONSTANTS _client_dependent TYPE abap_bool VALUE abap_false ##NO_TEXT.
    CONSTANTS _life_context TYPE shm_life_context VALUE cl_shm_area=>life_context_appserver ##NO_TEXT.
ENDCLASS.



CLASS zcl_shma_area IMPLEMENTATION.


  METHOD attach_for_read.

    DATA:
    l_attributes       TYPE shma_attributes,
    l_root             TYPE REF TO object,
    l_cx               TYPE REF TO cx_root,
    l_client           TYPE shm_client,
    l_client_supplied  TYPE abap_bool. "#EC NEEDED

* check if tracing should be activated/de-activated
    IF  ( NOT _trace_service IS INITIAL ).
      TRY.
          _trace_active =
          cl_shm_service=>trace_is_variant_active(
            _trace_service->variant-def_name
          ).
        CATCH cx_root. "#EC NO_HANDLER
                     "#EC CATCH_ALL
      ENDTRY.
    ENDIF.


    IF _trace_active = abap_false OR
  _trace_service->variant-attach_for_read = abap_false.

*   >

      CREATE OBJECT handle.

      handle->client    = l_client.
      handle->inst_name = inst_name.

*   try sneak mode first
      handle->_attach_read71( EXPORTING area_name    = area_name
                                      sneak_mode   = abap_true
                                      life_context = _life_context
                            IMPORTING root         = l_root ).

      IF l_root IS INITIAL.
*     no root object returned, sneak mode was not successful.
*     -> read area properties from database and try again.
        cl_shm_service=>initialize(
        EXPORTING area_name       = handle->area_name
                  client          = l_client
        IMPORTING attributes      = l_attributes
      ).

        handle->properties = l_attributes-properties.
        handle->_attach_read71( EXPORTING area_name    = area_name
                                        sneak_mode   = abap_false
                                        life_context = _life_context
                              IMPORTING root         = l_root ).

      ENDIF.

      handle->root ?= l_root.
*   <

    ELSE.

      TRY.

*       >

          CREATE OBJECT handle.

          handle->client    = l_client.
          handle->inst_name = inst_name.

          handle->_attach_read71( EXPORTING area_name    = area_name
                                          sneak_mode   = abap_true
                                          life_context = _life_context
                                IMPORTING root         = l_root ).

          IF l_root IS INITIAL.
*         no root object returned, sneak mode was not successful.
*         -> read area properties from database and try again.
            cl_shm_service=>initialize(
            EXPORTING area_name       = handle->area_name
                      client          = l_client
            IMPORTING attributes      = l_attributes
          ).

            handle->properties = l_attributes-properties.
            handle->_attach_read71( EXPORTING area_name    = area_name
                                            sneak_mode   = abap_false
                                            life_context = _life_context
                                  IMPORTING root         = l_root ).

          ENDIF.
          handle->root ?= l_root.

*       <
          _trace_service->trin_attach_for_read(
          area_name = area_name
          inst_name = inst_name
          client    = l_client ).

        CLEANUP INTO l_cx.
          _trace_service->trcx_attach_for_read(
          area_name = area_name
          inst_name = inst_name
          client    = l_client
          cx        = l_cx
        ).
      ENDTRY.

    ENDIF.

    handle->inst_trace_service = _trace_service.
    handle->inst_trace_active  = _trace_active.

  ENDMETHOD.


  METHOD attach_for_update.

    DATA:
    l_attributes             TYPE shma_attributes,
    l_root                   TYPE REF TO object,
    l_cx                     TYPE REF TO cx_root,
    l_client                 TYPE shm_client,
    l_client_supplied        TYPE abap_bool, "#EC NEEDED
    l_wait_time              TYPE i,
    l_wait_time_per_loop     TYPE i,
    l_wait_time_per_loop_sec TYPE f.

    l_wait_time = wait_time.

* check if tracing should be activated/de-activated
    IF  ( NOT _trace_service IS INITIAL ).
      TRY.
          _trace_active =
          cl_shm_service=>trace_is_variant_active(
            _trace_service->variant-def_name
          ).
        CATCH cx_root. "#EC NO_HANDLER
                     "#EC CATCH_ALL
      ENDTRY.
    ENDIF.


    IF _trace_active = abap_false OR
  _trace_service->variant-attach_for_upd = abap_false.

*   >

      CREATE OBJECT handle.

      handle->client    = l_client.
      handle->inst_name = inst_name.

      cl_shm_service=>initialize(
      EXPORTING area_name    = handle->area_name
                client       = l_client
      IMPORTING attributes   = l_attributes
    ).

      handle->properties = l_attributes-properties.

      handle->_attach_update70(
      EXPORTING area_name = handle->area_name
                mode      = attach_mode
      IMPORTING root      = l_root
      CHANGING  wait_time = l_wait_time ).

      IF abap_true = l_attributes-properties-has_versions AND
       handle->_lock IS NOT INITIAL.
* we may need a second try in case of class constructors
        handle->_attach_update70(
        EXPORTING area_name = handle->area_name
                  mode      = attach_mode
        IMPORTING root      = l_root
        CHANGING  wait_time = l_wait_time ).
      ENDIF.

      IF attach_mode = cl_shm_area=>attach_mode_wait AND
       handle->_lock IS INITIAL.

        l_wait_time_per_loop = l_wait_time / 10.
* wait_time_per_loop should be at least 2 * SHMATTACHWRITE_MAXACTIVEWAIT
        IF l_wait_time_per_loop < 2000.
          l_wait_time_per_loop = 2000.
        ELSEIF l_wait_time_per_loop > 300000.
          l_wait_time_per_loop = 300000.
        ENDIF.

        l_wait_time_per_loop_sec = l_wait_time_per_loop / 1000.

        WHILE handle->_lock IS INITIAL.

          IF l_wait_time_per_loop > l_wait_time.
            l_wait_time_per_loop = l_wait_time.
            l_wait_time_per_loop_sec = l_wait_time_per_loop / 1000.
          ENDIF.

          WAIT UP TO l_wait_time_per_loop_sec SECONDS.
          l_wait_time = l_wait_time - l_wait_time_per_loop.

          handle->_attach_update70(
          EXPORTING area_name = handle->area_name
                    mode      = cl_shm_area=>attach_mode_wait_2nd_try
          IMPORTING root      = l_root
          CHANGING  wait_time = l_wait_time ).

          IF abap_true = l_attributes-properties-has_versions AND
           handle->_lock IS NOT INITIAL.
* we may need a second try in case of class constructors
            handle->_attach_update70(
            EXPORTING area_name = handle->area_name
                      mode      = cl_shm_area=>attach_mode_wait_2nd_try
            IMPORTING root      = l_root
            CHANGING  wait_time = l_wait_time ).
          ENDIF.

        ENDWHILE.

      ENDIF.

      handle->root ?= l_root.

*   <

    ELSE.

      TRY.

*       >

          CREATE OBJECT handle.

          handle->client    = l_client.
          handle->inst_name = inst_name.

          cl_shm_service=>initialize(
          EXPORTING area_name    = handle->area_name
                    client       = l_client
          IMPORTING attributes   = l_attributes
        ).

          handle->properties = l_attributes-properties.

          handle->_attach_update70(
          EXPORTING area_name = handle->area_name
                    mode      = attach_mode
          IMPORTING root      = l_root
          CHANGING  wait_time = l_wait_time ).

          IF abap_true = l_attributes-properties-has_versions AND
           handle->_lock IS NOT INITIAL.
* we may need a second try in case of class constructors
            handle->_attach_update70(
            EXPORTING area_name = handle->area_name
                      mode      = attach_mode
            IMPORTING root      = l_root
            CHANGING  wait_time = l_wait_time ).
          ENDIF.

          IF attach_mode = cl_shm_area=>attach_mode_wait AND
           handle->_lock IS INITIAL.

            l_wait_time_per_loop = l_wait_time / 10.
* wait_time_per_loop should be at least 2 * SHMATTACHWRITE_MAXACTIVEWAIT
            IF l_wait_time_per_loop < 2000.
              l_wait_time_per_loop = 2000.
            ELSEIF l_wait_time_per_loop > 300000.
              l_wait_time_per_loop = 300000.
            ENDIF.

            l_wait_time_per_loop_sec = l_wait_time_per_loop / 1000.

            WHILE handle->_lock IS INITIAL.

              IF l_wait_time_per_loop > l_wait_time.
                l_wait_time_per_loop = l_wait_time.
                l_wait_time_per_loop_sec = l_wait_time_per_loop / 1000.
              ENDIF.

              WAIT UP TO l_wait_time_per_loop_sec SECONDS.
              l_wait_time = l_wait_time - l_wait_time_per_loop.

              handle->_attach_update70(
              EXPORTING
                area_name = handle->area_name
                mode      = cl_shm_area=>attach_mode_wait_2nd_try
              IMPORTING
                root      = l_root
              CHANGING
                wait_time = l_wait_time ).

              IF abap_true = l_attributes-properties-has_versions AND
               handle->_lock IS NOT INITIAL.
* we may need a second try in case of class constructors
                handle->_attach_update70(
                EXPORTING
                  area_name = handle->area_name
                  mode      = cl_shm_area=>attach_mode_wait_2nd_try
                IMPORTING
                  root      = l_root
                CHANGING
                  wait_time = l_wait_time ).
              ENDIF.

            ENDWHILE.

          ENDIF.

          handle->root ?= l_root.

*       <
          _trace_service->trin_attach_for_update(
          area_name = area_name
          inst_name = inst_name
          client    = l_client
          mode      = attach_mode
          wait_time = wait_time
        ).

        CLEANUP INTO l_cx.
          _trace_service->trcx_attach_for_update(
          area_name = area_name
          inst_name = inst_name
          client    = l_client
          mode      = attach_mode
          wait_time = wait_time
          cx        = l_cx
        ).
      ENDTRY.

    ENDIF.

    handle->inst_trace_service = _trace_service.
    handle->inst_trace_active  = _trace_active.

  ENDMETHOD.


  METHOD attach_for_write.

    DATA:
    l_attributes             TYPE shma_attributes,
    l_cx                     TYPE REF TO cx_root,
    l_client                 TYPE shm_client,
    l_client_supplied        TYPE abap_bool, "#EC NEEDED
    l_wait_time              TYPE i,
    l_wait_time_per_loop     TYPE i,
    l_wait_time_per_loop_sec TYPE f.

    l_wait_time = wait_time.

* check if tracing should be activated/de-activated
    IF  ( NOT _trace_service IS INITIAL ).
      TRY.
          _trace_active =
          cl_shm_service=>trace_is_variant_active(
            _trace_service->variant-def_name
          ).
        CATCH cx_root. "#EC NO_HANDLER
                     "#EC CATCH_ALL
      ENDTRY.
    ENDIF.


    IF _trace_active = abap_false OR
  _trace_service->variant-attach_for_write = abap_false.

*   >

      CREATE OBJECT handle.

      handle->client    = l_client.
      handle->inst_name = inst_name.

      cl_shm_service=>initialize(
      EXPORTING area_name    = handle->area_name
                client       = l_client
      IMPORTING attributes   = l_attributes
    ).

      handle->properties = l_attributes-properties.

      handle->_attach_write70(
      EXPORTING
        area_name = handle->area_name
        mode      = attach_mode
      CHANGING
        wait_time = l_wait_time ).

      IF attach_mode = cl_shm_area=>attach_mode_wait AND
       handle->_lock IS INITIAL.

        l_wait_time_per_loop = l_wait_time / 10.
* wait_time_per_loop should be at least 2 * SHMATTACHWRITE_MAXACTIVEWAIT
        IF l_wait_time_per_loop < 2000.
          l_wait_time_per_loop = 2000.
        ELSEIF l_wait_time_per_loop > 300000.
          l_wait_time_per_loop = 300000.
        ENDIF.

        l_wait_time_per_loop_sec = l_wait_time_per_loop / 1000.

        WHILE handle->_lock IS INITIAL.

          IF l_wait_time_per_loop > l_wait_time.
            l_wait_time_per_loop = l_wait_time.
            l_wait_time_per_loop_sec = l_wait_time_per_loop / 1000.
          ENDIF.

          WAIT UP TO l_wait_time_per_loop_sec SECONDS.
          l_wait_time = l_wait_time - l_wait_time_per_loop.

          handle->_attach_write70(
          EXPORTING
            area_name = handle->area_name
            mode      = cl_shm_area=>attach_mode_wait_2nd_try
          CHANGING
            wait_time = l_wait_time ).

        ENDWHILE.

      ENDIF.

*   <

    ELSE.

      TRY.

*     >

          CREATE OBJECT handle.

          handle->client    = l_client.
          handle->inst_name = inst_name.

          cl_shm_service=>initialize(
          EXPORTING area_name    = handle->area_name
                    client       = l_client
          IMPORTING attributes   = l_attributes
        ).

          handle->properties = l_attributes-properties.

          handle->_attach_write70(
          EXPORTING
            area_name = handle->area_name
            mode      = attach_mode
          CHANGING
            wait_time = l_wait_time ).

          IF attach_mode = cl_shm_area=>attach_mode_wait AND
           handle->_lock IS INITIAL.

            l_wait_time_per_loop = l_wait_time / 10.
* wait_time_per_loop should be at least 2 * SHMATTACHWRITE_MAXACTIVEWAIT
            IF l_wait_time_per_loop < 2000.
              l_wait_time_per_loop = 2000.
            ELSEIF l_wait_time_per_loop > 300000.
              l_wait_time_per_loop = 300000.
            ENDIF.

            l_wait_time_per_loop_sec = l_wait_time_per_loop / 1000.

            WHILE handle->_lock IS INITIAL.

              IF l_wait_time_per_loop > l_wait_time.
                l_wait_time_per_loop = l_wait_time.
                l_wait_time_per_loop_sec = l_wait_time_per_loop / 1000.
              ENDIF.

              WAIT UP TO l_wait_time_per_loop_sec SECONDS.
              l_wait_time = l_wait_time - l_wait_time_per_loop.

              handle->_attach_write70(
              EXPORTING
                area_name = handle->area_name
                mode      = cl_shm_area=>attach_mode_wait_2nd_try
              CHANGING
                wait_time = l_wait_time ).

            ENDWHILE.

          ENDIF.

*     <

          _trace_service->trin_attach_for_write(
          area_name = area_name
          inst_name = inst_name
          client    = l_client
          mode      = attach_mode
          wait_time = wait_time
        ).
        CLEANUP INTO l_cx.
          _trace_service->trcx_attach_for_write(
          area_name = area_name
          inst_name = inst_name
          client    = l_client
          mode      = attach_mode
          wait_time = wait_time
          cx        = l_cx
        ).
      ENDTRY.

    ENDIF.

    handle->inst_trace_service = _trace_service.
    handle->inst_trace_active  = _trace_active.

  ENDMETHOD.


  METHOD build.

    DATA:
    l_cls_name TYPE shm_auto_build_class_name,
    l_cx TYPE REF TO cx_root.

    IF _trace_active = abap_false OR
  _trace_service->variant-build = abap_false.

*   >
      l_cls_name =
      cl_shm_service=>get_auto_build_class_name( area_name ).

      CALL METHOD (l_cls_name)=>if_shm_build_instance~build
      EXPORTING
        inst_name = inst_name.
*   <

    ELSE.

      TRY.

*       >
          l_cls_name =
          cl_shm_service=>get_auto_build_class_name( area_name ).

          CALL METHOD (l_cls_name)=>if_shm_build_instance~build
          EXPORTING
            inst_name = inst_name.
*       <
          _trace_service->trin_build(
          area_name         = area_name
          inst_name         = inst_name
        ).

        CLEANUP INTO l_cx.
          _trace_service->trcx_build(
          area_name         = area_name
          inst_name         = inst_name
          cx                = l_cx
        ).
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD class_constructor.

* TRACE { DO NOT REMOVE THIS LINE !
    _trace_active = abap_false.
    TRY.
        _trace_service =
        cl_shm_service=>trace_get_service( area_name ).
        IF NOT _trace_service IS INITIAL.
          _trace_active =
          cl_shm_service=>trace_is_variant_active(
            _trace_service->variant-def_name
          ).
        ENDIF.
      CATCH cx_root. "#EC NO_HANDLER
                   "#EC CATCH_ALL
    ENDTRY.
* TRACE } DO NOT REMOVE THIS LINE !

  ENDMETHOD.


  METHOD detach_area.

    DATA:
    l_client TYPE shm_client,
    l_client_supplied TYPE abap_bool VALUE abap_false.


* >
    rc = _detach_area71( area_name        = area_name
                       client           = l_client
                       client_supplied  = l_client_supplied
                       client_dependent = _client_dependent
                       life_context     = _life_context
       ).
* <

    IF _trace_active = abap_true.
      IF _trace_service->variant-detach_area = abap_true.
        _trace_service->trin_detach_area(
        area_name = area_name
        client    = l_client
        rc        = rc
      ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD free_area.

    DATA:
    l_client TYPE shm_client,
    l_client_supplied TYPE abap_bool VALUE abap_false.

    CONSTANTS: affect_server TYPE shm_affect_server
             VALUE cl_shm_area=>affect_local_server.


* >
    rc = _free_area71( area_name         = area_name
                     client            = l_client
                     client_supplied   = l_client_supplied
                     client_dependent  = _client_dependent
                     transactional     = _transactional
                     terminate_changer = terminate_changer
                     affect_server     = affect_server
                     life_context      = _life_context ).
* <

    IF _trace_active = abap_true.
      IF _trace_service->variant-free_area = abap_true.
        _trace_service->trin_free_area(
      area_name         = area_name
      client            = l_client
      terminate_changer = terminate_changer
      affect_server     = affect_server
      rc                = rc
    ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD free_instance.

    DATA:
    l_client TYPE shm_client,
    l_client_supplied TYPE abap_bool VALUE abap_false.

    CONSTANTS: affect_server TYPE shm_affect_server
             VALUE cl_shm_area=>affect_local_server.


* >
    rc = _free_instance71( area_name         = area_name
                         inst_name         = inst_name
                         client            = l_client
                         client_supplied   = l_client_supplied
                         client_dependent  = _client_dependent
                         transactional     = _transactional
                         terminate_changer = terminate_changer
                         affect_server     = affect_server
                         life_context      = _life_context ).
* <

    IF _trace_active = abap_true.
      IF _trace_service->variant-free_instance = abap_true.
        _trace_service->trin_free_instance(
        area_name         = area_name
        inst_name         = inst_name
        client            = l_client
        terminate_changer = terminate_changer
        affect_server     = affect_server
        rc                = rc
      ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_generator_version.
    generator_version = _version_.
  ENDMETHOD.


  METHOD get_instance_infos.

    DATA:
    l_client             TYPE shm_client,
    l_client_supplied    TYPE abap_bool VALUE abap_false,
    l_inst_name_supplied TYPE abap_bool VALUE abap_false.


    IF inst_name IS SUPPLIED.
      l_inst_name_supplied = abap_true.
    ENDIF.

* >
    TRY.
        CALL METHOD ('_GET_INSTANCE_INFOS804')
        EXPORTING
          area_name          = area_name
          client             = l_client
          client_supplied    = l_client_supplied
          client_dependent   = _client_dependent
          life_context       = _life_context
          inst_name          = inst_name
          inst_name_supplied = l_inst_name_supplied
        RECEIVING
          infos              = infos.
      CATCH cx_sy_dyn_call_illegal_method.
*     New kernel and/or new basis SP missing -> use slow fallback
        infos = _get_instance_infos71(
                area_name        = area_name
                client           = l_client
                client_supplied  = l_client_supplied
                client_dependent = _client_dependent
                life_context     = _life_context
              ).
        IF abap_true = l_inst_name_supplied.
          DELETE infos WHERE name <> inst_name.
        ENDIF.
    ENDTRY.
* <

    IF _trace_active = abap_true.
      IF _trace_service->variant-get_instance_inf = abap_true.
        _trace_service->trin_get_instance_infos(
        area_name         = area_name
        inst_name         = inst_name
        client            = l_client
        infos             = infos
      ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_root.

    DATA:
    l_cx        TYPE REF TO cx_root,
    l_area_name TYPE string,
    l_inst_name TYPE string,
    l_client    TYPE string.

    IF _trace_active = abap_false OR
  _trace_service->variant-get_root = abap_false.

*   >
      IF is_valid( ) = abap_false.
        l_area_name = me->area_name.
        l_inst_name = me->inst_name.
        l_client    = me->client.
        RAISE EXCEPTION TYPE cx_shm_already_detached
        EXPORTING
          area_name = l_area_name
          inst_name = l_inst_name
          client    = l_client.
      ENDIF.
      root = me->root.
*   <

    ELSE.

      TRY.

*       >
          IF is_valid( ) = abap_false.
            l_area_name = me->area_name.
            l_inst_name = me->inst_name.
            l_client    = me->client.
            RAISE EXCEPTION TYPE cx_shm_already_detached
            EXPORTING
              area_name = l_area_name
              inst_name = l_inst_name
              client    = l_client.
          ENDIF.
          root = me->root.
*       <

          _trace_service->trin_get_root(
          area_name = area_name
        ).

        CLEANUP INTO l_cx.
          _trace_service->trcx_get_root(
          area_name = area_name
          cx        = l_cx
        ).
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD invalidate_area.

    DATA:
    l_client TYPE shm_client,
    l_client_supplied TYPE abap_bool VALUE abap_false.

    CONSTANTS: affect_server TYPE shm_affect_server
             VALUE cl_shm_area=>affect_local_server.


* >
    rc = _invalidate_area71( area_name         = area_name
                           client            = l_client
                           client_supplied   = l_client_supplied
                           client_dependent  = _client_dependent
                           transactional     = _transactional
                           terminate_changer = terminate_changer
                           affect_server     = affect_server
                           life_context      = _life_context ).
* <

    IF _trace_active = abap_true.
      IF _trace_service->variant-invalidate_area = abap_true.
        _trace_service->trin_invalidate_area(
        area_name         = area_name
        client            = l_client
        terminate_changer = terminate_changer
        affect_server     = affect_server
        rc                = rc
      ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD invalidate_instance.

    DATA:
    l_client TYPE shm_client,
    l_client_supplied TYPE abap_bool VALUE abap_false.

    CONSTANTS: affect_server TYPE shm_affect_server
             VALUE cl_shm_area=>affect_local_server.


* >
    rc = _invalidate_instance71(
    area_name         = area_name
    inst_name         = inst_name
    client            = l_client
    client_supplied   = l_client_supplied
    client_dependent  = _client_dependent
    transactional     = _transactional
    terminate_changer = terminate_changer
    affect_server     = affect_server
    life_context      = _life_context
  ).
* <

    IF _trace_active = abap_true.
      IF _trace_service->variant-invalidate_inst = abap_true.
        _trace_service->trin_invalidate_instance(
        area_name         = area_name
        inst_name         = inst_name
        client            = l_client
        terminate_changer = terminate_changer
        affect_server     = affect_server
        rc                = rc
      ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD set_root.

    DATA:
    l_cx TYPE REF TO cx_root.

    IF _trace_active = abap_false OR
  _trace_service->variant-set_root = abap_false.

*   >
      _set_root( root ).
      me->root = root.
*   <

    ELSE.

      TRY.

*       >
          _set_root( root ).
          me->root = root.
*       <
          _trace_service->trin_set_root(
          area_name         = area_name
          inst_name         = inst_name
          root              = root
        ).

        CLEANUP INTO l_cx.
          _trace_service->trcx_set_root(
          area_name         = area_name
          inst_name         = inst_name
          root              = root
          cx                = l_cx
        ).
      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.