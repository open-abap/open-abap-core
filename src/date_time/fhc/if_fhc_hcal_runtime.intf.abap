INTERFACE if_fhc_hcal_runtime PUBLIC.

  TYPES ty_fhc_date TYPE d.
  TYPES ty_fhc_description TYPE c LENGTH 255.
  TYPES ty_fhc_hcalid TYPE c LENGTH 32.
  TYPES ty_fhc_t_hol_if TYPE STANDARD TABLE OF REF TO if_fhc_holiday_runtime WITH DEFAULT KEY.
  TYPES:
    BEGIN OF ts_holiday_occurrence,
      date              TYPE ty_fhc_date,
      holiday_reference TYPE REF TO if_fhc_holiday_runtime,
    END OF ts_holiday_occurrence.
  TYPES tt_holiday_occurrences TYPE STANDARD TABLE OF ts_holiday_occurrence WITH DEFAULT KEY.

  METHODS is_holiday
    IMPORTING
      iv_date           TYPE ty_fhc_date
    RETURNING
      VALUE(rv_holiday) TYPE abap_bool.

  METHODS get_holiday
    IMPORTING
      iv_date                   TYPE ty_fhc_date
    RETURNING
      VALUE(ro_holiday_runtime) TYPE REF TO if_fhc_holiday_runtime
    RAISING
      cx_fhc_runtime.

  METHODS calc_holidays_between_dates
    IMPORTING
      iv_start    TYPE ty_fhc_date
      iv_end      TYPE ty_fhc_date
    EXPORTING
      et_holidays TYPE tt_holiday_occurrences
    RAISING
      cx_fhc_runtime.

  METHODS get_validity_start
    RETURNING
      VALUE(rv_validity_start) TYPE ty_fhc_date.

  METHODS get_validity_end
    RETURNING
      VALUE(rv_validity_end) TYPE ty_fhc_date.

  METHODS get_description
    IMPORTING
      iv_language           TYPE spras DEFAULT sy-langu
    RETURNING
      VALUE(rv_description) TYPE ty_fhc_description.

  METHODS get_holiday_assignments
    RETURNING
      VALUE(rt_holidays) TYPE ty_fhc_t_hol_if
    RAISING
      cx_fhc_runtime.

  METHODS get_id
    RETURNING
      VALUE(rv_id) TYPE ty_fhc_hcalid.

ENDINTERFACE.
