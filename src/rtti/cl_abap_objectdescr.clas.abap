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

    DATA types TYPE abap_typedef_tab READ-ONLY.
    DATA events TYPE abap_evntdescr_tab READ-ONLY.

    CLASS-METHODS _construct
      IMPORTING
        p_object     TYPE any OPTIONAL
      RETURNING
        VALUE(descr) TYPE REF TO cl_abap_objectdescr.

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
    TYPES: BEGIN OF ty_cache,
             name  TYPE string,
             descr TYPE REF TO cl_abap_objectdescr,
           END OF ty_cache.
    CLASS-DATA mt_cache TYPE SORTED TABLE OF ty_cache WITH UNIQUE KEY name.

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
             type      TYPE REF TO data,
             type_kind TYPE abap_typekind,
           END OF ty_parameter_types.
    DATA mt_parameter_types TYPE STANDARD TABLE OF ty_parameter_types WITH DEFAULT KEY.

    CLASS-METHODS add_attributes
      IMPORTING
        p_object TYPE any
        descr    TYPE REF TO cl_abap_objectdescr.
ENDCLASS.

CLASS cl_abap_objectdescr IMPLEMENTATION.

  METHOD _construct.
    DATA lv_name      TYPE abap_attrname.
    DATA lv_char1     TYPE c LENGTH 1.
    DATA lv_any       TYPE string.
    DATA lo_type      TYPE REF TO cl_abap_typedescr.
    DATA lv_type_name TYPE string.
    DATA lv_parm_kind  TYPE abap_parmkind.

    FIELD-SYMBOLS <intf>      TYPE abap_intfdescr.
    FIELD-SYMBOLS <method>    TYPE abap_methdescr.
    FIELD-SYMBOLS <parameter> TYPE abap_parmdescr.
    FIELD-SYMBOLS <ptype>     LIKE LINE OF mt_parameter_types.

    WRITE '@KERNEL lv_name.set(p_object.INTERNAL_NAME);'.
    READ TABLE mt_cache INTO DATA(ls_cache) WITH KEY name = lv_name.
    IF sy-subrc = 0.
      descr = ls_cache-descr.
      RETURN.
    ENDIF.

    WRITE '@KERNEL if (p_object.INTERNAL_TYPE === "CLAS") {'.
    CREATE OBJECT descr TYPE cl_abap_classdescr.
    WRITE '@KERNEL } else {'.
    CREATE OBJECT descr TYPE cl_abap_intfdescr.
    WRITE '@KERNEL }'.
    INSERT VALUE #( name = lv_name descr = descr ) INTO TABLE mt_cache.

    add_attributes( p_object = p_object
                    descr = descr ).

* set interfaces
    WRITE '@KERNEL for (const a of p_object?.IMPLEMENTED_INTERFACES || []) {'.
    WRITE '@KERNEL   lv_name.set(a);'.
    APPEND INITIAL LINE TO descr->interfaces ASSIGNING <intf>.
    <intf>-name = lv_name.
    WRITE '@KERNEL }'.
    SORT descr->interfaces BY name ASCENDING.

* set methods
    WRITE '@KERNEL for (const a in p_object?.METHODS || []) {'.
    WRITE '@KERNEL   lv_name.set(a);'.
    APPEND INITIAL LINE TO descr->methods ASSIGNING <method>.
    <method>-name = lv_name.
    WRITE '@KERNEL   lv_char1.set(p_object.METHODS[a].visibility);'.
    <method>-visibility = lv_char1.
* set parameters of methods
    WRITE '@KERNEL for (const p in p_object.METHODS[a].parameters || []) {'.
    APPEND INITIAL LINE TO descr->mt_parameter_types ASSIGNING <ptype>.
    APPEND INITIAL LINE TO <method>-parameters ASSIGNING <parameter>.
    <ptype>-method = <method>-name.
    WRITE '@KERNEL   lv_name.set(p);'.
    <parameter>-name = lv_name.
    <ptype>-parameter = lv_name.
    WRITE '@KERNEL   lv_any = p_object.METHODS[a].parameters[p].type();'.
    WRITE '@KERNEL   lv_type_name = p_object.METHODS[a].parameters[p].type_name;'.
    WRITE '@KERNEL   lv_parm_kind = p_object.METHODS[a].parameters[p].parm_kind;'.

    IF lv_type_name = 'CLikeType'.
      <parameter>-type_kind = cl_abap_typedescr=>typekind_clike.
      <ptype>-type_kind = cl_abap_typedescr=>typekind_clike.
    ELSEIF lv_type_name = 'CSequenceType'.
      <parameter>-type_kind = cl_abap_typedescr=>typekind_csequence.
      <ptype>-type_kind = cl_abap_typedescr=>typekind_csequence.
    ELSE.
      GET REFERENCE OF lv_any INTO <ptype>-type.
