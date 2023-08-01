FUNCTION unit_conversion_simple.

  DATA lv_float TYPE f.

  IF unit_in = unit_out.
    output = input.
  ELSEIF unit_in = 'G' AND unit_out = 'KG'.
    output = input / 1000.
  ELSEIF unit_in = 'M3' AND unit_out = 'CDM'.
    output = input * 1000.
  ELSEIF unit_in = 'LB' AND unit_out = 'KG'.
    lv_float = '0.45359237'.
    output = input * lv_float.
  ELSE.
    ASSERT 1 = 2.
  ENDIF.

ENDFUNCTION.