CLASS kernel_push_channels DEFINITION PUBLIC.
* handling of ABAP statement WAIT FOR PUSH CHANNELS
  PUBLIC SECTION.
    CLASS-METHODS wait
      IMPORTING
        seconds TYPE i
        cond    TYPE any.
  PRIVATE SECTION.
ENDCLASS.

CLASS kernel_push_channels IMPLEMENTATION.

  METHOD wait.
    DATA lv_seconds   TYPE i.
    DATA lv_condition TYPE abap_bool.

    lv_seconds = seconds * 1000.
    ASSERT lv_seconds > 0.

    WHILE lv_seconds > 0.
      WRITE '@KERNEL await new Promise(resolve => setTimeout(resolve, 100));'.
      WRITE '@KERNEL lv_condition = cond() ? "X" : " ";'.
      IF lv_condition = abap_true.
        sy-subrc = 0.
        RETURN.
      ENDIF.
      lv_seconds = lv_seconds - 100.
    ENDWHILE.

    sy-subrc = 4.
  ENDMETHOD.

ENDCLASS.