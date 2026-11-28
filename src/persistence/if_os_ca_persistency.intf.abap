INTERFACE if_os_ca_persistency PUBLIC.

  METHODS get_persistent_by_key
    IMPORTING
      i_key         TYPE any
    RETURNING
      VALUE(result) TYPE REF TO object
    RAISING
      cx_os_object_not_found
      cx_os_class_not_found.

  METHODS get_persistent_by_key_tab
    IMPORTING
      i_key_tab     TYPE INDEX TABLE
    RETURNING
      VALUE(result) TYPE osreftab
    RAISING
      cx_os_object_not_found.

  TYPES:
    BEGIN OF ty_query_options,
      database_query_options TYPE x LENGTH 1,
    END OF ty_query_options.

  METHODS get_persistent_by_query
    IMPORTING
      i_query         TYPE REF TO object
      i_parameter_tab TYPE ANY TABLE OPTIONAL
      i_par1          TYPE any OPTIONAL
      i_par2          TYPE any OPTIONAL
      i_par3          TYPE any OPTIONAL
      i_subclasses    TYPE abap_bool DEFAULT abap_false
      i_upto          TYPE i DEFAULT 0
      i_options       TYPE ty_query_options OPTIONAL
    RETURNING
      VALUE(result)   TYPE osreftab
    RAISING
      cx_os_object_not_found.

ENDINTERFACE.