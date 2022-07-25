CLASS cl_cam_address_bcs DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-METHODS create_internet_address
      IMPORTING
        i_address_string TYPE clike
        i_address_name   TYPE clike OPTIONAL
        i_incl_sapuser   TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO cl_cam_address_bcs
      RAISING
        cx_bcs.

ENDCLASS.

CLASS cl_cam_address_bcs IMPLEMENTATION.

  METHOD create_internet_address.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.