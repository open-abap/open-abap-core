CLASS cl_shm_area DEFINITION PUBLIC INHERITING FROM cx_shm_general_error.
  PUBLIC SECTION.
    CONSTANTS default_instance TYPE shm_inst_name VALUE '$DEFAULT_INSTANCE$'.
    CONSTANTS invocation_mode_explicit TYPE shm_constr_invocation_mode VALUE 319200300.
    CONSTANTS life_context_appserver TYPE shm_life_context VALUE 109200001.
    CONSTANTS attach_mode_default TYPE shm_attach_mode VALUE 1302197000 .
ENDCLASS.

CLASS cl_shm_area IMPLEMENTATION.

ENDCLASS.