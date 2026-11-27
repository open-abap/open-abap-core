CLASS cl_bcs_convert DEFINITION PUBLIC.
  PUBLIC SECTION.

    CONSTANTS gc_tab TYPE c LENGTH 1 VALUE cl_abap_char_utilities=>horizontal_tab.
    CONSTANTS gc_crlf TYPE c LENGTH 2 VALUE cl_abap_char_utilities=>cr_lf.

    CLASS-METHODS string_to_soli
      IMPORTING
        iv_string      TYPE string
      RETURNING
        VALUE(et_soli) TYPE soli_tab.

    CLASS-METHODS xstring_to_solix
      IMPORTING
        iv_xstring      TYPE xstring
      RETURNING
        VALUE(et_solix) TYPE solix_tab.

    CLASS-METHODS raw_to_string
      IMPORTING
        it_soli          TYPE soli_tab
      RETURNING
        VALUE(ev_string) TYPE string
      RAISING
        cx_bcs.

    CLASS-METHODS solix_to_xstring
      IMPORTING
        it_solix          TYPE solix_tab
        iv_size           TYPE i OPTIONAL
      RETURNING
        VALUE(ev_xstring) TYPE xstring.

    CLASS-METHODS string_to_solix
      IMPORTING
        iv_string   TYPE string
        iv_codepage TYPE abap_encod OPTIONAL
        iv_add_bom  TYPE abap_bool OPTIONAL
      EXPORTING
        et_solix    TYPE solix_tab
        ev_size     TYPE so_obj_len
      RAISING
        cx_bcs.

    CLASS-METHODS string_to_xstring
      IMPORTING
        iv_string         TYPE string
        iv_codepage       TYPE abap_encod OPTIONAL
        iv_add_bom        TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(ev_xstring) TYPE xstring
      RAISING
        cx_bcs.

    CLASS-METHODS xtab_to_xstring
      IMPORTING
        it_xtab           TYPE STANDARD TABLE
        iv_size           TYPE i OPTIONAL
      RETURNING
        VALUE(ev_xstring) TYPE xstring.

    CLASS-METHODS otf_to_solix
      IMPORTING
        it_soli         TYPE soli_tab
      RETURNING
        VALUE(et_solix) TYPE solix_tab
      RAISING
        cx_bcs.

ENDCLASS.

CLASS cl_bcs_convert IMPLEMENTATION.
  METHOD string_to_xstring.
    IF iv_codepage IS NOT INITIAL AND iv_codepage <> '4110'.
      ASSERT 1 = 'todo'.
    ENDIF.

    ev_xstring = cl_abap_conv_codepage=>create_out( )->convert( iv_string ).

    IF iv_add_bom = abap_true.
      CONCATENATE cl_abap_char_utilities=>byte_order_mark_utf8 ev_xstring INTO ev_xstring IN BYTE MODE.
    ENDIF.
  ENDMETHOD.

  METHOD xtab_to_xstring.
    FIELD-SYMBOLS <ls_row> TYPE any.
    FIELD-SYMBOLS <lv_data> TYPE any.

    LOOP AT it_xtab ASSIGNING <ls_row>.
      ASSIGN COMPONENT 1 OF STRUCTURE <ls_row> TO <lv_data>.
      IF sy-subrc <> 0.
        ASSIGN <ls_row> TO <lv_data>.
      ENDIF.
      CONCATENATE ev_xstring <lv_data> INTO ev_xstring IN BYTE MODE.
    ENDLOOP.

    IF iv_size IS SUPPLIED AND iv_size < xstrlen( ev_xstring ).
      ev_xstring = ev_xstring(iv_size).
    ENDIF.
  ENDMETHOD.

  METHOD otf_to_solix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD string_to_solix.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD string_to_soli.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD solix_to_xstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD xstring_to_solix.
    DATA lv_offset TYPE i.
    DATA lv_length TYPE i.
    DATA lv_remaining TYPE i.
    DATA ls_solix TYPE solix.

    lv_remaining = xstrlen( iv_xstring ).
    WHILE lv_remaining > 0.
      lv_length = lv_remaining.
      IF lv_length > 255.
        lv_length = 255.
      ENDIF.
      ls_solix-line = iv_xstring+lv_offset(lv_length).
      APPEND ls_solix TO et_solix.
      lv_offset = lv_offset + lv_length.
      lv_remaining = lv_remaining - lv_length.
    ENDWHILE.
  ENDMETHOD.

  METHOD raw_to_string.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
