FUNCTION number_get_next.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(NR_RANGE_NR)
*"     VALUE(OBJECT)
*"  EXPORTING
*"     VALUE(NUMBER)
*"  EXCEPTIONS
*"      INTERVAL_NOT_FOUND
*"      NUMBER_RANGE_NOT_INTERN
*"      OBJECT_NOT_FOUND
*"      QUANTITY_IS_0
*"      QUANTITY_IS_NOT_1
*"      INTERVAL_OVERFLOW
*"      BUFFER_OVERFLOW
*"----------------------------------------------------------------------

  kernel_numberrange=>number_get(
    EXPORTING
      nr_range_nr = nr_range_nr
      object      = object
    IMPORTING
      number      = number ).

* todo, hack to set return value
  sy-subrc = 0.

ENDFUNCTION.