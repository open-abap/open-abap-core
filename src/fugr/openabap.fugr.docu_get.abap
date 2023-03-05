FUNCTION docu_get.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(ID)
*"     REFERENCE(LANGU)
*"     REFERENCE(OBJECT)
*"     REFERENCE(TYP)
*"  TABLES
*"      LINE STRUCTURE  TLINE
*"----------------------------------------------------------------------

  CLEAR line.

  IF id = 'NA' AND object = '00001'.
* message class 00, number 001
    RETURN.
  ENDIF.

* todo

  WRITE '@KERNEL console.dir(INPUT);'.
  ASSERT 'todo' = 1.

ENDFUNCTION.