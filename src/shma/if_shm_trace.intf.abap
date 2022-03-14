INTERFACE if_shm_trace PUBLIC.

  DATA: BEGIN OF variant,
          def_name TYPE c LENGTH 32,
          attach_for_upd TYPE abap_bool,
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

ENDINTERFACE.