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
ENDCLASS.
CLASS lcl_static IMPLEMENTATION.
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

************************************************************************************

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS basic_attributes FOR TESTING RAISING cx_static_check.
    METHODS visibility_protected FOR TESTING RAISING cx_static_check.
    METHODS attr_from_intf FOR TESTING RAISING cx_static_check.
    METHODS is_class FOR TESTING RAISING cx_static_check.
    METHODS relative_name FOR TESTING RAISING cx_static_check.
    METHODS method_and_parameter FOR TESTING RAISING cx_static_check.
    METHODS method_and_parameter_char30 FOR TESTING RAISING cx_static_check.

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

    DATA lo_foo TYPE REF TO lcl_impl.
    DATA lo_obj TYPE REF TO cl_abap_objectdescr.
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

    DATA lo_foo TYPE REF TO lcl_static.
    DATA lo_obj TYPE REF TO cl_abap_objectdescr.
    DATA ls_attr TYPE abap_attrdescr.

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

ENDCLASS.