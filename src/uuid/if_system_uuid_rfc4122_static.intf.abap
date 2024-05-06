INTERFACE if_system_uuid_rfc4122_static PUBLIC.
  CLASS-METHODS create_uuid_c36_by_version
    IMPORTING
      version     TYPE i
    RETURNING
      VALUE(uuid) TYPE sysuuid_c36
    RAISING
      cx_uuid_error.
ENDINTERFACE.