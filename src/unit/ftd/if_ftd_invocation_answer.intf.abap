INTERFACE if_ftd_invocation_answer PUBLIC.

  METHODS answer
    IMPORTING
      arguments TYPE REF TO if_ftd_input_arguments
    CHANGING
      result    TYPE REF TO if_ftd_invocation_result.

ENDINTERFACE.