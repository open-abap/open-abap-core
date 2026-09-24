CLASS cl_abap_elemdescr DEFINITION PUBLIC INHERITING FROM cl_abap_datadescr.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF fixvalue,
        low        TYPE c LENGTH 10,
        high       TYPE c LENGTH 10,
        option     TYPE c LENGTH 2,
        ddlanguage TYPE c,
        ddtext     TYPE c LENGTH 60,
      END OF fixvalue.
    TYPES fixvalues TYPE STANDARD TABLE OF fixvalue WITH DEFAULT KEY.

    DATA output_length TYPE i READ-ONLY.
    DATA edit_mask TYPE abap_editmask READ-ONLY.
    DATA help_id TYPE abap_helpid READ-ONLY.

    METHODS get_ddic_fixed_values
      IMPORTING
        p_langu               TYPE sy-langu DEFAULT sy-langu
      RETURNING
        VALUE(p_fixed_values) TYPE fixvalues.

    METHODS get_ddic_field
      IMPORTING
        p_langu           TYPE sy-langu DEFAULT sy-langu
      RETURNING
        VALUE(p_flddescr) TYPE dfies
      EXCEPTIONS
        not_found
        no_ddic_type.

    CLASS-METHODS get_i RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_int8 RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_f RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_d RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_t RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_decfloat16 RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_decfloat34 RETURNING VALUE(r_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_string RETURNING VALUE(p_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_utclong RETURNING VALUE(p_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_c
      IMPORTING
        p_length        TYPE i
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_p
      IMPORTING
        p_length        TYPE i
        p_decimals      TYPE i
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_n
      IMPORTING
        p_length        TYPE i
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_x
      IMPORTING
        p_length        TYPE i
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_elemdescr.
    CLASS-METHODS get_xstring
      RETURNING
        VALUE(p_result) TYPE REF TO cl_abap_elemdescr.

  PRIVATE SECTION.
    "! open-abap: DDIC datatype derived from the internal type, when no dictionary type is known
    CLASS-METHODS ddic_datatype_from_typekind
      IMPORTING
        typekind           TYPE abap_typekind
      RETURNING
        VALUE(rv_datatype) TYPE string.
ENDCLASS.

CLASS cl_abap_elemdescr IMPLEMENTATION.

  METHOD get_p.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_decfloat16.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_decfloat34.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_n.
    DATA foo TYPE REF TO data.
    CREATE DATA foo TYPE n LENGTH p_length.
    p_result ?= cl_abap_typedescr=>describe_by_data_ref( foo ).
  ENDMETHOD.

  METHOD get_x.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_xstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_ddic_field.
    DATA lv_datatype TYPE string.

    p_flddescr-tabname  = absolute_name.
    p_flddescr-rollname = relative_name.
    p_flddescr-inttype  = type_kind.
    p_flddescr-langu    = sy-langu.
    p_flddescr-position = 1.
    p_flddescr-leng     = length.
    p_flddescr-decimals = decimals.
    p_flddescr-outputlen = output_length.

    WRITE '@KERNEL p_flddescr.get().domname.set(abap.DDIC[this.relative_name.get()]?.domain || "");'.
    WRITE '@KERNEL lv_datatype.set(abap.DDIC[this.relative_name.get()]?.datatype || "");'.
    IF lv_datatype IS INITIAL.
      lv_datatype = ddic_datatype_from_typekind( type_kind ).
    ENDIF.
    p_flddescr-datatype = lv_datatype.

    IF edit_mask CP '==*'.
      p_flddescr-convexit = edit_mask+2.
    ENDIF.
  ENDMETHOD.

  METHOD ddic_datatype_from_typekind.
    CASE typekind.
      WHEN cl_abap_typedescr=>typekind_char.
        rv_datatype = 'CHAR'.
      WHEN cl_abap_typedescr=>typekind_num.
        rv_datatype = 'NUMC'.
      WHEN cl_abap_typedescr=>typekind_date.
        rv_datatype = 'DATS'.
      WHEN cl_abap_typedescr=>typekind_time.
        rv_datatype = 'TIMS'.
      WHEN cl_abap_typedescr=>typekind_packed.
        rv_datatype = 'DEC'.
      WHEN cl_abap_typedescr=>typekind_int.
        rv_datatype = 'INT4'.
      WHEN cl_abap_typedescr=>typekind_int8.
        rv_datatype = 'INT8'.
      WHEN cl_abap_typedescr=>typekind_int1.
        rv_datatype = 'INT1'.
      WHEN cl_abap_typedescr=>typekind_int2.
        rv_datatype = 'INT2'.
      WHEN cl_abap_typedescr=>typekind_float.
        rv_datatype = 'FLTP'.
      WHEN cl_abap_typedescr=>typekind_hex.
        rv_datatype = 'RAW'.
      WHEN cl_abap_typedescr=>typekind_string.
        rv_datatype = 'STRG'.
      WHEN cl_abap_typedescr=>typekind_xstring.
        rv_datatype = 'RSTR'.
      WHEN cl_abap_typedescr=>typekind_decfloat16.
        rv_datatype = 'D16N'.
      WHEN cl_abap_typedescr=>typekind_decfloat34.
        rv_datatype = 'D34N'.
      WHEN cl_abap_typedescr=>typekind_utclong.
        rv_datatype = 'UTCL'.
      WHEN OTHERS.
        rv_datatype = ''.
    ENDCASE.
  ENDMETHOD.

  METHOD get_i.
    DATA foo TYPE i.
    r_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.

  METHOD get_int8.
    DATA foo TYPE int8.
    r_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.

  METHOD get_string.
    DATA foo TYPE string.
    p_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.

  METHOD get_f.
    DATA foo TYPE f.
    r_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.

  METHOD get_d.
    DATA foo TYPE d.
    r_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.

  METHOD get_t.
    DATA foo TYPE t.
    r_result ?= cl_abap_typedescr=>describe_by_data( foo ).
  ENDMETHOD.

  METHOD get_c.
    DATA foo TYPE REF TO data.
    CREATE DATA foo TYPE c LENGTH p_length.
    p_result ?= cl_abap_typedescr=>describe_by_data_ref( foo ).
  ENDMETHOD.

  METHOD get_utclong.
    DATA foo TYPE REF TO data.
    CREATE DATA foo TYPE utclong.
    p_result ?= cl_abap_typedescr=>describe_by_data_ref( foo ).
  ENDMETHOD.

  METHOD get_ddic_fixed_values.

    DATA lv_dummy TYPE string.
    DATA lv_name  TYPE string.
    DATA ls_row   LIKE LINE OF p_fixed_values.

* todo: take P_LANGU into account

    SPLIT absolute_name AT '=' INTO lv_dummy lv_name.

* the transpiler serializes abaplint's DomainValue as-is: {low, high, description, language}
    WRITE '@KERNEL for (const f of abap.DDIC[lv_name.get()]?.fixedValues || []) {'.
    CLEAR ls_row.
    WRITE '@KERNEL   ls_row.get().low.set(f.low || "");'.
    WRITE '@KERNEL   ls_row.get().high.set(f.high || "");'.
    WRITE '@KERNEL   ls_row.get().option.set(f.high ? "BT" : "EQ");'.
    WRITE '@KERNEL   ls_row.get().ddlanguage.set(f.language || "");'.
    WRITE '@KERNEL   ls_row.get().ddtext.set(f.description || "");'.
    APPEND ls_row TO p_fixed_values.
    WRITE '@KERNEL }'.

  ENDMETHOD.

ENDCLASS.
