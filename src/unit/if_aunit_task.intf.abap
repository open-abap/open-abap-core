INTERFACE if_aunit_task PUBLIC.
  METHODS add_class_pool
    IMPORTING
      class TYPE progname.

  METHODS contains_test_cases
    RETURNING
      VALUE(result) TYPE abap_bool.

  METHODS run
    IMPORTING
      listener TYPE REF TO if_aunit_listener.
ENDINTERFACE.
