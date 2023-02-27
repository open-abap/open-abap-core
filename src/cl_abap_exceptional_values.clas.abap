CLASS cl_abap_exceptional_values DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_max_value
      IMPORTING
        in TYPE any
      RETURNING
        VALUE(out) TYPE REF TO data.

    CLASS-METHODS get_min_value
      IMPORTING
        in TYPE any
      RETURNING
        VALUE(out) TYPE REF TO data.
ENDCLASS.

CLASS cl_abap_exceptional_values IMPLEMENTATION.

  METHOD get_max_value.
    DATA lv_type     TYPE c LENGTH 1.
    DATA lv_length   TYPE i.
    DATA lv_decimals TYPE i.
    FIELD-SYMBOLS <out> TYPE any.

    DESCRIBE FIELD in TYPE lv_type.

    CASE lv_type.
      WHEN cl_abap_typedescr=>typekind_int.
        GET REFERENCE OF cl_abap_math=>max_int4 INTO out.
      WHEN cl_abap_typedescr=>typekind_packed.
        DESCRIBE FIELD in LENGTH lv_length IN BYTE MODE DECIMALS lv_decimals.

        CREATE DATA out TYPE p LENGTH lv_length DECIMALS lv_decimals.
        ASSIGN out->* TO <out>.

        IF lv_length = 3 AND lv_decimals = 1.
          <out> = '9999.9'.
        ELSEIF lv_length = 7 AND lv_decimals = 3.
          <out> = '9999999999.999'.
        ELSE.
          ASSERT 1 = 'todo'.
        ENDIF.
      WHEN OTHERS.
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
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.