INTERFACE if_osql_test_environment PUBLIC.

  TYPES ty_s_sobjname  TYPE abap_compname.
  TYPES ty_t_sobjnames TYPE STANDARD TABLE OF ty_s_sobjname WITH DEFAULT KEY.

  METHODS clear_doubles.
  METHODS destory.
  METHODS insert_test_data
    IMPORTING
      i_data TYPE ANY TABLE.

ENDINTERFACE.