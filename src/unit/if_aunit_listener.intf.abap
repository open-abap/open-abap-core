INTERFACE if_aunit_listener PUBLIC.
  METHODS task_start
    IMPORTING
      info TYPE REF TO if_aunit_info_step_start_task.

  METHODS task_end
    IMPORTING
      info TYPE REF TO if_aunit_info_step_end.

  METHODS program_start
    IMPORTING
      info TYPE REF TO if_aunit_info_step.

  METHODS program_end
    IMPORTING
      info TYPE REF TO if_aunit_info_step_end.

  METHODS class_start
    IMPORTING
      info TYPE REF TO if_aunit_info_step.

  METHODS class_end
    IMPORTING
      info TYPE REF TO if_aunit_info_step_end.

  METHODS method_start
    IMPORTING
      info TYPE REF TO if_aunit_info_step.

  METHODS method_end
    IMPORTING
      info TYPE REF TO if_aunit_info_step_end.

  METHODS assert_failure
    IMPORTING
      failure TYPE REF TO if_aunit_info_failure.

  METHODS cx_failure
    IMPORTING
      failure TYPE REF TO if_aunit_info_failure.

  METHODS rt_failure
    IMPORTING
      failure TYPE REF TO if_aunit_info_failure.

  METHODS warning
    IMPORTING
      warning TYPE REF TO if_aunit_info_failure.

  METHODS execution_event
    IMPORTING
      event TYPE REF TO if_aunit_info_message.
ENDINTERFACE.
