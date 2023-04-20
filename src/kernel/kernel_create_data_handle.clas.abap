CLASS kernel_create_data_handle DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS call
      IMPORTING
        handle TYPE REF TO cl_abap_datadescr
      CHANGING
        dref   TYPE REF TO any.
  PRIVATE SECTION.
    CLASS-METHODS elem
      IMPORTING
        handle TYPE REF TO cl_abap_datadescr
      CHANGING
        dref   TYPE REF TO any.
    CLASS-METHODS struct
      IMPORTING
        handle TYPE REF TO cl_abap_datadescr
      CHANGING
        dref   TYPE REF TO any.
    CLASS-METHODS table
      IMPORTING
        handle TYPE REF TO cl_abap_datadescr
      CHANGING
        dref   TYPE REF TO any.
    CLASS-METHODS ref
      IMPORTING
        handle TYPE REF TO cl_abap_datadescr
      CHANGING
        dref   TYPE REF TO any.
ENDCLASS.

CLASS kernel_create_data_handle IMPLEMENTATION.

  METHOD call.
    ASSERT handle IS BOUND.

    WRITE '@KERNEL if (dref.constructor.name === "FieldSymbol") {'.
    WRITE '@KERNEL   dref = dref.getPointer();'.
    WRITE '@KERNEL }'.

    CASE handle->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        elem( EXPORTING handle = handle
              CHANGING dref = dref ).
      WHEN cl_abap_typedescr=>kind_struct.
        struct( EXPORTING handle = handle
                CHANGING dref = dref ).
      WHEN cl_abap_typedescr=>kind_table.
        table( EXPORTING handle = handle
               CHANGING dref = dref ).
      WHEN cl_abap_typedescr=>kind_ref.
        ref( EXPORTING handle = handle
             CHANGING dref = dref ).
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(handle);'.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

  METHOD ref.
    DATA lo_ref  TYPE REF TO cl_abap_refdescr.
    DATA lo_data TYPE REF TO cl_abap_datadescr.
    DATA field   TYPE REF TO data.

    lo_ref ?= handle.
    lo_data ?= lo_ref->get_referenced_type( ).
    call(
      EXPORTING
        handle = lo_data
      CHANGING
        dref   = field ).

    WRITE '@KERNEL dref.assign(new abap.types.DataReference(field.getPointer()));'.
  ENDMETHOD.

  METHOD struct.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA field         TYPE REF TO data.

    lo_struct ?= handle.
    lt_components = lo_struct->get_components( ).
    WRITE '@KERNEL let obj = {};'.
    LOOP AT lt_components INTO ls_component.
*      WRITE '@KERNEL console.dir(ls_component.get().name);'.
      call(
        EXPORTING
          handle = lo_struct->get_component_type( ls_component-name )
        CHANGING
          dref   = field ).
      WRITE '@KERNEL obj[ls_component.get().name.get().toLowerCase()] = field.getPointer();'.
    ENDLOOP.
    WRITE '@KERNEL dref.assign(new abap.types.Structure(obj));'.
  ENDMETHOD.

  METHOD table.
    DATA lo_table TYPE REF TO cl_abap_tabledescr.
    DATA field    TYPE REF TO data.

    lo_table ?= handle.

    call(
      EXPORTING
        handle = lo_table->get_table_line_type( )
      CHANGING
        dref   = field ).

    WRITE '@KERNEL dref.assign(new abap.types.Table(field.getPointer()));'.
  ENDMETHOD.

  METHOD elem.
    DATA lv_half TYPE i.
    CASE handle->type_kind.
      WHEN cl_abap_typedescr=>typekind_float.
        CREATE DATA dref TYPE f.
      WHEN cl_abap_typedescr=>typekind_string.
        CREATE DATA dref TYPE string.
      WHEN cl_abap_typedescr=>typekind_xstring.
        CREATE DATA dref TYPE xstring.
      WHEN cl_abap_typedescr=>typekind_int.
        CREATE DATA dref TYPE i.
      WHEN cl_abap_typedescr=>typekind_date.
        CREATE DATA dref TYPE d.
      WHEN cl_abap_typedescr=>typekind_hex.
        CREATE DATA dref TYPE x LENGTH handle->length.
      WHEN cl_abap_typedescr=>typekind_packed.
        CREATE DATA dref TYPE p LENGTH handle->length DECIMALS handle->decimals.
      WHEN cl_abap_typedescr=>typekind_char.
        lv_half = handle->length / 2.
        CREATE DATA dref TYPE c LENGTH lv_half.
* todo, this needs some redesign to work properly,
        WRITE '@KERNEL dref.getPointer().extra = {"qualifiedName": handle.get().relative_name};'.
      WHEN cl_abap_typedescr=>typekind_num.
        lv_half = handle->length / 2.
        CREATE DATA dref TYPE n LENGTH lv_half.
      WHEN cl_abap_typedescr=>typekind_time.
        CREATE DATA dref TYPE t.
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(handle);'.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.