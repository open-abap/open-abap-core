CLASS cl_abap_corresponding DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF mapping_info,
        level   TYPE i,
        kind    TYPE i,
        srcname TYPE string,
        dstname TYPE string,
      END OF mapping_info.
    TYPES mapping_table TYPE STANDARD TABLE OF mapping_info WITH DEFAULT KEY.

    CONSTANTS mapping_component             TYPE i VALUE 1.
    CONSTANTS mapping_except_component      TYPE i VALUE 2.
    CONSTANTS mapping_except_all            TYPE i VALUE 3.
    CONSTANTS mapping_discarding_duplicates TYPE i VALUE 9.

    CLASS-METHODS create
      IMPORTING
        source                TYPE any
        destination           TYPE any
        mapping               TYPE mapping_table OPTIONAL
        discarding_duplicates TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(result)         TYPE REF TO cl_abap_corresponding
      RAISING
        cx_corr_dyn_error.

    METHODS execute
      IMPORTING
        source      TYPE any
      CHANGING
        destination TYPE any
      RAISING
        cx_corr_dyn_error.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_rule,
        kind    TYPE i,
        srcname TYPE string,
        dstname TYPE string,
        from    TYPE i,
        to      TYPE i,
      END OF ty_rule.
    TYPES ty_rules TYPE STANDARD TABLE OF ty_rule WITH EMPTY KEY.

    DATA mt_mapping TYPE mapping_table.
    DATA mv_source_kind TYPE abap_typekind.
    DATA mv_destination_kind TYPE abap_typekind.
    DATA mv_discarding_duplicates TYPE abap_bool.

    METHODS get_rules
      IMPORTING
        iv_from         TYPE i
        iv_to           TYPE i
        iv_level        TYPE i
      RETURNING
        VALUE(rt_rules) TYPE ty_rules
      RAISING
        cx_corr_dyn_error.

    METHODS check
      IMPORTING
        io_source      TYPE REF TO cl_abap_datadescr
        io_destination TYPE REF TO cl_abap_datadescr
        iv_from        TYPE i
        iv_to          TYPE i
        iv_level       TYPE i
      RAISING
        cx_corr_dyn_error.

    METHODS move
      IMPORTING
        source         TYPE any
        io_source      TYPE REF TO cl_abap_datadescr
        io_destination TYPE REF TO cl_abap_datadescr
        iv_from        TYPE i
        iv_to          TYPE i
        iv_level       TYPE i
      CHANGING
        destination    TYPE any
      RAISING
        cx_corr_dyn_error.

    METHODS move_structure
      IMPORTING
        source         TYPE any
        io_source      TYPE REF TO cl_abap_structdescr
        io_destination TYPE REF TO cl_abap_structdescr
        iv_from        TYPE i
        iv_to          TYPE i
        iv_level       TYPE i
      CHANGING
        destination    TYPE any
      RAISING
        cx_corr_dyn_error.

    METHODS move_table
      IMPORTING
        source         TYPE any
        io_source      TYPE REF TO cl_abap_tabledescr
        io_destination TYPE REF TO cl_abap_tabledescr
        iv_from        TYPE i
        iv_to          TYPE i
        iv_level       TYPE i
      CHANGING
        destination    TYPE any
      RAISING
        cx_corr_dyn_error.

    CLASS-METHODS has_component
      IMPORTING
        io_struct     TYPE REF TO cl_abap_structdescr
        iv_name       TYPE string
      RETURNING
        VALUE(rv_has) TYPE abap_bool.
ENDCLASS.

