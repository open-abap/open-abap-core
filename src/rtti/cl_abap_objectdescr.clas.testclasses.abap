CLASS ltcl_foo DEFINITION FOR TESTING FINAL.
  PUBLIC SECTION.
    DATA zzz TYPE i.
    DATA bar TYPE i.
ENDCLASS.

CLASS ltcl_foo IMPLEMENTATION.
ENDCLASS.

CLASS ltcl_visibility DEFINITION FOR TESTING FINAL.
  PROTECTED SECTION.
    DATA bar TYPE i.
ENDCLASS.

CLASS ltcl_visibility IMPLEMENTATION.
ENDCLASS.

INTERFACE lif_intf.
  DATA field TYPE i.
ENDINTERFACE.

CLASS lcl_impl DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_intf.
ENDCLASS.
CLASS lcl_impl IMPLEMENTATION.
ENDCLASS.

CLASS lcl_static DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA foo TYPE string.
    CLASS-METHODS bar.
    METHODS baz.
ENDCLASS.
CLASS lcl_static IMPLEMENTATION.
  METHOD bar.
  ENDMETHOD.

  METHOD baz.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_str DEFINITION.
  PUBLIC SECTION.
    DATA foo TYPE string.
ENDCLASS.
CLASS lcl_str IMPLEMENTATION.
ENDCLASS.

CLASS lcl_pchar30 DEFINITION.
  PUBLIC SECTION.
    METHODS foo IMPORTING bar TYPE char30.
ENDCLASS.
CLASS lcl_pchar30 IMPLEMENTATION.
  METHOD foo.
  ENDMETHOD.
ENDCLASS.

INTERFACE lif.
  DATA bar TYPE i.
ENDINTERFACE.

CLASS lcl_from_intf DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif.
    DATA foo TYPE string.
ENDCLASS.
CLASS lcl_from_intf IMPLEMENTATION.
ENDCLASS.

CLASS lcl_ref2 DEFINITION.
ENDCLASS.
CLASS lcl_ref2 IMPLEMENTATION.
ENDCLASS.
CLASS lcl_ref1 DEFINITION.
  PUBLIC SECTION.
    DATA mo_app TYPE REF TO lcl_ref2.
    METHODS constructor.
ENDCLASS.
CLASS lcl_ref1 IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT mo_app.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ref2_deferred DEFINITION DEFERRED.
CLASS lcl_ref1_deferred DEFINITION.
  PUBLIC SECTION.
    DATA mo_app TYPE REF TO lcl_ref2_deferred.
    METHODS constructor.
ENDCLASS.
CLASS lcl_ref1_deferred IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT mo_app.
  ENDMETHOD.
ENDCLASS.
CLASS lcl_ref2_deferred DEFINITION.
ENDCLASS.
CLASS lcl_ref2_deferred IMPLEMENTATION.
ENDCLASS.

CLASS lcl_generics DEFINITION.
  PUBLIC SECTION.
    METHODS name
      EXPORTING
        foo TYPE clike
        bar TYPE csequence
        baz TYPE numeric.
ENDCLASS.
CLASS lcl_generics IMPLEMENTATION.
  METHOD name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_param_kinds DEFINITION.
  PUBLIC SECTION.
    METHODS name
      IMPORTING importing        TYPE i
      EXPORTING exporting        TYPE i
      CHANGING changing          TYPE i
      RETURNING VALUE(returning) TYPE i.
ENDCLASS.
CLASS lcl_param_kinds IMPLEMENTATION.
  METHOD name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_attr_oref DEFINITION.
  PUBLIC SECTION.
    DATA oref TYPE REF TO cl_abap_classdescr.
ENDCLASS.
CLASS lcl_attr_oref IMPLEMENTATION.
ENDCLASS.

CLASS lcl_param_iref DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS bar IMPORTING val TYPE REF TO if_message.
ENDCLASS.
CLASS lcl_param_iref IMPLEMENTATION.
  METHOD bar.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_attr_iref DEFINITION.
  PUBLIC SECTION.
    DATA bar TYPE REF TO if_message.
