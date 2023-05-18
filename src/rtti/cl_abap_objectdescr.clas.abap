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

    TYPES: BEGIN OF ty_attribute_types,
             name TYPE abap_attrname,
             type TYPE REF TO cl_abap_datadescr,
           END OF ty_attribute_types.
    DATA mt_attribute_types TYPE STANDARD TABLE OF ty_attribute_types WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_parameter_types,
             method    TYPE string,
             parameter TYPE string,
             type      TYPE any,
           END OF ty_parameter_types.
    DATA mt_parameter_types TYPE STANDARD TABLE OF ty_parameter_types WITH DEFAULT KEY.
ENDCLASS.

CLASS cl_abap_objectdescr IMPLEMENTATION.

  METHOD constructor.
    DATA lv_name  TYPE abap_attrname.
    DATA lv_char1 TYPE c LENGTH 1.
    DATA lv_any   TYPE string.

    FIELD-SYMBOLS <attr>      TYPE abap_attrdescr.
    FIELD-SYMBOLS <intf>      TYPE abap_intfdescr.
    FIELD-SYMBOLS <method>    TYPE abap_methdescr.
    FIELD-SYMBOLS <parameter> TYPE abap_parmdescr.
    FIELD-SYMBOLS <atype>     LIKE LINE OF mt_attribute_types.
    FIELD-SYMBOLS <ptype>     LIKE LINE OF mt_parameter_types.

* set attributes
    WRITE '@KERNEL for (const a in p_object.ATTRIBUTES || []) {'.
    WRITE '@KERNEL   lv_name.set(a);'.
    APPEND INITIAL LINE TO attributes ASSIGNING <attr>.
    APPEND INITIAL LINE TO mt_attribute_types ASSIGNING <atype>.
    <attr>-name = lv_name.
    <atype>-name = lv_name.
    <attr>-is_interface = boolc( lv_name CA '~' ).
    WRITE '@KERNEL   lv_char1.set(p_object.ATTRIBUTES[a].is_constant);'.
    <attr>-is_constant = lv_char1.
    WRITE '@KERNEL   lv_char1.set(p_object.ATTRIBUTES[a].is_class || "");'.
    <attr>-is_class = lv_char1.
    WRITE '@KERNEL   lv_char1.set(p_object.ATTRIBUTES[a].visibility);'.
    <attr>-visibility = lv_char1.
    WRITE '@KERNEL   lv_any = p_object.ATTRIBUTES[a].type();'.
    <atype>-type ?= describe_by_data( lv_any ).
    <attr>-type_kind = <atype>-type->type_kind.
    <attr>-length = <atype>-type->length.
    <attr>-decimals = <atype>-type->decimals.
    WRITE '@KERNEL }'.
    SORT attributes BY name ASCENDING.

* set interfaces
    WRITE '@KERNEL for (const a of p_object.IMPLEMENTED_INTERFACES || []) {'.
    WRITE '@KERNEL   lv_name.set(a);'.
    APPEND INITIAL LINE TO interfaces ASSIGNING <intf>.
    <intf>-name = lv_name.
    WRITE '@KERNEL }'.
    SORT interfaces BY name ASCENDING.

* set methods
    WRITE '@KERNEL for (const a in p_object.METHODS || []) {'.
    WRITE '@KERNEL   lv_name.set(a);'.
    APPEND INITIAL LINE TO methods ASSIGNING <method>.
    <method>-name = lv_name.
    WRITE '@KERNEL   lv_char1.set(p_object.METHODS[a].visibility);'.
    <method>-visibility = lv_char1.
* set parameters of methods
    WRITE '@KERNEL for (const p in p_object.METHODS[a].parameters || []) {'.
    APPEND INITIAL LINE TO mt_parameter_types ASSIGNING <ptype>.
    APPEND INITIAL LINE TO <method>-parameters ASSIGNING <parameter>.
    <ptype>-method = <method>-name.
    WRITE '@KERNEL   lv_name.set(p);'.
    <parameter>-name = lv_name.
    <ptype>-parameter = lv_name.
    WRITE '@KERNEL   lv_any = p_object.METHODS[a].parameters[p].type();'.
* hmm, cannot call describe_by_data() here, as it can cause inifnite recursion
    <ptype>-type = lv_any.
"     <parameter>-type_kind = <ptype>-type->type_kind.
"     <parameter>-length = <ptype>-type->length.
"     <parameter>-decimals = <ptype>-type->decimals.
" * todo, set PARAM_KIND
    WRITE '@KERNEL }'.
    WRITE '@KERNEL }'.
    SORT methods BY name ASCENDING.

    super->constructor( ).
  ENDMETHOD.

  METHOD get_method_parameter_type.
    DATA ls_row LIKE LINE OF mt_parameter_types.
*    WRITE '@KERNEL   this.mt_parameter_types.array().map(e => console.dir(e.get()));'.
    READ TABLE mt_parameter_types INTO ls_row WITH KEY method = p_method_name parameter = p_parameter_name.
    IF sy-subrc = 0.
      p_descr_ref ?= describe_by_data( ls_row-type ).
    ELSE.
      RAISE parameter_not_found.
    ENDIF.
  ENDMETHOD.

  METHOD get_interface_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_attribute_type.
    DATA lv_name TYPE abap_attrname.
    DATA ls_type LIKE LINE OF mt_attribute_types.

    lv_name = to_upper( p_name ).
    READ TABLE mt_attribute_types INTO ls_type WITH KEY name = lv_name.
    IF sy-subrc <> 0.
      RAISE attribute_not_found.
    ENDIF.
    p_descr_ref = ls_type-type.
  ENDMETHOD.
ENDCLASS.