CLASS cl_abap_corresponding IMPLEMENTATION.

  METHOD create.
    DATA lo_source      TYPE REF TO cl_abap_datadescr.
    DATA lo_destination TYPE REF TO cl_abap_datadescr.
    DATA ls_mapping     LIKE LINE OF mapping.
    DATA lv_ok          TYPE abap_bool.

    lo_source ?= cl_abap_typedescr=>describe_by_data( source ).
    lo_destination ?= cl_abap_typedescr=>describe_by_data( destination ).

    lv_ok = abap_false.
    IF lo_source->kind = cl_abap_typedescr=>kind_struct
        AND lo_destination->kind = cl_abap_typedescr=>kind_struct.
      lv_ok = abap_true.
    ELSEIF lo_source->kind = cl_abap_typedescr=>kind_table
        AND lo_destination->kind = cl_abap_typedescr=>kind_table.
      lv_ok = abap_true.
    ENDIF.
    IF lv_ok = abap_false.
      RAISE EXCEPTION TYPE cx_corr_dyn_error.
    ENDIF.

    CREATE OBJECT result.
    result->mv_source_kind = lo_source->kind.
    result->mv_destination_kind = lo_destination->kind.
    result->mv_discarding_duplicates = discarding_duplicates.

    LOOP AT mapping INTO ls_mapping.
      IF ls_mapping-kind = mapping_discarding_duplicates.
        result->mv_discarding_duplicates = abap_true.
        CONTINUE.
      ENDIF.
      IF ls_mapping-kind <> mapping_component
          AND ls_mapping-kind <> mapping_except_component
          AND ls_mapping-kind <> mapping_except_all.
        RAISE EXCEPTION TYPE cx_corr_dyn_error.
      ENDIF.
      ls_mapping-srcname = to_upper( condense( ls_mapping-srcname ) ).
      ls_mapping-dstname = to_upper( condense( ls_mapping-dstname ) ).
      APPEND ls_mapping TO result->mt_mapping.
    ENDLOOP.

    result->check(
      io_source      = lo_source
      io_destination = lo_destination
      iv_from        = 1
      iv_to          = lines( result->mt_mapping )
      iv_level       = 0 ).
  ENDMETHOD.

  METHOD execute.
    DATA lo_source      TYPE REF TO cl_abap_datadescr.
    DATA lo_destination TYPE REF TO cl_abap_datadescr.

    lo_source ?= cl_abap_typedescr=>describe_by_data( source ).
    lo_destination ?= cl_abap_typedescr=>describe_by_data( destination ).
    IF lo_source->kind <> mv_source_kind OR lo_destination->kind <> mv_destination_kind.
      RAISE EXCEPTION TYPE cx_corr_dyn_error.
    ENDIF.

    move(
      EXPORTING
        source         = source
        io_source      = lo_source
        io_destination = lo_destination
        iv_from        = 1
        iv_to          = lines( mt_mapping )
        iv_level       = 0
      CHANGING
        destination    = destination ).
  ENDMETHOD.

  METHOD get_rules.
