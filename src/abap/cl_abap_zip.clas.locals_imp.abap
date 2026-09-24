CLASS lcl_stream DEFINITION.
  PUBLIC SECTION.
    METHODS append IMPORTING iv_xstr TYPE xsequence.
    METHODS get RETURNING VALUE(rv_xstr) TYPE xstring.
    METHODS append_date IMPORTING iv_date TYPE d.
    METHODS append_time IMPORTING iv_time TYPE t.
    METHODS append_int4 IMPORTING iv_int TYPE i.
    METHODS append_int2 IMPORTING iv_int TYPE i.
    METHODS append_crc
      IMPORTING
        iv_little_endian TYPE abap_bool
        iv_xstring       TYPE xstring
      RETURNING
        VALUE(rv_crc)    TYPE xstring.
    CLASS-METHODS read_int2
      IMPORTING
        iv_xstr       TYPE xstring
        iv_offset     TYPE i
      RETURNING
        VALUE(rv_int) TYPE i.
    CLASS-METHODS read_int4
      IMPORTING
        iv_xstr       TYPE xstring
        iv_offset     TYPE i
      RETURNING
        VALUE(rv_int) TYPE i.
  PRIVATE SECTION.
* slice-by-4 lookup tables, 256 entries of 4 bytes, stored little endian
    CLASS-DATA crc32_map TYPE xstring.
    CLASS-DATA crc32_map1 TYPE xstring.
    CLASS-DATA crc32_map2 TYPE xstring.
    CLASS-DATA crc32_map3 TYPE xstring.
    DATA mv_xstr TYPE xstring.
ENDCLASS.

CLASS lcl_stream IMPLEMENTATION.
  METHOD append.
    CONCATENATE mv_xstr iv_xstr INTO mv_xstr IN BYTE MODE.
  ENDMETHOD.

  METHOD read_int2.
    DATA lv_byte   TYPE x LENGTH 1.
    DATA lv_val    TYPE i.
    DATA lv_factor TYPE i VALUE 1.
    DATA lv_pos    TYPE i.

    DO 2 TIMES.
      lv_pos = iv_offset + sy-index - 1.
      lv_byte = iv_xstr+lv_pos(1).
      lv_val = lv_byte.
      rv_int = rv_int + lv_val * lv_factor.
      lv_factor = lv_factor * 256.
    ENDDO.
  ENDMETHOD.

  METHOD read_int4.
    DATA lv_byte   TYPE x LENGTH 1.
    DATA lv_val    TYPE i.
    DATA lv_factor TYPE i VALUE 1.
    DATA lv_pos    TYPE i.

    DO 4 TIMES.
      lv_pos = iv_offset + sy-index - 1.
      lv_byte = iv_xstr+lv_pos(1).
      lv_val = lv_byte.
      rv_int = rv_int + lv_val * lv_factor.
      lv_factor = lv_factor * 256.
    ENDDO.
  ENDMETHOD.

  METHOD get.
    rv_xstr = mv_xstr.
  ENDMETHOD.

  METHOD append_date.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD append_time.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD append_int2.
    DATA lv_hex TYPE x LENGTH 2.
    lv_hex = iv_int.
* convert to little endian
    SHIFT lv_hex LEFT CIRCULAR IN BYTE MODE.
    append( lv_hex ).
  ENDMETHOD.

  METHOD append_int4.
    DATA lv_hex TYPE x LENGTH 4.
    lv_hex = iv_int.
* convert to little endian
    CONCATENATE lv_hex+3(1) lv_hex+2(1) lv_hex+1(1) lv_hex(1) INTO lv_hex IN BYTE MODE.
    append( lv_hex ).
  ENDMETHOD.

  METHOD append_crc.
* https://github.com/kyriosli/node-zip/blob/master/index.js#L369-L389
* slice-by-4: one step per 4 bytes instead of per byte. The register CRC is
* kept little endian, so "c >> 8" is crc+1(3) and "c & 0xFF" is crc(1).

    CONSTANTS: magic_nr  TYPE x LENGTH 4 VALUE 'EDB88320',
               mffffffff TYPE x LENGTH 4 VALUE 'FFFFFFFF',
               m7fffffff TYPE x LENGTH 4 VALUE '7FFFFFFF'.

    DATA: cindex  TYPE x LENGTH 4,
          low_bit TYPE x LENGTH 4,
          len     TYPE i,
          words   TYPE i,
          offset  TYPE i,
          idx     TYPE i,
          crc     TYPE x LENGTH 4 VALUE mffffffff,
          x4      TYPE x LENGTH 4,
          x1      TYPE x LENGTH 1.

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
        CONCATENATE crc32_map cindex+3(1) cindex+2(1) cindex+1(1) cindex(1)
          INTO crc32_map IN BYTE MODE.
      ENDDO.
* T1..T3: T(k)[i] = T(k-1)[i] >> 8 XOR T0[T(k-1)[i] & 0xFF]
      DO 256 TIMES.
        idx = ( sy-index - 1 ) * 4.
        x4 = crc32_map+idx(4).
        idx = x4(1) * 4.
        x4 = x4+1(3) BIT-XOR crc32_map+idx(4).
        CONCATENATE crc32_map1 x4 INTO crc32_map1 IN BYTE MODE.
        idx = x4(1) * 4.
        x4 = x4+1(3) BIT-XOR crc32_map+idx(4).
        CONCATENATE crc32_map2 x4 INTO crc32_map2 IN BYTE MODE.
        idx = x4(1) * 4.
        x4 = x4+1(3) BIT-XOR crc32_map+idx(4).
        CONCATENATE crc32_map3 x4 INTO crc32_map3 IN BYTE MODE.
      ENDDO.
    ENDIF.

    len = xstrlen( iv_xstring ).
    words = len DIV 4.
    DO words TIMES.
      crc = crc BIT-XOR iv_xstring+offset(4).
      idx = crc(1) * 4.
      x4 = crc32_map3+idx(4).
      idx = crc+1(1) * 4.
      x4 = x4 BIT-XOR crc32_map2+idx(4).
      idx = crc+2(1) * 4.
      x4 = x4 BIT-XOR crc32_map1+idx(4).
      idx = crc+3(1) * 4.
      crc = x4 BIT-XOR crc32_map+idx(4).
      offset = offset + 4.
    ENDDO.
    len = len - offset.
    DO len TIMES.
      x1 = crc(1) BIT-XOR iv_xstring+offset(1).
      idx = x1 * 4.
      crc = crc+1(3) BIT-XOR crc32_map+idx(4).
      offset = offset + 1.
    ENDDO.
    crc = crc BIT-XOR mffffffff.

    IF iv_little_endian = abap_false.
* convert to big endian
      CONCATENATE crc+3(1) crc+2(1) crc+1(1) crc(1) INTO crc IN BYTE MODE.
    ENDIF.

    rv_crc = crc.

    append( rv_crc ).

  ENDMETHOD.

ENDCLASS.