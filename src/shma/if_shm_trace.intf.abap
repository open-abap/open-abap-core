INTERFACE if_shm_trace PUBLIC.

  DATA: BEGIN OF variant,
          def_name         TYPE shmm_trc_variant_name,
          attach_for_upd   TYPE abap_bool,
          attach_for_read  TYPE abap_bool,
          free_area        TYPE abap_bool,
          detach_area      TYPE abap_bool,
          set_root         TYPE abap_bool,
          invalidate_inst  TYPE abap_bool,
          get_instance_inf TYPE abap_bool,
          free_instance    TYPE abap_bool,
          invalidate_area  TYPE abap_bool,
          build            TYPE abap_bool,
          attach_for_write TYPE abap_bool,
        END OF variant.

  METHODS trin_attach_for_write
    IMPORTING
      area_name TYPE shm_area_name
      inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      client    TYPE shm_client DEFAULT sy-mandt
      mode      TYPE shm_attach_mode DEFAULT cl_shm_area=>attach_mode_default
      wait_time TYPE i DEFAULT 0.
 
  METHODS trcx_attach_for_write
    IMPORTING
      area_name TYPE shm_area_name
      inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      client    TYPE shm_client DEFAULT sy-mandt
      mode      TYPE shm_attach_mode DEFAULT cl_shm_area=>attach_mode_default
      wait_time TYPE i DEFAULT 0
      cx        TYPE REF TO cx_root.

  METHODS trin_attach_for_update
    IMPORTING
      area_name TYPE shm_area_name
      inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      client    TYPE shm_client DEFAULT sy-mandt
      mode      TYPE shm_attach_mode DEFAULT cl_shm_area=>attach_mode_default
      wait_time TYPE i DEFAULT 0.

  METHODS trcx_attach_for_update
    IMPORTING
      area_name TYPE shm_area_name
      inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      client    TYPE shm_client DEFAULT sy-mandt
      mode      TYPE shm_attach_mode DEFAULT cl_shm_area=>attach_mode_default
      wait_time TYPE i DEFAULT 0
      cx        TYPE REF TO cx_root.

  METHODS trin_attach_for_read
    IMPORTING
      area_name TYPE shm_area_name
      inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      client    TYPE shm_client DEFAULT sy-mandt.

  METHODS trcx_attach_for_read
    IMPORTING
      area_name TYPE shm_area_name
      inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      client    TYPE shm_client DEFAULT sy-mandt
      cx        TYPE REF TO cx_root.

  METHODS trin_build
    IMPORTING
      area_name TYPE shm_area_name
      inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance.

  METHODS trcx_build
    IMPORTING
      area_name TYPE shm_area_name
      inst_name TYPE shm_inst_name DEFAULT cl_shm_area=>default_instance
      cx TYPE REF TO cx_root.

ENDINTERFACE.