* rows iv_from to iv_to describe one level, a row on level n + 1 belongs to the
* nearest preceding row on level n, ie. it maps components of that sub structure
    DATA ls_mapping LIKE LINE OF mt_mapping.
    DATA ls_rule    LIKE LINE OF rt_rules.
    DATA lv_index   TYPE i.
    FIELD-SYMBOLS <ls_rule> LIKE LINE OF rt_rules.

    lv_index = iv_from.
    WHILE lv_index <= iv_to.
      READ TABLE mt_mapping INDEX lv_index INTO ls_mapping.
      IF ls_mapping-level = iv_level.
        CLEAR ls_rule.
        ls_rule-kind    = ls_mapping-kind.
        ls_rule-srcname = ls_mapping-srcname.
        ls_rule-dstname = ls_mapping-dstname.
        ls_rule-from    = lv_index + 1.
        ls_rule-to      = lv_index.
        APPEND ls_rule TO rt_rules ASSIGNING <ls_rule>.
      ELSEIF ls_mapping-level > iv_level AND <ls_rule> IS ASSIGNED.
        <ls_rule>-to = lv_index.
      ELSE.
        RAISE EXCEPTION TYPE cx_corr_dyn_error.
      ENDIF.
      lv_index = lv_index + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD check.
    DATA lt_rules       TYPE ty_rules.
    DATA ls_rule        LIKE LINE OF lt_rules.
    DATA lo_src_struct  TYPE REF TO cl_abap_structdescr.
    DATA lo_dst_struct  TYPE REF TO cl_abap_structdescr.
    DATA lo_src_table   TYPE REF TO cl_abap_tabledescr.
    DATA lo_dst_table   TYPE REF TO cl_abap_tabledescr.
    DATA lo_src_comp    TYPE REF TO cl_abap_datadescr.
    DATA lo_dst_comp    TYPE REF TO cl_abap_datadescr.

    IF iv_from > iv_to.
      RETURN.
    ENDIF.

    IF io_source->kind = cl_abap_typedescr=>kind_table
        AND io_destination->kind = cl_abap_typedescr=>kind_table.
      lo_src_table ?= io_source.
      lo_dst_table ?= io_destination.
      check(
        io_source      = lo_src_table->get_table_line_type( )
        io_destination = lo_dst_table->get_table_line_type( )
        iv_from        = iv_from
        iv_to          = iv_to
        iv_level       = iv_level ).
      RETURN.
    ENDIF.

    IF io_source->kind <> cl_abap_typedescr=>kind_struct
        OR io_destination->kind <> cl_abap_typedescr=>kind_struct.
      RAISE EXCEPTION TYPE cx_corr_dyn_error.
    ENDIF.
    lo_src_struct ?= io_source.
    lo_dst_struct ?= io_destination.

    lt_rules = get_rules(
      iv_from  = iv_from
      iv_to    = iv_to
      iv_level = iv_level ).

    LOOP AT lt_rules INTO ls_rule.
      CASE ls_rule-kind.
        WHEN mapping_component.
          IF has_component( io_struct = lo_src_struct
                            iv_name   = ls_rule-srcname ) = abap_false
              OR has_component( io_struct = lo_dst_struct
                                iv_name   = ls_rule-dstname ) = abap_false.
            RAISE EXCEPTION TYPE cx_corr_dyn_error.
          ENDIF.
          IF ls_rule-from <= ls_rule-to.
            lo_src_comp = lo_src_struct->get_component_type( ls_rule-srcname ).
            lo_dst_comp = lo_dst_struct->get_component_type( ls_rule-dstname ).
            check(
              io_source      = lo_src_comp
              io_destination = lo_dst_comp
              iv_from        = ls_rule-from
              iv_to          = ls_rule-to
              iv_level       = iv_level + 1 ).
          ENDIF.
        WHEN mapping_except_component.
