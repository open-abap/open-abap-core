CLASS cl_abap_memory_utilities DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_memory_size_of_object
      IMPORTING
        object                     TYPE any
      EXPORTING
        bound_size_alloc           TYPE abap_msize
        bound_size_used            TYPE abap_msize
        referenced_size_alloc      TYPE abap_msize
        referenced_size_used       TYPE abap_msize
        is_part_of_non_trivial_szk TYPE c
        szk_size_alloc             TYPE abap_msize
        szk_size_used              TYPE abap_msize
        low_mem                    TYPE c
        is_in_shared_memory        TYPE c
        sizeof_alloc               TYPE abap_msize
        sizeof_used                TYPE abap_msize.

    CLASS-METHODS get_peak_used_size
      EXPORTING
        size TYPE abap_msize.

    CLASS-METHODS get_total_used_size
      EXPORTING
        size TYPE abap_msize.

    CLASS-METHODS do_garbage_collection.
ENDCLASS.

CLASS cl_abap_memory_utilities IMPLEMENTATION.
  METHOD get_total_used_size.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD do_garbage_collection.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD get_peak_used_size.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD get_memory_size_of_object.
    RETURN. " todo, implement method
  ENDMETHOD.

ENDCLASS.