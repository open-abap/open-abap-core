CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS create_data_type_handle FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD create_data_type_handle.
    DATA lo_element TYPE REF TO cl_abap_elemdescr.
    DATA lo_value_new TYPE REF TO data.
    FIELD-SYMBOLS <fs_value> TYPE simple.

    lo_element = cl_abap_elemdescr=>get_i( ).
    CREATE DATA lo_value_new TYPE HANDLE lo_element.
    ASSIGN lo_value_new->* TO <fs_value>.
    CLEAR <fs_value>.
    <fs_value> = 2.
  ENDMETHOD.

ENDCLASS.