ENDCLASS.
CLASS lcl_attr_iref IMPLEMENTATION.
ENDCLASS.

CLASS lcl_super_attr DEFINITION.
  PUBLIC SECTION.
    DATA foo TYPE i.
  PRIVATE SECTION.
    DATA priv TYPE i.
ENDCLASS.
CLASS lcl_super_attr IMPLEMENTATION.
ENDCLASS.

CLASS lcl_subclass DEFINITION INHERITING FROM lcl_super_attr.
ENDCLASS.
CLASS lcl_subclass IMPLEMENTATION.
ENDCLASS.


************************************************************************************

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS basic_attributes FOR TESTING RAISING cx_static_check.
    METHODS attributes_from_super FOR TESTING RAISING cx_static_check.
    METHODS visibility_protected FOR TESTING RAISING cx_static_check.
    METHODS attr_from_intf FOR TESTING RAISING cx_static_check.
    METHODS is_class FOR TESTING RAISING cx_static_check.
    METHODS relative_name FOR TESTING RAISING cx_static_check.
    METHODS method_and_parameter FOR TESTING RAISING cx_static_check.
    METHODS method_via_describe_by_name FOR TESTING RAISING cx_static_check.
    METHODS method_and_parameter_char30 FOR TESTING RAISING cx_static_check.
    METHODS from_interface FOR TESTING RAISING cx_static_check.
    METHODS nested_orefs FOR TESTING RAISING cx_static_check.
    METHODS deferred FOR TESTING RAISING cx_static_check.
    METHODS method_type_generics FOR TESTING RAISING cx_static_check.
    METHODS parm_kind FOR TESTING RAISING cx_static_check.
    METHODS get_attribute_type_oref FOR TESTING RAISING cx_static_check.
    METHODS get_param_type_iref FOR TESTING RAISING cx_static_check.
    METHODS get_attr_type_iref FOR TESTING RAISING cx_static_check.
    METHODS namespaced FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD basic_attributes.
    DATA lo_foo   TYPE REF TO ltcl_foo.
    DATA lo_obj   TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr  TYPE abap_attrdescr.
    DATA lo_descr TYPE REF TO cl_abap_datadescr.

    CREATE OBJECT lo_foo.
    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_foo ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 2 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_not_initial( ls_attr-type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-name
      exp = 'BAR' ).

    lo_descr = lo_obj->get_attribute_type( ls_attr-name ).
    cl_abap_unit_assert=>assert_bound( lo_descr ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_descr->type_kind
      exp = cl_abap_typedescr=>typekind_int ).
  ENDMETHOD.

  METHOD attributes_from_super.

    DATA lo_foo TYPE REF TO lcl_subclass.
    DATA lo_obj TYPE REF TO cl_abap_objectdescr.

    CREATE OBJECT lo_foo.
    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_foo ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 1 ).

  ENDMETHOD.

  METHOD visibility_protected.
    DATA lo_ref  TYPE REF TO ltcl_visibility.
    DATA lo_obj  TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr TYPE abap_attrdescr.

    CREATE OBJECT lo_ref.
    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_ref ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 1 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-visibility
      exp = cl_abap_objectdescr=>protected ).
  ENDMETHOD.

  METHOD attr_from_intf.

    DATA lo_foo  TYPE REF TO lcl_impl.
    DATA lo_obj  TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr TYPE abap_attrdescr.

    CREATE OBJECT lo_foo.

    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_foo ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 1 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-name
      exp = 'LIF_INTF~FIELD' ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-visibility
      exp = 'U' ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-is_interface
      exp = abap_true ).

  ENDMETHOD.

  METHOD is_class.

    DATA lo_foo  TYPE REF TO lcl_static.
    DATA lo_obj  TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr TYPE abap_attrdescr.
    DATA ls_meth TYPE abap_methdescr.

    CREATE OBJECT lo_foo.

    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_foo ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 1 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-is_class
      exp = abap_true ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-length
      exp = 8 ).

    READ TABLE lo_obj->methods WITH KEY name = 'BAR' INTO ls_meth.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_meth-is_class
      exp = abap_true ).

    READ TABLE lo_obj->methods WITH KEY name = 'BAZ' INTO ls_meth.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_meth-is_class
      exp = abap_false ).

  ENDMETHOD.

  METHOD relative_name.

    DATA lo_app    TYPE REF TO lcl_str.
    DATA lv_assign TYPE string.
    DATA lo_tdescr TYPE REF TO cl_abap_typedescr.
    DATA lo_odescr TYPE REF TO cl_abap_objectdescr.
    DATA lt_attri  TYPE abap_attrdescr_tab.
    DATA ls_attri  LIKE LINE OF lt_attri.

    FIELD-SYMBOLS <any> TYPE any.

    CREATE OBJECT lo_app.
    lo_odescr ?= cl_abap_objectdescr=>describe_by_object_ref( lo_app ).
    lt_attri = lo_odescr->attributes.

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_attri )
      exp = 1 ).

    LOOP AT lt_attri INTO ls_attri.
      lv_assign = `LO_APP->` && ls_attri-name.
      ASSIGN (lv_assign) TO <any>.
      lo_tdescr = cl_abap_datadescr=>describe_by_data( <any> ).
      cl_abap_unit_assert=>assert_equals(
        act = lo_tdescr->get_relative_name( )
        exp = 'STRING' ).
    ENDLOOP.

  ENDMETHOD.

  METHOD method_and_parameter.

    DATA lo_objdescr  TYPE REF TO cl_abap_objectdescr.
    DATA lo_datadescr TYPE REF TO cl_abap_datadescr.
    DATA ls_method    TYPE abap_methdescr.
    DATA lo_app       TYPE REF TO cl_abap_objectdescr.

    CREATE OBJECT lo_app.
    lo_objdescr ?= cl_abap_typedescr=>describe_by_object_ref( lo_app ).

    READ TABLE lo_objdescr->methods INTO ls_method WITH KEY name = 'GET_METHOD_PARAMETER_TYPE'.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_method-visibility
      exp = cl_abap_objectdescr=>public ).

    READ TABLE ls_method-parameters WITH KEY name = 'P_METHOD_NAME' TRANSPORTING NO FIELDS.
    cl_abap_unit_assert=>assert_subrc( ).

    lo_datadescr = lo_objdescr->get_method_parameter_type(
      p_method_name    = ls_method-name
      p_parameter_name = 'P_METHOD_NAME' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_datadescr->kind
      exp = cl_abap_typedescr=>kind_elem ).

  ENDMETHOD.

  METHOD method_via_describe_by_name.

    DATA lo_objdescr TYPE REF TO cl_abap_objectdescr.
    DATA ls_method   TYPE abap_methdescr.

    lo_objdescr ?= cl_abap_typedescr=>describe_by_name( 'CL_ABAP_OBJECTDESCR' ).

    READ TABLE lo_objdescr->methods INTO ls_method WITH KEY name = 'GET_METHOD_PARAMETER_TYPE'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_not_initial( ls_method ).

  ENDMETHOD.

  METHOD method_and_parameter_char30.

    DATA lo_objdescr  TYPE REF TO cl_abap_objectdescr.
    DATA lo_datadescr TYPE REF TO cl_abap_datadescr.
    DATA lo_app       TYPE REF TO lcl_pchar30.

    CREATE OBJECT lo_app.
    lo_objdescr ?= cl_abap_typedescr=>describe_by_object_ref( lo_app ).

    lo_datadescr = lo_objdescr->get_method_parameter_type(
      p_method_name    = 'FOO'
      p_parameter_name = 'BAR' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_datadescr->absolute_name
      exp = '\TYPE=CHAR30' ).

  ENDMETHOD.

  METHOD from_interface.

    DATA lo_ref  TYPE REF TO lcl_from_intf.
    DATA lo_obj  TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr TYPE abap_attrdescr.

    CREATE OBJECT lo_ref.
    lo_obj ?= cl_abap_typedescr=>describe_by_object_ref( lo_ref ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_obj->attributes )
      exp = 2 ).

    READ TABLE lo_obj->attributes INDEX 1 INTO ls_attr.
    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-name
      exp = 'LIF~BAR' ).

    READ TABLE lo_obj->attributes INDEX 2 INTO ls_attr.
    cl_abap_unit_assert=>assert_equals(
      act = ls_attr-name
      exp = 'FOO' ).

  ENDMETHOD.

  METHOD nested_orefs.

    DATA lo_ref TYPE REF TO lcl_ref1.
    CREATE OBJECT lo_ref.
    cl_abap_typedescr=>describe_by_object_ref( lo_ref ).

  ENDMETHOD.

  METHOD deferred.

    DATA lo_ref TYPE REF TO lcl_ref1_deferred.
    CREATE OBJECT lo_ref.
    cl_abap_typedescr=>describe_by_object_ref( lo_ref ).

  ENDMETHOD.

  METHOD method_type_generics.
    DATA ref          TYPE REF TO lcl_generics.
    DATA lo_objdescr  TYPE REF TO cl_abap_objectdescr.
    DATA lo_datadescr TYPE REF TO cl_abap_datadescr.

