CLASS cl_os_ca_common DEFINITION PUBLIC ABSTRACT.
  PUBLIC SECTION.
    INTERFACES if_os_ca_persistency.
    INTERFACES if_os_ca_service.
    INTERFACES if_os_factory.

ENDCLASS.

CLASS cl_os_ca_common IMPLEMENTATION.
  METHOD if_os_factory~create_transient_by_key.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD if_os_factory~create_persistent_by_key.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD if_os_ca_service~save.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD if_os_ca_service~save_in_update_task.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD if_os_ca_persistency~get_persistent_by_key.
    RETURN. " todo, implement method
  ENDMETHOD.

ENDCLASS.