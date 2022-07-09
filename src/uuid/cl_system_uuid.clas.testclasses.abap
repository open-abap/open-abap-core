CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS create_uuid_c36_by_version FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_x16 FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD create_uuid_c36_by_version.
    cl_abap_unit_assert=>assert_not_initial( cl_system_uuid=>if_system_uuid_rfc4122_static~create_uuid_c36_by_version( 4 ) ).
  ENDMETHOD.

  METHOD create_uuid_x16.
    cl_abap_unit_assert=>assert_not_initial( cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ) ).
  ENDMETHOD.

ENDCLASS.