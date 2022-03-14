INTERFACE if_shm_build_instance PUBLIC.
  CLASS-METHODS build
    IMPORTING
      inst_name       TYPE shm_inst_name              DEFAULT cl_shm_area=>default_instance
      invocation_mode TYPE shm_constr_invocation_mode DEFAULT cl_shm_area=>invocation_mode_explicit
    RAISING
      cx_shm_build_failed.
ENDINTERFACE.