* todo: handle additional generics

    CREATE OBJECT ref.
    lo_objdescr ?= cl_abap_typedescr=>describe_by_object_ref( ref ).

    lo_datadescr = lo_objdescr->get_method_parameter_type(
      p_method_name    = 'NAME'
      p_parameter_name = 'FOO' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_datadescr->type_kind
      exp = cl_abap_typedescr=>typekind_clike ).

    lo_datadescr = lo_objdescr->get_method_parameter_type(
      p_method_name    = 'NAME'
      p_parameter_name = 'BAR' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_datadescr->type_kind
      exp = cl_abap_typedescr=>typekind_csequence ).

    lo_datadescr = lo_objdescr->get_method_parameter_type(
      p_method_name    = 'NAME'
      p_parameter_name = 'BAZ' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_datadescr->type_kind
      exp = cl_abap_typedescr=>typekind_numeric ).
  ENDMETHOD.

  METHOD parm_kind.

    DATA ref          TYPE REF TO lcl_param_kinds.
    DATA lo_objdescr  TYPE REF TO cl_abap_objectdescr.
    DATA lo_datadescr TYPE REF TO cl_abap_datadescr.
    DATA ls_method    TYPE abap_methdescr.
    DATA ls_parameter TYPE abap_parmdescr.

    CREATE OBJECT ref.
    lo_objdescr ?= cl_abap_typedescr=>describe_by_object_ref( ref ).

    READ TABLE lo_objdescr->methods INDEX 1 INTO ls_method.

    READ TABLE ls_method-parameters WITH KEY name = 'IMPORTING' INTO ls_parameter.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-parm_kind
      exp = cl_abap_objectdescr=>importing ).

    READ TABLE ls_method-parameters WITH KEY name = 'EXPORTING' INTO ls_parameter.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-parm_kind
      exp = cl_abap_objectdescr=>exporting ).

    READ TABLE ls_method-parameters WITH KEY name = 'CHANGING' INTO ls_parameter.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-parm_kind
      exp = cl_abap_objectdescr=>changing ).

    READ TABLE ls_method-parameters WITH KEY name = 'RETURNING' INTO ls_parameter.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-parm_kind
      exp = cl_abap_objectdescr=>returning ).

  ENDMETHOD.

  METHOD get_attribute_type_oref.

    DATA ref         TYPE REF TO lcl_attr_oref.
    DATA lo_objdescr TYPE REF TO cl_abap_objectdescr.

    CREATE OBJECT ref.
    lo_objdescr ?= cl_abap_typedescr=>describe_by_object_ref( ref ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_objdescr->get_attribute_type( 'OREF' )->type_kind
      exp = cl_abap_typedescr=>typekind_oref ).

  ENDMETHOD.

  METHOD get_param_type_iref.

    DATA ref TYPE REF TO lcl_param_iref.
    cl_abap_typedescr=>describe_by_data( ref ).

  ENDMETHOD.

  METHOD get_attr_type_iref.

    DATA ref TYPE REF TO lcl_attr_iref.
    cl_abap_typedescr=>describe_by_data( ref ).

  ENDMETHOD.

  METHOD namespaced.

    DATA ref          TYPE REF TO /ui2/cl_json.
    DATA lo_typedescr TYPE REF TO cl_abap_typedescr.

    lo_typedescr ?= cl_abap_typedescr=>describe_by_name( '/UI2/CL_JSON' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_typedescr->absolute_name
      exp = '\CLASS=/UI2/CL_JSON' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_typedescr->get_relative_name( )
      exp = '/UI2/CL_JSON' ).

  ENDMETHOD.

