CLASS kernel_call DEFINITION PUBLIC.
* handling of ABAP statement CALL
  PUBLIC SECTION.
    CLASS-METHODS call
      IMPORTING
        input TYPE any.
  PRIVATE SECTION.
ENDCLASS.

CLASS kernel_call IMPLEMENTATION.

  METHOD call.

    DATA uuid TYPE sysuuid_x16.
    DATA name TYPE string.

    WRITE '@KERNEL name.set(INPUT.name);'.

    IF name = 'RFCControl'.
      uuid = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ).
      WRITE '@KERNEL INPUT.uuid.set(uuid);'.
    ELSE.
      WRITE: / 'unknown kernel function:', name.
      ASSERT 1 = 2.
    ENDIF.

  ENDMETHOD.

ENDCLASS.