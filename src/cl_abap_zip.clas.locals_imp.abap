CLASS lcl_stream DEFINITION.
  PUBLIC SECTION.
    METHODS append IMPORTING iv_xstr TYPE xsequence.
    METHODS get RETURNING VALUE(rv_xstr) TYPE xstring.
    METHODS append_date IMPORTING iv_date TYPE d.
    METHODS append_time IMPORTING iv_time TYPE t.
    METHODS append_int4 IMPORTING iv_int TYPE i.
    METHODS append_int2 IMPORTING iv_int TYPE i.
    METHODS append_crc
      IMPORTING iv_xstring TYPE xstring
      RETURNING VALUE(rv_crc) TYPE xstring.
  PRIVATE SECTION.
    CLASS-DATA crc32_map TYPE xstring.
    DATA mv_xstr TYPE xstring.
ENDCLASS.

CLASS lcl_stream IMPLEMENTATION.
  METHOD append.
    CONCATENATE mv_xstr iv_xstr INTO mv_xstr IN BYTE MODE.
  ENDMETHOD.

  METHOD get.
    rv_xstr = mv_xstr.
  ENDMETHOD.

  METHOD append_date.
* todo
  ENDMETHOD.

  METHOD append_time.
* todo
  ENDMETHOD.

  METHOD append_int2.
    DATA lv_hex TYPE x LENGTH 1.
    lv_hex = iv_int.
    append( lv_hex ).
  ENDMETHOD.

  METHOD append_int4.
    DATA lv_hex TYPE x LENGTH 2.
    lv_hex = iv_int.
    append( lv_hex ).
  ENDMETHOD.

  METHOD append_crc.
* https://github.com/kyriosli/node-zip/blob/master/index.js#L369-L389

    CONSTANTS: magic_nr  TYPE x LENGTH 4 VALUE 'EDB88320',
               mffffffff TYPE x LENGTH 4 VALUE 'FFFFFFFF',
               m7fffffff TYPE x LENGTH 4 VALUE '7FFFFFFF',
               m00ffffff TYPE x LENGTH 4 VALUE '00FFFFFF',
               m000000ff TYPE x LENGTH 4 VALUE '000000FF',
               m000000   TYPE x LENGTH 3 VALUE '000000'.

    DATA: cindex  TYPE x LENGTH 4,
          low_bit TYPE x LENGTH 4,
          len     TYPE i,
          nindex  TYPE i,
          crc     TYPE x LENGTH 4 VALUE mffffffff,
          x4      TYPE x LENGTH 4,
          idx     TYPE x LENGTH 4.

    IF xstrlen( crc32_map ) = 0.
      DO 256 TIMES.
        cindex = sy-index - 1.
        DO 8 TIMES.
          low_bit = '00000001'.
          low_bit = cindex BIT-AND low_bit.   " c  & 1
          cindex = cindex DIV 2.
          cindex = cindex BIT-AND m7fffffff. " c >> 1 (top is zero, but in ABAP signed!)
          IF low_bit IS NOT INITIAL.
            cindex = cindex BIT-XOR magic_nr.
          ENDIF.
        ENDDO.
        CONCATENATE crc32_map cindex INTO crc32_map IN BYTE MODE.
      ENDDO.
    ENDIF.

    len = xstrlen( iv_xstring ).
    DO len TIMES.
      nindex = sy-index - 1.
      CONCATENATE m000000 iv_xstring+nindex(1) INTO idx IN BYTE MODE.
      idx = ( crc BIT-XOR idx ) BIT-AND m000000ff.
      idx = idx * 4.
      x4  = crc32_map+idx(4).
      crc = crc DIV 256.
      crc = crc BIT-AND m00ffffff. " c >> 8
      crc = x4 BIT-XOR crc.
    ENDDO.
    crc = crc BIT-XOR mffffffff.

    rv_crc = crc.

    append( rv_crc ).

  ENDMETHOD.

ENDCLASS.