ENDCLASS.

INTERFACE lif_metadata_base.
  METHODS run
    IMPORTING
      required TYPE i
      extra    TYPE i OPTIONAL
    RAISING
      cx_sy_zerodivide
      cx_sy_conversion_error.
  CLASS-METHODS version
    RETURNING
      VALUE(result) TYPE string.
ENDINTERFACE.

INTERFACE lif_metadata.
  INTERFACES lif_metadata_base.
  ALIASES go FOR lif_metadata_base~run.
ENDINTERFACE.

CLASS ltcl_method_metadata DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    METHODS describe
      IMPORTING
        iv_name         TYPE string
      RETURNING
        VALUE(ro_descr) TYPE REF TO cl_abap_objectdescr.
    METHODS optional_parameter FOR TESTING RAISING cx_static_check.
    METHODS raising_clause FOR TESTING RAISING cx_static_check.
    METHODS static_method_of_interface FOR TESTING RAISING cx_static_check.
    METHODS alias FOR TESTING RAISING cx_static_check.
    METHODS without_metadata FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_method_metadata IMPLEMENTATION.

  METHOD class_setup.
* the transpiler does not emit this part of the method metadata yet, so the fixtures get
* here what their declarations say. Remove once the transpiler emits it
    WRITE '@KERNEL const base = abap.Classes["CLAS-CL_ABAP_OBJECTDESCR-LIF_METADATA_BASE"].METHODS;'.
    WRITE '@KERNEL base.RUN.parameters.EXTRA.is_optional = "X";'.
    WRITE '@KERNEL base.RUN.exceptions = ["CX_SY_ZERODIVIDE", "CX_SY_CONVERSION_ERROR"];'.
    WRITE '@KERNEL base.VERSION.is_class = "X";'.
    WRITE '@KERNEL const intf = abap.Classes["CLAS-CL_ABAP_OBJECTDESCR-LIF_METADATA"].METHODS;'.
    WRITE '@KERNEL intf.GO = {"visibility": "U", "alias_for": "LIF_METADATA_BASE~RUN", "parameters": {}};'.
  ENDMETHOD.

  METHOD describe.
    DATA lv_any TYPE string.
    WRITE '@KERNEL lv_any = abap.Classes["CLAS-CL_ABAP_OBJECTDESCR-" + iv_name.get()];'.
    ro_descr ?= cl_abap_objectdescr=>_construct( lv_any ).
  ENDMETHOD.

  METHOD optional_parameter.
    DATA ls_method    TYPE abap_methdescr.
    DATA ls_parameter TYPE abap_parmdescr.

    READ TABLE describe( `LIF_METADATA_BASE` )->methods INTO ls_method WITH KEY name = 'RUN'.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE ls_method-parameters INTO ls_parameter WITH KEY name = 'REQUIRED'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-is_optional
      exp = abap_false ).

    READ TABLE ls_method-parameters INTO ls_parameter WITH KEY name = 'EXTRA'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-is_optional
      exp = abap_true ).
  ENDMETHOD.

  METHOD raising_clause.
    DATA ls_method    TYPE abap_methdescr.
    DATA ls_exception TYPE abap_excpdescr.

    READ TABLE describe( `LIF_METADATA_BASE` )->methods INTO ls_method WITH KEY name = 'RUN'.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( ls_method-exceptions )
      exp = 2 ).
    READ TABLE ls_method-exceptions INTO ls_exception WITH KEY name = 'CX_SY_ZERODIVIDE'.
    cl_abap_unit_assert=>assert_subrc( ).
    READ TABLE ls_method-exceptions INTO ls_exception WITH KEY name = 'CX_SY_CONVERSION_ERROR'.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD static_method_of_interface.
    DATA ls_method TYPE abap_methdescr.

    READ TABLE describe( `LIF_METADATA_BASE` )->methods INTO ls_method WITH KEY name = 'VERSION'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_method-is_class
      exp = abap_true ).

    READ TABLE describe( `LIF_METADATA_BASE` )->methods INTO ls_method WITH KEY name = 'RUN'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_method-is_class
      exp = abap_false ).
  ENDMETHOD.

  METHOD alias.
    DATA ls_method TYPE abap_methdescr.

    READ TABLE describe( `LIF_METADATA` )->methods INTO ls_method WITH KEY name = 'GO'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_method-alias_for
      exp = 'LIF_METADATA_BASE~RUN' ).
  ENDMETHOD.

  METHOD without_metadata.
