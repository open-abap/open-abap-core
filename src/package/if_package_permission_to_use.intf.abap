INTERFACE if_package_permission_to_use PUBLIC.

  DATA package_interface_name TYPE c LENGTH 30 READ-ONLY.

  METHODS get_all_attributes
    EXPORTING
      e_permission_data TYPE scomppdtln
    EXCEPTIONS
      object_invalid
      intern_err.

  METHODS delete
    EXCEPTIONS
      object_not_changeable
      object_invalid
      deletion_not_allowed
      intern_err.

  METHODS set_all_attributes
    IMPORTING
      i_permission_data TYPE scomppdtln
      i_data_sign       TYPE any
    EXCEPTIONS
      object_not_changeable
      object_invalid
      intern_err.

ENDINTERFACE.