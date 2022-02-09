CLASS cl_system_uuid DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_system_uuid_rfc4122_static.
ENDCLASS.

CLASS cl_system_uuid IMPLEMENTATION.

  METHOD if_system_uuid_rfc4122_static~create_uuid_c36_by_version.
    ASSERT version = 4.
    WRITE '@KERNEL const crypto = await import("crypto");'.
    WRITE '@KERNEL uuid.set(crypto.randomUUID());'.
  ENDMETHOD.

ENDCLASS.