INTERFACE if_aunit_authority_objset PUBLIC.
  METHODS clone
    RETURNING
      VALUE(clone) TYPE REF TO if_aunit_authority_objset.

  METHODS append_auth_objset
    IMPORTING auth_objset TYPE REF TO if_aunit_authority_objset
    RAISING cx_abap_auth_check_exception.

  METHODS add_authobj
    IMPORTING
      object TYPE csequence
      users  TYPE cl_aunit_auth_check_types_def=>auth_users OPTIONAL
    RAISING cx_abap_auth_check_exception.

  METHODS add_authobj_with_fldval
    IMPORTING
      object TYPE csequence
      field  TYPE cl_aunit_auth_check_types_def=>authfield_values
      users  TYPE cl_aunit_auth_check_types_def=>auth_users OPTIONAL
    RAISING cx_abap_auth_check_exception.

  METHODS add_authobj_with_fldvals
    IMPORTING
      object TYPE csequence
      fields TYPE cl_aunit_auth_check_types_def=>authorizations
      users  TYPE cl_aunit_auth_check_types_def=>auth_users OPTIONAL
    RAISING cx_abap_auth_check_exception.

  METHODS add_authobjs_with_fldvals
    IMPORTING
      role_authorizations TYPE cl_aunit_auth_check_types_def=>role_auth_objects
      users               TYPE cl_aunit_auth_check_types_def=>auth_users OPTIONAL
    RAISING cx_abap_auth_check_exception.

  METHODS add_role_auths_for_users
    IMPORTING user_role_authorizations TYPE cl_aunit_auth_check_types_def=>user_role_authorizations
    RAISING cx_abap_auth_check_exception.

  METHODS remove_authobj
    IMPORTING
      object TYPE csequence
      users  TYPE cl_aunit_auth_check_types_def=>auth_users OPTIONAL
    RAISING cx_abap_auth_check_exception.

  METHODS remove_authobj_with_fldval
    IMPORTING
      object TYPE csequence
      field  TYPE cl_aunit_auth_check_types_def=>authfield_values
      users  TYPE cl_aunit_auth_check_types_def=>auth_users OPTIONAL
    RAISING cx_abap_auth_check_exception.

  METHODS remove_authobj_with_fldvals
    IMPORTING
      object TYPE csequence
      fields TYPE cl_aunit_auth_check_types_def=>authorizations
      users  TYPE cl_aunit_auth_check_types_def=>auth_users OPTIONAL
    RAISING cx_abap_auth_check_exception.

  METHODS remove_authobjs_with_fldvals
    IMPORTING
      role_authorizations TYPE cl_aunit_auth_check_types_def=>role_auth_objects
      users               TYPE cl_aunit_auth_check_types_def=>auth_users OPTIONAL
    RAISING cx_abap_auth_check_exception.

  METHODS remove_role_auths_for_users
    IMPORTING user_role_authorizations TYPE cl_aunit_auth_check_types_def=>user_role_authorizations
    RAISING cx_abap_auth_check_exception.
ENDINTERFACE.
