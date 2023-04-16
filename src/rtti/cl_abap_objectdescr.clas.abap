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
        p_name             TYPE any
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_datadescr
      EXCEPTIONS
        attribute_not_found.

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
    TYPES: BEGIN OF ty_types,
             name TYPE abap_attrname,
             type TYPE REF TO cl_abap_datadescr,
           END OF ty_types.
    DATA mt_types TYPE STANDARD TABLE OF ty_types WITH DEFAULT KEY.
ENDCLASS.

CLASS cl_abap_objectdescr IMPLEMENTATION.

  METHOD constructor.
    DATA lv_name  TYPE abap_attrname.
    DATA lv_char1 TYPE c LENGTH 1.
    DATA lv_any   TYPE string.
    FIELD-SYMBOLS <fs> TYPE abap_attrdescr.
    FIELD-SYMBOLS <type> LIKE LINE OF mt_types.

    WRITE '@KERNEL for (const a in p_object.ATTRIBUTES || []) {'.

    WRITE '@KERNEL   lv_name.set(a)'.
    APPEND INITIAL LINE TO attributes ASSIGNING <fs>.
    APPEND INITIAL LINE TO mt_types ASSIGNING <type>.
    <fs>-name = lv_name.
    <type>-name = lv_name.

    WRITE '@KERNEL   lv_char1.set(p_object.ATTRIBUTES[a].is_constant);'.
    <fs>-is_constant = lv_char1.
    WRITE '@KERNEL   lv_char1.set(p_object.ATTRIBUTES[a].visibility);'.
    <fs>-visibility = lv_char1.

    WRITE '@KERNEL   lv_any = p_object.ATTRIBUTES[a].type();'.
    <type>-type ?= describe_by_data( lv_any ).
    <fs>-type_kind = <type>-type->type_kind.
    <fs>-length = <type>-type->length.
    <fs>-decimals = <type>-type->decimals.

    WRITE '@KERNEL }'.
    SORT attributes BY name ASCENDING.

    super->constructor( ).
  ENDMETHOD.

  METHOD get_method_parameter_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_interface_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_attribute_type.
    DATA lv_name TYPE abap_attrname.
    DATA ls_type LIKE LINE OF mt_types.

    lv_name = to_upper( p_name ).
    READ TABLE mt_types INTO ls_type WITH KEY name = lv_name.
    IF sy-subrc <> 0.
      RAISE attribute_not_found.
    ENDIF.
    p_descr_ref = ls_type-type.
  ENDMETHOD.
ENDCLASS.