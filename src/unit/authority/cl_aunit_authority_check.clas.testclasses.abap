CLASS ltcl_authority_check DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    DATA mi_controller TYPE REF TO if_aunit_auth_check_controller.

    METHODS setup.
    METHODS teardown.
    METHODS unrestricted_check FOR TESTING.
    METHODS restrict_values FOR TESTING RAISING cx_static_check.
    METHODS execution_log FOR TESTING RAISING cx_static_check.
    METHODS expectations_met FOR TESTING RAISING cx_static_check.
    METHODS expectations_missing FOR TESTING RAISING cx_static_check.

    METHODS create_set
      IMPORTING value         TYPE csequence
      RETURNING VALUE(result) TYPE REF TO if_aunit_authority_objset.

    METHODS call_check
      IMPORTING value         TYPE csequence
      RETURNING VALUE(result) TYPE sysubrc.
ENDCLASS.

CLASS ltcl_authority_check IMPLEMENTATION.
  METHOD setup.
    mi_controller = cl_aunit_authority_check=>get_controller( ).
    mi_controller->reset( ).
  ENDMETHOD.

  METHOD teardown.
    mi_controller->reset( ).
  ENDMETHOD.

  METHOD unrestricted_check.
    AUTHORITY-CHECK OBJECT 'ZAUTH_TEST'
      ID 'ACTVT' FIELD '01'.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD restrict_values.
    DATA lv_subrc TYPE sysubrc.

    mi_controller->restrict_authorizations_to( create_set( '03' ) ).

    lv_subrc = call_check( '03' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_subrc
      exp = 0 ).

    lv_subrc = call_check( '01' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_subrc
      exp = 4 ).

    AUTHORITY-CHECK OBJECT 'ZAUTH_TEST'
      ID 'ACTVT' FIELD '03'
      ID 'IGNORED' DUMMY.
    cl_abap_unit_assert=>assert_subrc( ).

    AUTHORITY-CHECK OBJECT 'ZAUTH_TEST'
      ID 'ACTVT' FIELD '03'
      ID 'OTHER' FIELD 'X'.
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).
  ENDMETHOD.

  METHOD execution_log.
    DATA lt_passed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA lt_failed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA lv_subrc TYPE sysubrc.

    mi_controller->restrict_authorizations_to( create_set( '03' ) ).
    lv_subrc = call_check( '03' ).
    lv_subrc = call_check( '01' ).

    mi_controller->get_auth_check_execution_log( )->get_execution_status(
      IMPORTING
        passed_execution = lt_passed
        failed_execution = lt_failed ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_passed )
      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_failed )
      exp = 1 ).
  ENDMETHOD.

  METHOD expectations_met.
    DATA lt_failures TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA lv_subrc TYPE sysubrc.

    mi_controller->restrict_authorizations_to( create_set( '03' ) ).
    mi_controller->authorizations_expected_to(
      pass_execution = create_set( '03' )
      fail_execution = create_set( '01' ) ).
    lv_subrc = call_check( '03' ).
    lv_subrc = call_check( '01' ).

    cl_abap_unit_assert=>assert_true(
      mi_controller->check_expectations(
        IMPORTING failed_expectations = lt_failures ) ).
    cl_abap_unit_assert=>assert_initial( lt_failures ).
  ENDMETHOD.

  METHOD expectations_missing.
    DATA lt_failures TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.

    mi_controller->restrict_authorizations_to( create_set( '03' ) ).
    mi_controller->authorizations_expected_to( create_set( '03' ) ).

    cl_abap_unit_assert=>assert_false(
      mi_controller->check_expectations(
        IMPORTING failed_expectations = lt_failures ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_failures )
      exp = 1 ).
  ENDMETHOD.

  METHOD create_set.
    DATA lt_roles TYPE cl_aunit_auth_check_types_def=>role_auth_objects.
    DATA ls_role LIKE LINE OF lt_roles.
    DATA lt_authorizations TYPE cl_aunit_auth_check_types_def=>authorizations.
    DATA lt_authorization TYPE cl_aunit_auth_check_types_def=>authorization.
    DATA ls_field TYPE cl_aunit_auth_check_types_def=>authfield_values.
    DATA ls_interval LIKE LINE OF ls_field-fieldvalues.
    DATA lt_user_roles TYPE cl_aunit_auth_check_types_def=>user_role_authorizations.
    DATA ls_user_role LIKE LINE OF lt_user_roles.

    ls_interval-lower_value = value.
    APPEND ls_interval TO ls_field-fieldvalues.
    ls_field-fieldname = 'ACTVT'.
    INSERT ls_field INTO TABLE lt_authorization.
    APPEND lt_authorization TO lt_authorizations.
    ls_role-object = 'ZAUTH_TEST'.
    ls_role-authorizations = lt_authorizations.
    APPEND ls_role TO lt_roles.
    ls_user_role-role_authorizations = lt_roles.
    APPEND ls_user_role TO lt_user_roles.
    result = cl_aunit_authority_check=>create_auth_object_set( lt_user_roles ).
  ENDMETHOD.

  METHOD call_check.
    AUTHORITY-CHECK OBJECT 'ZAUTH_TEST'
      ID 'ACTVT' FIELD value.
    result = sy-subrc.
  ENDMETHOD.
ENDCLASS.
