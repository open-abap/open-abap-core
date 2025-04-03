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
    IF handle IS NOT BOUND.
      RAISE EXCEPTION TYPE cx_sy_ref_is_initial.
    ENDIF.

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
    DATA field         TYPE REF TO data.
    DATA lv_name       TYPE string.

    FIELD-SYMBOLS <ls_component> LIKE LINE OF lt_components.

    lo_struct ?= handle.
    lt_components = lo_struct->get_components( ).
    WRITE '@KERNEL let obj = {};'.
    LOOP AT lt_components ASSIGNING <ls_component>.
*      WRITE '@KERNEL console.dir(ls_component.get().name);'.
      call(
        EXPORTING
          handle = lo_struct->get_component_type( <ls_component>-name )
        CHANGING
          dref   = field ).
      lv_name = to_lower( <ls_component>-name ).
      WRITE '@KERNEL obj[lv_name.get()] = field.getPointer();'.
    ENDLOOP.
    WRITE '@KERNEL dref.assign(new abap.types.Structure(obj));'.
  ENDMETHOD.

  METHOD table.
    DATA lo_table     TYPE REF TO cl_abap_tabledescr.
    DATA lt_keys      TYPE abap_table_keydescr_tab.
    DATA lv_component TYPE string.
    DATA field        TYPE REF TO data.

    FIELD-SYMBOLS <ls_key> LIKE LINE OF lt_keys.

    lo_table ?= handle.

    call(
      EXPORTING
        handle = lo_table->get_table_line_type( )
      CHANGING
        dref   = field ).

    WRITE '@KERNEL let options = {primaryKey: undefined, keyType: "DEFAULT", withHeader: false};'.
    WRITE '@KERNEL options.primaryKey = {name: "primary_key", type: "STANDARD", keyFields: [], isUnique: false};'.

* todo, handle secondary keys,
    lt_keys = lo_table->get_keys( ).
    LOOP AT lt_keys ASSIGNING <ls_key> WHERE is_primary = abap_true.
      IF <ls_key>-access_kind = cl_abap_tabledescr=>tablekind_sorted.
        WRITE '@KERNEL options.primaryKey.type = "SORTED";'.
      ELSEIF <ls_key>-access_kind = cl_abap_tabledescr=>tablekind_hashed.
        WRITE '@KERNEL options.primaryKey.type = "HASHED";'.
      ENDIF.
      IF <ls_key>-is_unique = abap_true.
        WRITE '@KERNEL options.primaryKey.isUnique = true;'.
      ENDIF.
      LOOP AT <ls_key>-components INTO lv_component.
        WRITE '@KERNEL options.primaryKey.keyFields.push(lv_component.get().toLowerCase());'.
      ENDLOOP.
    ENDLOOP.

    WRITE '@KERNEL dref.assign(abap.types.TableFactory.construct(field.getPointer(), options));'.
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
      WHEN cl_abap_typedescr=>typekind_utclong.
        CREATE DATA dref TYPE utclong.
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
      WHEN cl_abap_typedescr=>typekind_int8.
        CREATE DATA dref TYPE int8.
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(handle);'.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.