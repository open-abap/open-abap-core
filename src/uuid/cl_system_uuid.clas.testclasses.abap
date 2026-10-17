CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS create_uuid_c36_by_version FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_x16 FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_c32 FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_c36 FOR TESTING RAISING cx_static_check.
    METHODS create_uuid_c32_dyn FOR TESTING RAISING cx_static_check.
    METHODS convert_c32 FOR TESTING RAISING cx_static_check.
    METHODS convert_c22 FOR TESTING RAISING cx_static_check.
    METHODS convert_c36 FOR TESTING RAISING cx_static_check.
    METHODS convert_x16 FOR TESTING RAISING cx_static_check.
    METHODS convert_c32_lower_case FOR TESTING RAISING cx_static_check.
    METHODS convert_c22_round_trip FOR TESTING RAISING cx_static_check.
    METHODS convert_c22_invalid_char FOR TESTING RAISING cx_static_check.
    METHODS convert_c22_padding FOR TESTING RAISING cx_static_check.
    METHODS convert_c32_not_hex FOR TESTING RAISING cx_static_check.
    METHODS convert_c36_no_dashes FOR TESTING RAISING cx_static_check.
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

* sample from the SAP documentation of the 22 character form
  METHOD convert_c32.
    DATA lv_x16 TYPE sysuuid_x16.
    DATA lv_c22 TYPE sysuuid_c22.
    DATA lv_c36 TYPE sysuuid_c36.
    cl_system_uuid=>convert_uuid_c32_static(
      EXPORTING
        uuid     = '12837204B4991EDC9FC0675639081656'
      IMPORTING
        uuid_x16 = lv_x16
        uuid_c22 = lv_c22
        uuid_c36 = lv_c36 ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_x16
      exp = '12837204B4991EDC9FC0675639081656' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c22
      exp = '4eDo1BIP7joVm6TMEGWMLW' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c36
      exp = '12837204-B499-1EDC-9FC0-675639081656' ).
  ENDMETHOD.

  METHOD convert_c22.
    DATA lv_x16 TYPE sysuuid_x16.
    DATA lv_c32 TYPE sysuuid_c32.
    DATA lv_c36 TYPE sysuuid_c36.
    cl_system_uuid=>convert_uuid_c22_static(
      EXPORTING
        uuid     = '4eDo1BIP7joVm6TMEGWMLW'
      IMPORTING
        uuid_x16 = lv_x16
        uuid_c32 = lv_c32
        uuid_c36 = lv_c36 ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_x16
      exp = '12837204B4991EDC9FC0675639081656' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c32
      exp = '12837204B4991EDC9FC0675639081656' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c36
      exp = '12837204-B499-1EDC-9FC0-675639081656' ).
  ENDMETHOD.

  METHOD convert_c36.
    DATA lv_x16 TYPE sysuuid_x16.
    DATA lv_c22 TYPE sysuuid_c22.
    DATA lv_c32 TYPE sysuuid_c32.
    cl_system_uuid=>convert_uuid_c36_static(
      EXPORTING
        uuid     = '12837204-B499-1EDC-9FC0-675639081656'
      IMPORTING
        uuid_x16 = lv_x16
        uuid_c22 = lv_c22
        uuid_c32 = lv_c32 ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_x16
      exp = '12837204B4991EDC9FC0675639081656' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c22
      exp = '4eDo1BIP7joVm6TMEGWMLW' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c32
      exp = '12837204B4991EDC9FC0675639081656' ).
  ENDMETHOD.

  METHOD convert_x16.
    DATA lv_x16 TYPE sysuuid_x16.
    DATA lv_c22 TYPE sysuuid_c22.
    DATA lv_c32 TYPE sysuuid_c32.
    DATA lv_c36 TYPE sysuuid_c36.
    lv_x16 = '12837204B4991EDC9FC0675639081656'.
    cl_system_uuid=>convert_uuid_x16_static(
      EXPORTING
        uuid     = lv_x16
      IMPORTING
        uuid_c22 = lv_c22
        uuid_c32 = lv_c32
        uuid_c36 = lv_c36 ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c22
      exp = '4eDo1BIP7joVm6TMEGWMLW' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c32
      exp = '12837204B4991EDC9FC0675639081656' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_c36
      exp = '12837204-B499-1EDC-9FC0-675639081656' ).
  ENDMETHOD.

  METHOD convert_c32_lower_case.
    DATA lv_x16 TYPE sysuuid_x16.
    cl_system_uuid=>convert_uuid_c32_static(
      EXPORTING
        uuid     = '12837204b4991edc9fc0675639081656'
      IMPORTING
        uuid_x16 = lv_x16 ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_x16
      exp = '12837204B4991EDC9FC0675639081656' ).
  ENDMETHOD.

  METHOD convert_c22_round_trip.
    DATA lv_c22  TYPE sysuuid_c22.
    DATA lv_back TYPE sysuuid_c32.
    DATA lv_c32  TYPE sysuuid_c32.
    lv_c32 = cl_system_uuid=>create_uuid_c32_static( ).
    cl_system_uuid=>convert_uuid_c32_static(
      EXPORTING
        uuid     = lv_c32
      IMPORTING
        uuid_c22 = lv_c22 ).
    cl_system_uuid=>convert_uuid_c22_static(
      EXPORTING
        uuid     = lv_c22
      IMPORTING
        uuid_c32 = lv_back ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_back
      exp = lv_c32 ).
  ENDMETHOD.

  METHOD convert_c22_invalid_char.
    TRY.
        cl_system_uuid=>convert_uuid_c22_static( '!!!!!!!!!!!!!!!!!!!!!!' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_uuid_error.
    ENDTRY.
  ENDMETHOD.

  METHOD convert_c22_padding.
* the last character carries four padding bits, which must be zero
    TRY.
        cl_system_uuid=>convert_uuid_c22_static( '4eDo1BIP7joVm6TMEGWMLX' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_uuid_error.
    ENDTRY.
  ENDMETHOD.

  METHOD convert_c32_not_hex.
    TRY.
        cl_system_uuid=>convert_uuid_c32_static( 'G2837204B4991EDC9FC0675639081656' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_uuid_error.
    ENDTRY.
  ENDMETHOD.

  METHOD convert_c36_no_dashes.
    TRY.
        cl_system_uuid=>convert_uuid_c36_static( '12837204 B499 1EDC 9FC0 675639081656' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_uuid_error.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
