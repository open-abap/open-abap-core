CLASS ltcl_numberrange_runtime DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_numberrange_runtime IMPLEMENTATION.

  METHOD test1.

    DATA lv_num TYPE n LENGTH 10.

* as of now, the range and object is not checked, everything returns a number, always    
    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr = '01'
        object      = 'HELLO'
      IMPORTING
        number      = lv_num ).

    cl_abap_unit_assert=>assert_not_initial( lv_num ).
  ENDMETHOD.

ENDCLASS.