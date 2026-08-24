CLASS cl_aunit_auth_check_types_def DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF authfield_values,
        fieldname   TYPE c LENGTH 10,
        fieldvalues TYPE authvalinterval_tab,
      END OF authfield_values,
      authorization TYPE HASHED TABLE OF authfield_values
        WITH UNIQUE KEY primary_key COMPONENTS fieldname,
      authorizations TYPE STANDARD TABLE OF authorization WITH DEFAULT KEY,
      BEGIN OF authorizations_for_object,
        object         TYPE c LENGTH 10,
        authorizations TYPE authorizations,
      END OF authorizations_for_object,
      role_auth_objects TYPE STANDARD TABLE OF authorizations_for_object WITH DEFAULT KEY,
      auth_user TYPE c LENGTH 12,
      auth_users TYPE STANDARD TABLE OF auth_user WITH DEFAULT KEY,
      BEGIN OF user_role_authorization,
        role_authorizations TYPE role_auth_objects,
        users               TYPE auth_users,
      END OF user_role_authorization,
      user_role_authorizations TYPE STANDARD TABLE OF user_role_authorization WITH DEFAULT KEY,
      BEGIN OF auth_ctxtset_msg,
        object         TYPE c LENGTH 10,
        authorizations TYPE authorization,
        user           TYPE sy-uname,
        description    TYPE string,
      END OF auth_ctxtset_msg,
      auth_ctxtset_msgs TYPE STANDARD TABLE OF auth_ctxtset_msg WITH EMPTY KEY,
      BEGIN OF ENUM test_abort_behavior STRUCTURE behavior,
        abap_unit_abort,
        raise_exceptions,
      END OF ENUM test_abort_behavior STRUCTURE behavior.
ENDCLASS.

CLASS cl_aunit_auth_check_types_def IMPLEMENTATION.
ENDCLASS.
