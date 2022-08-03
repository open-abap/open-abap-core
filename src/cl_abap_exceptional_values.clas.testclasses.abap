CLASS ltcl_exceptional_values DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS max_integer FOR TESTING RAISING cx_static_check.
    METHODS min_integer FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_exceptional_values IMPLEMENTATION.

  METHOD max_integer.
    DATA int TYPE i.
    DATA ref TYPE REF TO data.
    DATA val TYPE string.
    DATA max TYPE string.
    FIELD-SYMBOLS <max> TYPE any.
    ref = cl_abap_exceptional_values=>get_max_value( int ).
    ASSIGN ref->* TO <max>.
    max = <max>.
    ASSERT <max> = cl_abap_math=>max_int4.
  ENDMETHOD.

  METHOD min_integer.
    DATA int TYPE i.
    DATA ref TYPE REF TO data.
    DATA val TYPE string.
    DATA min TYPE string.
    FIELD-SYMBOLS <min> TYPE any.
    ref = cl_abap_exceptional_values=>get_min_value( int ).
    ASSIGN ref->* TO <min>.
    min = <min>.
    ASSERT <min> = cl_abap_math=>min_int4.
  ENDMETHOD.

ENDCLASS.