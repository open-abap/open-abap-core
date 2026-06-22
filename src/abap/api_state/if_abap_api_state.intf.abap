INTERFACE if_abap_api_state PUBLIC.

  TYPES ty_object_directory_type TYPE c LENGTH 4.
  TYPES ty_object_directory_name TYPE c LENGTH 40.
  TYPES ty_sub_object_type TYPE c LENGTH 30.
  TYPES ty_sub_object_name TYPE c LENGTH 40.
  TYPES ty_release_contract TYPE c LENGTH 2.
  TYPES ty_request TYPE trkorr.

  TYPES:
    BEGIN OF ty_api_key,
      object_type     TYPE ty_object_directory_type,
      object_name     TYPE ty_object_directory_name,
      sub_object_type TYPE ty_sub_object_type,
      sub_object_name TYPE ty_sub_object_name,
    END OF ty_api_key.

  METHODS release
    IMPORTING
      release_contract         TYPE ty_release_contract
      use_in_cloud_development TYPE abap_bool DEFAULT abap_false
      use_in_key_user_apps     TYPE abap_bool DEFAULT abap_false
      request                  TYPE ty_request OPTIONAL
    RAISING
      cx_abap_api_state.

  METHODS delete_release_state
    IMPORTING
      release_contract TYPE ty_release_contract
      request          TYPE ty_request OPTIONAL
    RAISING
      cx_abap_api_state.

  METHODS is_released
    IMPORTING
      release_contract         TYPE ty_release_contract
      use_in_cloud_development TYPE abap_bool DEFAULT abap_false
      use_in_key_user_apps     TYPE abap_bool DEFAULT abap_false
    RETURNING
      VALUE(result)            TYPE abap_bool
    RAISING
      cx_abap_api_state.

ENDINTERFACE.