* a method without the additional metadata is described as before
    DATA lo_static TYPE REF TO lcl_static.
    DATA lo_descr  TYPE REF TO cl_abap_objectdescr.
    DATA ls_method TYPE abap_methdescr.

    CREATE OBJECT lo_static.
    lo_descr ?= cl_abap_typedescr=>describe_by_object_ref( lo_static ).

    READ TABLE lo_descr->methods INTO ls_method WITH KEY name = 'BAZ'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_initial( ls_method-exceptions ).
    cl_abap_unit_assert=>assert_initial( ls_method-alias_for ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_method-is_class
      exp = abap_false ).

    READ TABLE lo_descr->methods INTO ls_method WITH KEY name = 'BAR'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_method-is_class
      exp = abap_true ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_generic_parameters DEFINITION.
  PUBLIC SECTION.
    METHODS name
      IMPORTING
        any_value    TYPE any
        data_value   TYPE data
        simple_value TYPE simple
        bytes        TYPE xsequence
        text         TYPE c
        hex          TYPE x
        packed       TYPE p
        typed        TYPE char30.
ENDCLASS.
CLASS lcl_generic_parameters IMPLEMENTATION.
  METHOD name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_generic_digits DEFINITION.
  PUBLIC SECTION.
    METHODS name
      IMPORTING
        digits TYPE n.
