INTERFACE if_package_permission_to_use PUBLIC.

  DATA package_interface_name TYPE c LENGTH 30 READ-ONLY.

  METHODS delete
    EXCEPTIONS
      object_not_changeable
      object_invalid
      deletion_not_allowed
      intern_err.

ENDINTERFACE.