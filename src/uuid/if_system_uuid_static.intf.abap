INTERFACE if_system_uuid_static PUBLIC.
  CLASS-METHODS create_uuid_x16
    RETURNING
      VALUE(uuid) TYPE sysuuid_x16
    RAISING
      cx_uuid_error.

  CLASS-METHODS create_uuid_c32
    RETURNING
      VALUE(uuid) TYPE sysuuid_c32
    RAISING
      cx_uuid_error.

  CLASS-METHODS create_uuid_c36
    RETURNING
      VALUE(uuid) TYPE sysuuid_c36
    RAISING
      cx_uuid_error.

  CLASS-METHODS create_uuid_c22
    RETURNING
      VALUE(uuid) TYPE sysuuid_c22
    RAISING
      cx_uuid_error.

  CLASS-METHODS convert_uuid_x16
    IMPORTING
      uuid     TYPE sysuuid_x16
    EXPORTING
      uuid_c22 TYPE sysuuid_c22
      uuid_c32 TYPE sysuuid_c32
*      uuid_c26 TYPE sysuuid_c26
      uuid_c36 TYPE sysuuid_c36
    RAISING
      cx_uuid_error.
ENDINTERFACE.