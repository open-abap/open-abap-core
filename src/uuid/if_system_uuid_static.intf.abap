INTERFACE if_system_uuid_static PUBLIC.
  CLASS-METHODS create_uuid_x16
    RETURNING
      VALUE(uuid) TYPE sysuuid_x16
    RAISING
      cx_uuid_error.
ENDINTERFACE.