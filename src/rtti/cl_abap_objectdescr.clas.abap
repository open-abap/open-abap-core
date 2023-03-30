CLASS cl_abap_objectdescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.
  PUBLIC SECTION.
    CONSTANTS changing  TYPE abap_parmkind VALUE 'C'.
    CONSTANTS exporting TYPE abap_parmkind VALUE 'E'.
    CONSTANTS importing TYPE abap_parmkind VALUE 'I'.
    CONSTANTS receiving TYPE abap_parmkind VALUE 'R'.
    CONSTANTS returning TYPE abap_parmkind VALUE 'R'.

    CONSTANTS private   TYPE abap_visibility VALUE 'I'.
    CONSTANTS protected TYPE abap_visibility VALUE 'O'.
    CONSTANTS public    TYPE abap_visibility VALUE 'U'.

    DATA attributes TYPE abap_attrdescr_tab READ-ONLY.
    DATA methods    TYPE abap_methdescr_tab READ-ONLY.
    DATA interfaces TYPE abap_intfdescr_tab READ-ONLY.

    METHODS constructor
      IMPORTING
        p_object TYPE any OPTIONAL.

    METHODS get_attribute_type
      IMPORTING
        p_name TYPE any
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_datadescr.

    METHODS get_method_parameter_type
      IMPORTING
        p_method_name      TYPE any
        p_parameter_name   TYPE any
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_datadescr
      EXCEPTIONS
        parameter_not_found
        method_not_found.

    METHODS get_interface_type
      IMPORTING
        p_name             TYPE any
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_intfdescr
      EXCEPTIONS
        interface_not_found.

  PROTECTED SECTION.
    DATA mv_object_name TYPE string.
    DATA mv_object_type TYPE string.
    DATA mo_object      TYPE REF TO object.
ENDCLASS.

CLASS cl_abap_objectdescr IMPLEMENTATION.

  METHOD constructor.
    DATA lv_name TYPE string.
    FIELD-SYMBOLS <fs> TYPE abap_attrdescr.

    IF p_object IS NOT INITIAL.
      WRITE '@KERNEL for (const a in p_object.get()) {'.
      WRITE '@KERNEL   lv_name.set(a)'.
      IF lv_name <> 'me'.
        APPEND INITIAL LINE TO attributes ASSIGNING <fs>.
        <fs>-name = to_upper( lv_name ).
      ENDIF.
      WRITE '@KERNEL }'.
      SORT attributes BY name ASCENDING.
    ENDIF.

    mo_object = p_object.

    super->constructor( ).
  ENDMETHOD.

  METHOD get_method_parameter_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_interface_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_attribute_type.
    DATA lv_name TYPE string.
    DATA l_sub   TYPE string.
    DATA l_any   TYPE string.

    lv_name = to_lower( p_name ).

    IF mv_object_name IS INITIAL.
      WRITE '@KERNEL l_any = this.mo_object.get()[lv_name.get()];'.

    ELSE.
      WRITE '@KERNEL const foo = abap.Classes[this.mv_object_name.get()];'.

      CONCATENATE mv_object_name '$' lv_name INTO l_sub.
      l_sub = to_lower( l_sub ).

      " note that the typing here is misused
      WRITE '@KERNEL l_any = foo[l_sub.get()];'.
    ENDIF.

    p_descr_ref ?= describe_by_data( l_any ).
  ENDMETHOD.
ENDCLASS.