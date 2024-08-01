CLASS cl_abap_exceptional_values DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_max_value
      IMPORTING
        in         TYPE any
      RETURNING
        VALUE(out) TYPE REF TO data.

    CLASS-METHODS get_min_value
      IMPORTING
        in         TYPE any
      RETURNING
        VALUE(out) TYPE REF TO data.
ENDCLASS.

CLASS cl_abap_exceptional_values IMPLEMENTATION.

  METHOD get_max_value.
    DATA lv_type                  TYPE c LENGTH 1.
    DATA lv_length                TYPE i.
    DATA lv_decimals              TYPE i.
    DATA lv_digits_before_decimal TYPE i.
    DATA lv_integer_part          TYPE string.
    DATA lv_decimal_part          TYPE string.
    FIELD-SYMBOLS <out>           TYPE any.

    DESCRIBE FIELD in TYPE lv_type.

    CASE lv_type.
      WHEN cl_abap_typedescr=>typekind_int.
        GET REFERENCE OF cl_abap_math=>max_int4 INTO out.
      WHEN cl_abap_typedescr=>typekind_packed.
        DESCRIBE FIELD in LENGTH lv_length IN BYTE MODE DECIMALS lv_decimals.

        CREATE DATA out TYPE p LENGTH lv_length DECIMALS lv_decimals.
        ASSIGN out->* TO <out>.

        lv_digits_before_decimal = lv_length * 2 - 1 - lv_decimals.

        DO lv_digits_before_decimal TIMES.
          lv_integer_part = lv_integer_part && '9'.
        ENDDO.

        IF lv_decimals > 0.
          lv_decimal_part = '.'.
          DO lv_decimals TIMES.
            lv_decimal_part = lv_decimal_part && '9'.
          ENDDO.
        ENDIF.

        <out> = lv_integer_part && lv_decimal_part.
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(INPUT);'.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

  METHOD get_min_value.
    DATA lv_type TYPE c LENGTH 1.
    FIELD-SYMBOLS <out> TYPE any.

    DESCRIBE FIELD in TYPE lv_type.

    CASE lv_type.
      WHEN cl_abap_typedescr=>typekind_int.
        GET REFERENCE OF cl_abap_math=>min_int4 INTO out.
      WHEN cl_abap_typedescr=>typekind_packed.
        out = get_max_value( in ).
        ASSIGN out->* TO <out>.
        <out> = <out> * -1.
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(INPUT);'.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.