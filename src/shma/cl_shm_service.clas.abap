CLASS cl_shm_service DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS initialize
      IMPORTING
        area_name  TYPE shm_area_name
        client     TYPE shma_client OPTIONAL
      EXPORTING
        attributes TYPE shma_attributes.

    CLASS-METHODS get_auto_build_class_name
      IMPORTING
        area_name                    TYPE shm_area_name
      RETURNING
        VALUE(auto_build_class_name) TYPE shm_auto_build_class_name
      RAISING
        cx_shma_not_configured
        cx_shma_inconsistent.

    CLASS-METHODS trace_get_service
      IMPORTING
        !area_name           TYPE shm_area_name OPTIONAL
      RETURNING
        VALUE(trace_service) TYPE REF TO if_shm_trace.

    CLASS-METHODS trace_is_variant_active
      IMPORTING
        service_name     TYPE shmm_trc_variant_name
      RETURNING
        VALUE(is_active) TYPE abap_bool.

ENDCLASS.

CLASS cl_shm_service IMPLEMENTATION.

  METHOD initialize.
    RETURN.
  ENDMETHOD.

  METHOD get_auto_build_class_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD trace_get_service.
* dont dump, this method is called from area CLASS_CONSTRUCTORs
    RETURN.
  ENDMETHOD.

  METHOD trace_is_variant_active.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.