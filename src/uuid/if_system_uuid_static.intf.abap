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
ENDINTERFACE.