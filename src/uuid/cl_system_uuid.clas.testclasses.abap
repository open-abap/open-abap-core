CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS create_uuid_c36_by_version FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_x16 FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_c32 FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_c36 FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_c32_dyn FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD create_uuid_c36_by_version.
    cl_abap_unit_assert=>assert_not_initial( cl_system_uuid=>if_system_uuid_rfc4122_static~create_uuid_c36_by_version( 4 ) ).
  ENDMETHOD.

  METHOD create_uuid_x16.
    cl_abap_unit_assert=>assert_not_initial( cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ) ).
  ENDMETHOD.

  METHOD create_uuid_c32.
    cl_abap_unit_assert=>assert_not_initial( cl_system_uuid=>if_system_uuid_static~create_uuid_c32( ) ).
  ENDMETHOD.

  METHOD create_uuid_c36.
    cl_abap_unit_assert=>assert_not_initial( cl_system_uuid=>if_system_uuid_static~create_uuid_c36( ) ).
  ENDMETHOD.

  METHOD create_uuid_c32_dyn.
    " DATA uuid TYPE c LENGTH 32.
    " CALL METHOD (`CL_SYSTEM_UUID`)=>create_uuid_c32_static
    "   RECEIVING
    "     uuid = uuid.
    " cl_abap_unit_assert=>assert_not_initial( uuid ).
  ENDMETHOD.

ENDCLASS.