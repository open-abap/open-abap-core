INTERFACE if_aunit_auth_check_result_log PUBLIC.
  METHODS get_execution_status
    EXPORTING
      passed_execution TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs
      failed_execution TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.

  METHODS get_failed_expectations
    EXPORTING
      expected_to_pass_but_failed   TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs
      expected_to_fail_but_passed   TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs
      expected_to_pass_not_executed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs
      expected_to_fail_not_executed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.

  METHODS get_unexpected_executions
    EXPORTING
      passed_but_not_expected TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs
      failed_but_not_expected TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
ENDINTERFACE.
