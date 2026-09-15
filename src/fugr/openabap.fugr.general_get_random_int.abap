FUNCTION general_get_random_int.

* A uniformly distributed integer between zero and RANGE, both included.
*
* Measured against an AS ABAP 1909 rather than inferred, because the obvious
* reading of the parameter text ("The random int will be <= range") is one to
* range, and that is wrong. Three hundred calls per range:
*
*   range 1     values 0..1     zero in 163      (a half)
*   range 2     values 0..2     zero in 105      (a third)
*   range 6     values 0..6     zero in  53      (a seventh)
*   range 100   values 0..100   zero in   3      (a hundred-and-first)
*
* The span is RANGE + 1 values. A range of zero answers zero, and a negative
* range is not an error: -5 answered -2, so the span runs towards RANGE on
* whichever side of zero it lies. The module declares no exceptions and the
* real one raises none.
*
* Written against Math.random directly rather than through
* cl_abap_random_int, which was the first attempt. That class cannot express
* this: cl_abap_random=>intinrange opens with ASSERT high > low and
* ASSERT low >= 0, so a range of zero dumps and every negative range dumps.
* Reaching the contract through abs( ) and a negation would work and would
* read as cleverness hiding the intent. The randomness is the same
* Math.random either way, since that is what cl_abap_random uses too, and
* generate_sec_random in this group is the precedent for the plain form.
  WRITE '@KERNEL const r = range.get();'.
  WRITE '@KERNEL const span = Math.abs(r) + 1;'.
  WRITE '@KERNEL random.set(Math.sign(r) * Math.floor(Math.random() * span));'.

ENDFUNCTION.