* the excluded component is a component of the source structure, given in SRCNAME
          IF has_component( io_struct = lo_src_struct
                            iv_name   = ls_rule-srcname ) = abap_false
              OR ls_rule-from <= ls_rule-to.
            RAISE EXCEPTION TYPE cx_corr_dyn_error.
          ENDIF.
        WHEN mapping_except_all.
          IF ls_rule-from <= ls_rule-to.
            RAISE EXCEPTION TYPE cx_corr_dyn_error.
          ENDIF.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD has_component.
    READ TABLE io_struct->components WITH KEY name = iv_name TRANSPORTING NO FIELDS.
    rv_has = boolc( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD move.
    DATA lo_src_struct TYPE REF TO cl_abap_structdescr.
    DATA lo_dst_struct TYPE REF TO cl_abap_structdescr.
    DATA lo_src_table  TYPE REF TO cl_abap_tabledescr.
    DATA lo_dst_table  TYPE REF TO cl_abap_tabledescr.

    IF io_source->kind = cl_abap_typedescr=>kind_struct
        AND io_destination->kind = cl_abap_typedescr=>kind_struct.
      lo_src_struct ?= io_source.
      lo_dst_struct ?= io_destination.
      move_structure(
        EXPORTING
          source         = source
          io_source      = lo_src_struct
          io_destination = lo_dst_struct
          iv_from        = iv_from
          iv_to          = iv_to
          iv_level       = iv_level
        CHANGING
          destination    = destination ).
    ELSEIF io_source->kind = cl_abap_typedescr=>kind_table
        AND io_destination->kind = cl_abap_typedescr=>kind_table.
      lo_src_table ?= io_source.
      lo_dst_table ?= io_destination.
      move_table(
        EXPORTING
          source         = source
          io_source      = lo_src_table
          io_destination = lo_dst_table
          iv_from        = iv_from
          iv_to          = iv_to
          iv_level       = iv_level
        CHANGING
          destination    = destination ).
    ELSE.
      destination = source.
    ENDIF.
  ENDMETHOD.

  METHOD move_structure.
* components of the destination which are not assigned keep their value, like MOVE-CORRESPONDING
    DATA lt_rules      TYPE ty_rules.
    DATA ls_rule       LIKE LINE OF lt_rules.
    DATA lv_except_all TYPE abap_bool.
    DATA lv_srcname    TYPE string.
    DATA lv_dstname    TYPE string.
    DATA lv_from       TYPE i.
    DATA lv_to         TYPE i.
    DATA ls_component  LIKE LINE OF io_destination->components.
    FIELD-SYMBOLS <lg_src> TYPE any.
    FIELD-SYMBOLS <lg_dst> TYPE any.

    IF iv_from <= iv_to.
      lt_rules = get_rules(
        iv_from  = iv_from
        iv_to    = iv_to
        iv_level = iv_level ).
    ENDIF.

    READ TABLE lt_rules WITH KEY kind = mapping_except_all TRANSPORTING NO FIELDS.
    lv_except_all = boolc( sy-subrc = 0 ).

    LOOP AT io_destination->components INTO ls_component.
      lv_dstname = ls_component-name.
      lv_from = 1.
      lv_to = 0.

      READ TABLE lt_rules INTO ls_rule WITH KEY kind = mapping_component dstname = lv_dstname.
      IF sy-subrc = 0.
        lv_srcname = ls_rule-srcname.
        lv_from = ls_rule-from.
        lv_to = ls_rule-to.
      ELSE.
        IF lv_except_all = abap_true.
          CONTINUE.
        ENDIF.
        READ TABLE lt_rules WITH KEY kind = mapping_except_component srcname = lv_dstname TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          CONTINUE.
        ENDIF.
        IF has_component( io_struct = io_source
                          iv_name   = lv_dstname ) = abap_false.
          CONTINUE.
        ENDIF.
        lv_srcname = lv_dstname.
      ENDIF.

      ASSIGN COMPONENT lv_srcname OF STRUCTURE source TO <lg_src>.
      ASSERT sy-subrc = 0.
      ASSIGN COMPONENT lv_dstname OF STRUCTURE destination TO <lg_dst>.
      ASSERT sy-subrc = 0.

      move(
        EXPORTING
          source         = <lg_src>
          io_source      = io_source->get_component_type( lv_srcname )
          io_destination = io_destination->get_component_type( lv_dstname )
          iv_from        = lv_from
          iv_to          = lv_to
          iv_level       = iv_level + 1
        CHANGING
          destination    = <lg_dst> ).
    ENDLOOP.
  ENDMETHOD.

  METHOD move_table.
* the target table is always initialized first
    DATA lo_src_line TYPE REF TO cl_abap_datadescr.
    DATA lo_dst_line TYPE REF TO cl_abap_datadescr.
    DATA lr_row      TYPE REF TO data.
    FIELD-SYMBOLS <lt_src> TYPE ANY TABLE.
    FIELD-SYMBOLS <lt_dst> TYPE ANY TABLE.
    FIELD-SYMBOLS <lg_src> TYPE any.
    FIELD-SYMBOLS <lg_row> TYPE any.

    ASSIGN source TO <lt_src>.
    ASSIGN destination TO <lt_dst>.
    CLEAR <lt_dst>.

    lo_src_line = io_source->get_table_line_type( ).
    lo_dst_line = io_destination->get_table_line_type( ).

    CREATE DATA lr_row LIKE LINE OF <lt_dst>.
    ASSIGN lr_row->* TO <lg_row>.

    LOOP AT <lt_src> ASSIGNING <lg_src>.
      CLEAR <lg_row>.
      move(
        EXPORTING
          source         = <lg_src>
          io_source      = lo_src_line
          io_destination = lo_dst_line
          iv_from        = iv_from
          iv_to          = iv_to
          iv_level       = iv_level
        CHANGING
          destination    = <lg_row> ).
      INSERT <lg_row> INTO TABLE <lt_dst>.
      IF sy-subrc <> 0 AND mv_discarding_duplicates = abap_false.
        RAISE EXCEPTION TYPE cx_sy_itab_duplicate_key.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.