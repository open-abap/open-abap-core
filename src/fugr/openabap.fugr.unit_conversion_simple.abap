FUNCTION unit_conversion_simple.

  IF unit_in = 'KG' AND unit_out = 'KG'.
    output = input.
  ELSEIF unit_in = 'G' AND unit_out = 'KG'.
    output = input / 1000.
  ELSE.
    ASSERT 1 = 2.
  ENDIF.

ENDFUNCTION.