CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS typekind_int FOR TESTING.
    METHODS typekind_char FOR TESTING.
    METHODS typekind_structure FOR TESTING.
    METHODS typekind_xstring FOR TESTING.
    METHODS typekind_string FOR TESTING.
    METHODS typekind_date FOR TESTING.
    METHODS typekind_time FOR TESTING.
    METHODS typekind_dref FOR TESTING.
    METHODS typekind_numc FOR TESTING.
    METHODS typekind_hex FOR TESTING.
    METHODS kind_elem FOR TESTING.
    METHODS kind_table FOR TESTING.
    METHODS field_symbol FOR TESTING.
    METHODS abap_bool_absolute FOR TESTING.
    METHODS abap_true_absolute FOR TESTING.
    METHODS xsdboolean_absolute FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD kind_elem.

    DATA lv_int TYPE i.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( lv_int ).

    cl_abap_unit_assert=>assert_equals(
      act = type->kind
      exp = cl_abap_typedescr=>kind_elem ).

  ENDMETHOD.

  METHOD kind_table.

    DATA tab TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( tab ).

    cl_abap_unit_assert=>assert_equals(
      act = type->kind
      exp = cl_abap_typedescr=>kind_table ).

  ENDMETHOD.

  METHOD typekind_char.

    DATA cthing TYPE c LENGTH 3.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( cthing ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_char ).

  ENDMETHOD.

  METHOD typekind_dref.
    DATA foo TYPE REF TO data.
    DATA type TYPE REF TO cl_abap_typedescr.
    type = cl_abap_typedescr=>describe_by_data( foo ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_dref ).
  ENDMETHOD.

  METHOD typekind_int.

    DATA integer TYPE i.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( integer ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_int ).

  ENDMETHOD.

  METHOD typekind_xstring.
    DATA data TYPE xstring.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_xstring ).
  ENDMETHOD.

  METHOD typekind_string.
    DATA data TYPE string.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_string ).
  ENDMETHOD.

  METHOD typekind_structure.
    TYPES: BEGIN OF ty_struc,
             a TYPE string,
             c TYPE i,
           END OF ty_struc.
    DATA ls_struc_act TYPE ty_struc.

    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( ls_struc_act ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_struct2 ).
  ENDMETHOD.

  METHOD field_symbol.
    DATA integer TYPE i.
    DATA type TYPE REF TO cl_abap_typedescr.
    FIELD-SYMBOLS <fs> TYPE i.
    ASSIGN integer TO <fs>.

    type = cl_abap_typedescr=>describe_by_data( <fs> ).
    cl_abap_unit_assert=>assert_not_initial( type ).
    cl_abap_unit_assert=>assert_not_initial( type->type_kind ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_int ).
  ENDMETHOD.

  METHOD typekind_date.
    DATA data TYPE d.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_date ).
  ENDMETHOD.

  METHOD typekind_time.
    DATA data TYPE t.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_time ).
  ENDMETHOD.

  METHOD typekind_hex.
    DATA data TYPE x LENGTH 4.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_hex ).
  ENDMETHOD.

  METHOD typekind_numc.
    DATA data TYPE n LENGTH 4.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_num ).
  ENDMETHOD.

  METHOD abap_bool_absolute.
    DATA bool TYPE abap_bool.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    lo_type = cl_abap_typedescr=>describe_by_data( bool ).
* this is checked in ajson(which is used by abapGit)    
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->absolute_name
      exp = '\TYPE-POOL=ABAP\TYPE=ABAP_BOOL' ).
  ENDMETHOD.

  METHOD abap_true_absolute.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    lo_type = cl_abap_typedescr=>describe_by_data( abap_true ).
* this is checked in ajson(which is used by abapGit)    
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->absolute_name
      exp = '\TYPE-POOL=ABAP\TYPE=ABAP_BOOL' ).
  ENDMETHOD.

  METHOD xsdboolean_absolute.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA lv_xsd TYPE xsdboolean.
    lo_type = cl_abap_typedescr=>describe_by_data( lv_xsd ).
* this is checked in ajson(which is used by abapGit)    
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->absolute_name
      exp = '\TYPE=XSDBOOLEAN' ).
  ENDMETHOD.

ENDCLASS.