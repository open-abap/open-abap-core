CLASS cl_system_uuid DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_system_uuid_rfc4122_static.
    INTERFACES if_system_uuid_static.

    ALIASES create_uuid_c32_static FOR if_system_uuid_static~create_uuid_c32.
    ALIASES create_uuid_x16_static FOR if_system_uuid_static~create_uuid_x16.
  PRIVATE SECTION.
    CLASS-METHODS random RETURNING VALUE(rv_str) TYPE string.
ENDCLASS.

CLASS cl_system_uuid IMPLEMENTATION.

  METHOD random.
    " browser and node
    WRITE '@KERNEL if (cl_system_uuid.CRYPTO === undefined) cl_system_uuid.CRYPTO = await import("crypto");'.
    WRITE '@KERNEL if (cl_system_uuid.CRYPTO) {'.
    WRITE '@KERNEL   rv_str.set(cl_system_uuid.CRYPTO.randomUUID());'.
    WRITE '@KERNEL } else {'.
    WRITE '@KERNEL   rv_str = window.crypto.randomUUID();'.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_x16.
    DATA lv_str TYPE string.
    lv_str = random( ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_str WITH ''.
    TRANSLATE lv_str TO UPPER CASE.
    uuid = lv_str(32).
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_c32.
    DATA lv_str TYPE string.
    lv_str = random( ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_str WITH ''.
    uuid = lv_str(32).
    TRANSLATE uuid TO UPPER CASE.
  ENDMETHOD.

  METHOD if_system_uuid_rfc4122_static~create_uuid_c36_by_version.
    ASSERT version = 4.
    uuid = random( ).
  ENDMETHOD.

  METHOD if_system_uuid_static~create_uuid_c22.
    DATA lv_str TYPE string.
    lv_str = random( ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_str WITH ''.
    uuid = lv_str(22).
  ENDMETHOD.

ENDCLASS.