ENDCLASS.
CLASS lcl_generic_digits IMPLEMENTATION.
  METHOD name.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_generic_parameters DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    DATA mo_descr TYPE REF TO cl_abap_objectdescr.

    METHODS setup.
    METHODS fully_generic FOR TESTING RAISING cx_static_check.
    METHODS xsequence FOR TESTING RAISING cx_static_check.
    METHODS without_length FOR TESTING RAISING cx_static_check.
    METHODS generic_n FOR TESTING RAISING cx_static_check.
    METHODS complete_type FOR TESTING RAISING cx_static_check.
    METHODS parameter_rows FOR TESTING RAISING cx_static_check.

    METHODS type_of
      IMPORTING
        iv_parameter    TYPE string
      RETURNING
        VALUE(ro_descr) TYPE REF TO cl_abap_datadescr.
ENDCLASS.

CLASS ltcl_generic_parameters IMPLEMENTATION.

  METHOD setup.
    DATA lo_object TYPE REF TO lcl_generic_parameters.

    CREATE OBJECT lo_object.
    mo_descr ?= cl_abap_typedescr=>describe_by_object_ref( lo_object ).
  ENDMETHOD.

  METHOD type_of.
    ro_descr = mo_descr->get_method_parameter_type(
      p_method_name    = 'NAME'
      p_parameter_name = iv_parameter ).
  ENDMETHOD.

  METHOD fully_generic.
    cl_abap_unit_assert=>assert_equals(
      act = type_of( 'ANY_VALUE' )->type_kind
      exp = cl_abap_typedescr=>typekind_any ).
    cl_abap_unit_assert=>assert_equals(
      act = type_of( 'ANY_VALUE' )->absolute_name
      exp = '\TYPE=ANY' ).
    cl_abap_unit_assert=>assert_equals(
      act = type_of( 'DATA_VALUE' )->type_kind
      exp = cl_abap_typedescr=>typekind_data ).
    cl_abap_unit_assert=>assert_equals(
      act = type_of( 'SIMPLE_VALUE' )->type_kind
      exp = cl_abap_typedescr=>typekind_simple ).
  ENDMETHOD.

  METHOD xsequence.
    cl_abap_unit_assert=>assert_equals(
      act = type_of( 'BYTES' )->type_kind
      exp = cl_abap_typedescr=>typekind_xsequence ).
  ENDMETHOD.

  METHOD without_length.
    DATA lo_type TYPE REF TO cl_abap_datadescr.

    lo_type = type_of( 'TEXT' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->kind
      exp = cl_abap_typedescr=>kind_elem ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->type_kind
      exp = cl_abap_typedescr=>typekind_char ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->length
      exp = 0 ).

    lo_type = type_of( 'HEX' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->type_kind
      exp = cl_abap_typedescr=>typekind_hex ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->length
      exp = 0 ).

    lo_type = type_of( 'PACKED' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->type_kind
      exp = cl_abap_typedescr=>typekind_packed ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->length
      exp = 0 ).
  ENDMETHOD.

  METHOD generic_n.
    DATA lo_object TYPE REF TO lcl_generic_digits.
    DATA lo_descr  TYPE REF TO cl_abap_objectdescr.
    DATA lo_type   TYPE REF TO cl_abap_datadescr.

