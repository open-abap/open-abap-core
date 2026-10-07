CLASS cl_abap_datadescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.
  PUBLIC SECTION.
    CLASS-METHODS get_data_type_kind
      IMPORTING
        p_data             TYPE data
      RETURNING
        VALUE(p_type_kind) TYPE abap_typekind.

    METHODS applies_to_data
      IMPORTING
        p_data        TYPE data
      RETURNING
        VALUE(p_flag) TYPE abap_bool.

    METHODS applies_to_data_ref
      IMPORTING
        p_data        TYPE REF TO data
      RETURNING
        VALUE(p_flag) TYPE abap_bool.

  PROTECTED SECTION.
    TYPES ty_types TYPE STANDARD TABLE OF REF TO cl_abap_datadescr WITH EMPTY KEY.

    "! compatible as for ABAP data types: the technical properties match, names of components do not matter
    METHODS is_compatible
      IMPORTING
        other         TYPE REF TO cl_abap_typedescr
      RETURNING
        VALUE(p_flag) TYPE abap_bool.

    "! the types of the components of a structure in their order, included structures flattened
    CLASS-METHODS layout
      IMPORTING
        structure       TYPE REF TO cl_abap_structdescr
      RETURNING
        VALUE(rt_types) TYPE ty_types.
ENDCLASS.

CLASS cl_abap_datadescr IMPLEMENTATION.

  METHOD get_data_type_kind.
    DATA descr TYPE REF TO cl_abap_typedescr.
    descr = cl_abap_typedescr=>describe_by_data( p_data ).
    p_type_kind = descr->type_kind.
  ENDMETHOD.

  METHOD applies_to_data.
    p_flag = is_compatible( cl_abap_typedescr=>describe_by_data( p_data ) ).
  ENDMETHOD.

  METHOD applies_to_data_ref.
    FIELD-SYMBOLS <data> TYPE data.

    IF p_data IS INITIAL.
      RETURN.
    ENDIF.
    ASSIGN p_data->* TO <data>.
    p_flag = applies_to_data( <data> ).
  ENDMETHOD.

  METHOD is_compatible.
    DATA lo_this_struct  TYPE REF TO cl_abap_structdescr.
    DATA lo_other_struct TYPE REF TO cl_abap_structdescr.
    DATA lo_this_table   TYPE REF TO cl_abap_tabledescr.
    DATA lo_other_table  TYPE REF TO cl_abap_tabledescr.
    DATA lo_this_line    TYPE REF TO cl_abap_datadescr.
    DATA lo_other_line   TYPE REF TO cl_abap_datadescr.
    DATA lo_this_ref     TYPE REF TO cl_abap_refdescr.
    DATA lo_other_ref    TYPE REF TO cl_abap_refdescr.
    DATA lt_this         TYPE ty_types.
    DATA lt_other        TYPE ty_types.
    DATA lo_this_comp    TYPE REF TO cl_abap_datadescr.
    DATA lo_other_comp   TYPE REF TO cl_abap_datadescr.
    DATA lv_index        TYPE i.

    IF other IS NOT BOUND OR other->kind <> kind OR other->type_kind <> type_kind.
      RETURN.
    ENDIF.

    CASE kind.
      WHEN kind_elem.
        IF type_kind = typekind_enum.
          p_flag = xsdbool( other->absolute_name = absolute_name ).
        ELSE.
          p_flag = xsdbool( other->length = length AND other->decimals = decimals ).
        ENDIF.
      WHEN kind_struct.
        lo_this_struct ?= me.
        lo_other_struct ?= other.
        lt_this = layout( lo_this_struct ).
        lt_other = layout( lo_other_struct ).
        IF lines( lt_this ) <> lines( lt_other ).
          RETURN.
        ENDIF.
        LOOP AT lt_this INTO lo_this_comp.
          lv_index = sy-tabix.
          READ TABLE lt_other INDEX lv_index INTO lo_other_comp.
          IF lo_this_comp->is_compatible( lo_other_comp ) = abap_false.
            RETURN.
          ENDIF.
        ENDLOOP.
        p_flag = abap_true.
      WHEN kind_table.
        lo_this_table ?= me.
        lo_other_table ?= other.
        IF lo_this_table->table_kind <> lo_other_table->table_kind
            OR lo_this_table->has_unique_key <> lo_other_table->has_unique_key
            OR lo_this_table->key_defkind <> lo_other_table->key_defkind
            OR lo_this_table->key <> lo_other_table->key.
          RETURN.
        ENDIF.
        lo_this_line = lo_this_table->get_table_line_type( ).
        lo_other_line = lo_other_table->get_table_line_type( ).
        p_flag = lo_this_line->is_compatible( lo_other_line ).
      WHEN kind_ref.
        lo_this_ref ?= me.
        lo_other_ref ?= other.
        p_flag = xsdbool( lo_this_ref->get_referenced_type( )->absolute_name
          = lo_other_ref->get_referenced_type( )->absolute_name ).
      WHEN OTHERS.
        p_flag = xsdbool( other->absolute_name = absolute_name ).
    ENDCASE.
  ENDMETHOD.

  METHOD layout.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA lo_include    TYPE REF TO cl_abap_structdescr.
    DATA lt_included   TYPE ty_types.

    lt_components = structure->get_components( ).
    LOOP AT lt_components INTO ls_component.
      IF ls_component-as_include = abap_true.
        lo_include ?= ls_component-type.
        lt_included = layout( lo_include ).
        APPEND LINES OF lt_included TO rt_types.
      ELSE.
        APPEND ls_component-type TO rt_types.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
