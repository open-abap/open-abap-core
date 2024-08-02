INTERFACE if_mr_api PUBLIC.

  CLASS-METHODS get_api
    IMPORTING
      i_prefix        TYPE csequence DEFAULT space
    RETURNING
      VALUE(r_mr_api) TYPE REF TO if_mr_api.

  METHODS get
    IMPORTING
      i_url                  TYPE csequence
      i_check_authority      TYPE abap_bool DEFAULT abap_true
    EXPORTING
      e_is_folder            TYPE abap_bool
      e_content              TYPE xstring
      e_mime_type            TYPE csequence
      e_loio                 TYPE skwf_io
      e_content_last_changed TYPE any
    CHANGING
      c_language             TYPE langu OPTIONAL
    EXCEPTIONS
      parameter_missing
      error_occured
      not_found
      permission_failure.

  METHODS create_folder
    IMPORTING
      i_url                         TYPE csequence
      i_language                    TYPE langu DEFAULT sy-langu
      i_description                 TYPE csequence OPTIONAL
      i_check_authority             TYPE abap_bool DEFAULT abap_true
      i_suppress_package_dialog     TYPE abap_bool DEFAULT space
      i_dev_package                 TYPE devclass OPTIONAL
      i_genflag                     TYPE abap_bool DEFAULT abap_false
      i_corr_number                 TYPE trkorr OPTIONAL
      i_folder_loio                 TYPE any OPTIONAL
      i_suppress_dialogs            TYPE abap_bool OPTIONAL
      i_folder_role                 TYPE any OPTIONAL
      i_new_folder_role_description TYPE any OPTIONAL
    EXPORTING
      e_folder_io                   TYPE skwf_io
    EXCEPTIONS
      parameter_missing
      error_occured
      cancelled
      permission_failure
      folder_exists.

  METHODS put
    IMPORTING
      i_url                     TYPE csequence
      i_content                 TYPE xstring
      i_language                TYPE langu DEFAULT sy-langu
      i_description             TYPE csequence OPTIONAL
      i_check_authority         TYPE abap_bool DEFAULT abap_true
      i_suppress_package_dialog TYPE abap_bool DEFAULT space
      i_dev_package             TYPE devclass OPTIONAL
      i_genflag                 TYPE abap_bool DEFAULT abap_false
      i_corr_number             TYPE trkorr OPTIONAL
      i_new_loio                TYPE any OPTIONAL
      i_virus_profile           TYPE any OPTIONAL
      i_suppress_dialogs        TYPE abap_bool OPTIONAL
    EXCEPTIONS
      parameter_missing
      error_occured
      cancelled
      permission_failure
      data_inconsistency
      new_loio_already_exists
      is_folder.

  METHODS delete
    IMPORTING
      i_url              TYPE csequence
      i_delete_children  TYPE abap_bool DEFAULT abap_false
      i_check_authority  TYPE abap_bool DEFAULT abap_true
      i_corr_number      TYPE trkorr OPTIONAL
      i_suppress_dialogs TYPE abap_bool OPTIONAL
    EXCEPTIONS
      parameter_missing
      error_occured
      cancelled
      permission_failure
      not_found.

  METHODS file_list
    IMPORTING
      i_url             TYPE csequence
      i_recursive_call  TYPE abap_bool DEFAULT abap_false
      i_check_authority TYPE abap_bool DEFAULT abap_true
    EXPORTING
      e_files           TYPE string_table
    EXCEPTIONS
      parameter_missing
      error_occured
      not_found
      permission_failure
      is_not_folder.

  METHODS properties
    IMPORTING
      i_url               TYPE csequence
      i_check_authority   TYPE abap_bool DEFAULT abap_true
    EXPORTING
      e_is_folder         TYPE abap_bool
      e_mime_type         TYPE csequence
      e_name              TYPE string
      e_size              TYPE i
      e_bin_data          TYPE abap_bool
      e_loio              TYPE skwf_io
      e_phio              TYPE skwf_io
      e_language          TYPE langu
      e_phio_last_changed TYPE string " wrong, delete parameter?
    EXCEPTIONS
      parameter_missing
      error_occured
      not_found
      permission_failure.

  METHODS get_io_for_url
    IMPORTING
      i_url       TYPE csequence
    EXPORTING
      e_is_folder TYPE abap_bool
      e_loio      TYPE skwf_io
    EXCEPTIONS
      parameter_missing
      error_occured
      not_found.

  METHODS get_by_io
    IMPORTING
      i_loio                 TYPE any
      i_check_authority      TYPE abap_bool DEFAULT abap_true
    EXPORTING
      e_is_folder            TYPE abap_bool
      e_content              TYPE xstring
      e_content_last_changed TYPE any
      e_mime_type            TYPE csequence
      e_phio_id              TYPE any
    CHANGING
      c_language             TYPE spras OPTIONAL.

  METHODS get_url_for_io
    IMPORTING
      i_loio      TYPE any
    EXPORTING
      e_url       TYPE string
      e_is_folder TYPE abap_bool.

ENDINTERFACE.