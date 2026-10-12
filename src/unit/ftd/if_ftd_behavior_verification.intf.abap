INTERFACE if_ftd_behavior_verification PUBLIC.

  METHODS is_called_times
    IMPORTING
      times TYPE i.

  METHODS is_called_once.

  METHODS is_never_called.

  METHODS is_called_at_least
    IMPORTING
      times TYPE i.

  METHODS is_called_at_least_once.

  METHODS is_called_at_most
    IMPORTING
      times TYPE i.

  METHODS is_called_at_most_once.

ENDINTERFACE.