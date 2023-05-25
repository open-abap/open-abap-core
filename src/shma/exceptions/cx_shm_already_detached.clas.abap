CLASS cx_shm_already_detached DEFINITION PUBLIC INHERITING FROM cx_shm_general_error.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid    LIKE textid OPTIONAL
        previous  LIKE previous OPTIONAL
        area_name TYPE string OPTIONAL
        inst_name TYPE string OPTIONAL
        client    TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_shm_already_detached IMPLEMENTATION.

  METHOD constructor.
    RETURN.
  ENDMETHOD.

ENDCLASS.