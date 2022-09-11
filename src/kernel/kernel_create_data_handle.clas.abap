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
ENDCLASS.

CLASS kernel_create_data_handle IMPLEMENTATION.

  METHOD call.
    ASSERT handle IS BOUND.

    CASE handle->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        elem( EXPORTING handle = handle
              CHANGING dref = dref ).
      WHEN cl_abap_typedescr=>kind_struct.
        struct( EXPORTING handle = handle
                CHANGING dref = dref ).
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(handle);'.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

  METHOD struct.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.

    lo_struct ?= handle.
    lt_components = lo_struct->get_components( ).
    LOOP AT lt_components INTO ls_component.
      WRITE '@KERNEL console.dir(ls_component.get().name);'.
    ENDLOOP.
  ENDMETHOD.

  METHOD elem.
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
      WHEN cl_abap_typedescr=>typekind_char.
        CREATE DATA dref TYPE c LENGTH handle->length.
      WHEN cl_abap_typedescr=>typekind_time.
        CREATE DATA dref TYPE t.
      WHEN OTHERS.
        WRITE '@KERNEL console.dir(handle);'.
        ASSERT 1 = 'todo'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.