* the transpiler names the type of a parameter TYPE n "NGenericType" from abaplint 2.120.69 on
    WRITE '@KERNEL abap.Classes["CLAS-CL_ABAP_OBJECTDESCR-LCL_GENERIC_DIGITS"].METHODS.NAME.parameters.DIGITS.type_name = "NGenericType";'.

    CREATE OBJECT lo_object.
    lo_descr ?= cl_abap_typedescr=>describe_by_object_ref( lo_object ).
    lo_type = lo_descr->get_method_parameter_type(
      p_method_name    = 'NAME'
      p_parameter_name = 'DIGITS' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_type->type_kind
      exp = cl_abap_typedescr=>typekind_num ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->length
      exp = 0 ).
  ENDMETHOD.

  METHOD complete_type.
    DATA lo_type TYPE REF TO cl_abap_datadescr.

    lo_type = type_of( 'TYPED' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_type->type_kind
      exp = cl_abap_typedescr=>typekind_char ).
    cl_abap_unit_assert=>assert_differs(
      act = lo_type->length
      exp = 0 ).
  ENDMETHOD.

  METHOD parameter_rows.
    DATA ls_method    TYPE abap_methdescr.
    DATA ls_parameter TYPE abap_parmdescr.

    READ TABLE mo_descr->methods INTO ls_method WITH KEY name = 'NAME'.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE ls_method-parameters INTO ls_parameter WITH KEY name = 'ANY_VALUE'.
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-type_kind
      exp = cl_abap_typedescr=>typekind_any ).

    READ TABLE ls_method-parameters INTO ls_parameter WITH KEY name = 'TEXT'.
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-type_kind
      exp = cl_abap_typedescr=>typekind_char ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_parameter-length
      exp = 0 ).
  ENDMETHOD.

ENDCLASS.

