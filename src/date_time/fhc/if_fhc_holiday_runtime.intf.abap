INTERFACE if_fhc_holiday_runtime PUBLIC.

  TYPES ty_fhc_holid TYPE c LENGTH 32.
  TYPES ty_fhc_holtype TYPE c LENGTH 1.
  TYPES ty_fhc_class TYPE c LENGTH 1.
  TYPES ty_fhc_confession TYPE c LENGTH 2.

  METHODS get_holiday_id
    RETURNING
      VALUE(rv_id) TYPE ty_fhc_holid.

  METHODS get_type
    RETURNING
      VALUE(rv_type) TYPE ty_fhc_holtype.

  METHODS get_class
    RETURNING
      VALUE(rv_class) TYPE ty_fhc_class.

  METHODS get_confession
    RETURNING
      VALUE(rv_confession) TYPE ty_fhc_confession.

ENDINTERFACE.