"       WRITE '@KERNEL   if (lv_any.constructor.name === "ABAPObject") {'.
" * avoid recursion into objects
"       <parameter>-type_kind = cl_abap_typedescr=>typekind_oref.
"       WRITE '@KERNEL   } else {'.
      lo_type = describe_by_data( lv_any ).
      <parameter>-type_kind = lo_type->type_kind.
      <parameter>-length = lo_type->length.
      <parameter>-decimals = lo_type->decimals.
      " WRITE '@KERNEL   }'.
    ENDIF.
    <parameter>-parm_kind = lv_parm_kind.
    WRITE '@KERNEL }'.
    WRITE '@KERNEL }'.
    SORT descr->methods BY name ASCENDING.


  ENDMETHOD.

  METHOD add_attributes.

    DATA lv_name  TYPE abap_attrname.
    DATA lv_char1 TYPE c LENGTH 1.
    DATA lv_any   TYPE string.

    FIELD-SYMBOLS <attr>  TYPE abap_attrdescr.
    FIELD-SYMBOLS <atype> LIKE LINE OF mt_attribute_types.

    WRITE '@KERNEL const allAttributes = p_object?.ATTRIBUTES || [];'.
    WRITE '@KERNEL let currentObj = p_object?.STATIC_SUPER;'.
    WRITE '@KERNEL while (currentObj !== undefined) {'.
    WRITE '@KERNEL   allAttributes.push(...currentObj.ATTRIBUTES);'.
    WRITE '@KERNEL   currentObj = currentObj.STATIC_SUPER;'.
    WRITE '@KERNEL }'.

* set attributes
    WRITE '@KERNEL for (const a in allAttributes) {'.
    WRITE '@KERNEL   lv_name.set(a);'.
    APPEND INITIAL LINE TO descr->attributes ASSIGNING <attr>.
    APPEND INITIAL LINE TO descr->mt_attribute_types ASSIGNING <atype>.
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
"     WRITE '@KERNEL   if (lv_any.constructor.name === "ABAPObject") {'.
" * avoid recursion into objects
"     <attr>-type_kind = cl_abap_typedescr=>typekind_oref.
"     WRITE '@KERNEL   } else {'.
    <atype>-type ?= describe_by_data( lv_any ).
    <attr>-type_kind = <atype>-type->type_kind.
    <attr>-length = <atype>-type->length.
    <attr>-decimals = <atype>-type->decimals.
    " WRITE '@KERNEL   }'.
    WRITE '@KERNEL }'.
    SORT descr->attributes BY is_interface DESCENDING name ASCENDING.

  ENDMETHOD.

  METHOD get_method_parameter_type.
    DATA ls_row LIKE LINE OF mt_parameter_types.
    FIELD-SYMBOLS <type> TYPE any.

    READ TABLE mt_parameter_types INTO ls_row WITH KEY method = p_method_name parameter = p_parameter_name.
    IF sy-subrc <> 0.
      RAISE parameter_not_found.
    ENDIF.

    IF ls_row-type_kind = cl_abap_typedescr=>typekind_clike.
      CREATE OBJECT p_descr_ref TYPE cl_abap_elemdescr.
      p_descr_ref->absolute_name = '\TYPE=CLIKE'.
      p_descr_ref->kind = cl_abap_elemdescr=>kind_elem.
      p_descr_ref->type_kind = cl_abap_typedescr=>typekind_clike.
    ELSEIF ls_row-type_kind = cl_abap_typedescr=>typekind_csequence.
      CREATE OBJECT p_descr_ref TYPE cl_abap_elemdescr.
      p_descr_ref->absolute_name = '\TYPE=CSEQUENCE'.
      p_descr_ref->kind = cl_abap_elemdescr=>kind_elem.
      p_descr_ref->type_kind = cl_abap_typedescr=>typekind_csequence.
    ELSE.
      ASSIGN ls_row-type->* TO <type>.
      p_descr_ref ?= describe_by_data( <type> ).
    ENDIF.
  ENDMETHOD.

  METHOD get_interface_type.

    p_descr_ref ?= cl_abap_intfdescr=>describe_by_name( p_name ).

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
    ASSERT p_descr_ref IS NOT INITIAL.
  ENDMETHOD.
ENDCLASS.
