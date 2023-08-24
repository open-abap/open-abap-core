CLASS cl_system_uuid DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_system_uuid_rfc4122_static.
    INTERFACES if_system_uuid_static.

    ALIASES create_uuid_c32_static FOR if_system_uuid_static~create_uuid_c32.
    ALIASES create_uuid_x16_static FOR if_system_uuid_static~create_uuid_x16.
ENDCLASS.

CLASS cl_system_uuid IMPLEMENTATION.

  METHOD if_system_uuid_static~create_uuid_x16.
    WRITE '@KERNEL if (cl_system_uuid.CRYPTO === undefined) cl_system_uuid.CRYPTO = await import("crypto");'.
    WRITE '@KERNEL uuid.set(cl_system_uuid.CRYPTO.randomBytes(16).toString("hex").toUpperCase());'.
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_c32.
    WRITE '@KERNEL if (cl_system_uuid.CRYPTO === undefined) cl_system_uuid.CRYPTO = await import("crypto");'.
    WRITE '@KERNEL uuid.set(cl_system_uuid.CRYPTO.randomBytes(16).toString("hex").toUpperCase());'.
  ENDMETHOD.

  METHOD if_system_uuid_rfc4122_static~create_uuid_c36_by_version.
    ASSERT version = 4.
    WRITE '@KERNEL if (cl_system_uuid.CRYPTO === undefined) cl_system_uuid.CRYPTO = await import("crypto");'.
    WRITE '@KERNEL uuid.set(cl_system_uuid.CRYPTO.randomUUID());'.
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_c22.
  ENDMETHOD.

ENDCLASS.