INTERFACE if_aunit_auth_check_controller PUBLIC.
  METHODS restrict_authorizations_to
    IMPORTING
      auth_objset         TYPE REF TO if_aunit_authority_objset
      test_abort_behavior TYPE cl_aunit_auth_check_types_def=>test_abort_behavior OPTIONAL
    RAISING
      cx_abap_auth_check_exception.

  METHODS authorizations_expected_to
    IMPORTING
      pass_execution TYPE REF TO if_aunit_authority_objset
      fail_execution TYPE REF TO if_aunit_authority_objset OPTIONAL
    RAISING
      cx_abap_auth_check_exception.

  METHODS assert_expectations.

  METHODS check_expectations
    EXPORTING
      failed_expectations TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs
    RETURNING
      VALUE(check_passed) TYPE abap_bool.

  METHODS get_auth_check_execution_log
    RETURNING
      VALUE(execution_log) TYPE REF TO if_aunit_auth_check_result_log.

  METHODS reset.
ENDINTERFACE.
