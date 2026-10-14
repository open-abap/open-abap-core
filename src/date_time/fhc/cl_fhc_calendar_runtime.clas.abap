CLASS cl_fhc_calendar_runtime DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES ty_fcal_id TYPE c LENGTH 32.
    TYPES ty_hcal_id TYPE c LENGTH 32.
    TYPES ty_hol_id TYPE c LENGTH 32.

    CLASS-METHODS create_factorycalendar_runtime
      IMPORTING
        iv_factorycalendar_id  TYPE ty_fcal_id
      RETURNING
        VALUE(ro_fcal_runtime) TYPE REF TO if_fhc_fcal_runtime
      RAISING
        cx_fhc_runtime.

    CLASS-METHODS create_holidaycalendar_runtime
      IMPORTING
        iv_holidaycalendar_id  TYPE ty_hcal_id
      RETURNING
        VALUE(ro_hcal_runtime) TYPE REF TO if_fhc_hcal_runtime
      RAISING
        cx_fhc_runtime.

    CLASS-METHODS create_holiday_runtime
      IMPORTING
        iv_holiday_id             TYPE ty_hol_id
      RETURNING
        VALUE(ro_holiday_runtime) TYPE REF TO if_fhc_holiday_runtime
      RAISING
        cx_fhc_runtime.

ENDCLASS.

CLASS cl_fhc_calendar_runtime IMPLEMENTATION.

  METHOD create_factorycalendar_runtime.
* factory calendars are customizing, there is none off-stack
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD create_holidaycalendar_runtime.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD create_holiday_runtime.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
