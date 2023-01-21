INTERFACE lif_test_types.
  TYPES element TYPE string.
  TYPES: BEGIN OF structure,
           element_1 TYPE i,
           element_2 TYPE element,
         END OF structure.
  TYPES table_structure TYPE STANDARD TABLE OF structure WITH DEFAULT KEY.

  TYPES foo TYPE char1.
  CONSTANTS: BEGIN OF c_foo,
               true TYPE foo VALUE abap_true,
             END OF c_foo.
ENDINTERFACE.

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
    METHODS typekind_utclong FOR TESTING.
    METHODS typekind_float FOR TESTING.
    METHODS kind_elem FOR TESTING.
    METHODS kind_table FOR TESTING.
    METHODS field_symbol FOR TESTING.
    METHODS typekind_packed FOR TESTING.
    METHODS abap_bool_absolute FOR TESTING.
    METHODS abap_true_absolute FOR TESTING.
    METHODS xsdboolean_absolute FOR TESTING.
    METHODS class_type_absolute FOR TESTING.
    METHODS describe_by_name_t000 FOR TESTING.
    METHODS describe_by_name_not_found FOR TESTING.
    METHODS get_relative_name FOR TESTING.
    METHODS get_relative_name_timestamp FOR TESTING.
    METHODS get_relative_name_lif FOR TESTING.
    METHODS get_relative_name_table FOR TESTING.
    METHODS describe_by_object_ref FOR TESTING.
    METHODS describe_by_object_ref2 FOR TESTING.

    METHODS is_ddic_type_true1 FOR TESTING.
    METHODS is_ddic_type_true2 FOR TESTING.
    METHODS is_ddic_type_false FOR TESTING.

    METHODS contant_field_absolute FOR TESTING.
    METHODS structure_field_absolute FOR TESTING.
    METHODS unnamed_type FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD is_ddic_type_true1.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_typedescr=>describe_by_name( 'CHAR1' )->is_ddic_type( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD describe_by_object_ref.
* just check it doesnt crash,
    cl_abap_typedescr=>describe_by_object_ref( me ).
  ENDMETHOD.

  METHOD describe_by_object_ref2.
    DATA ref TYPE REF TO if_ixml.
    DATA descr TYPE REF TO cl_abap_typedescr.
    ref = cl_ixml=>create( ).
    descr = cl_abap_typedescr=>describe_by_object_ref( ref ).
    cl_abap_unit_assert=>assert_equals(
      act = descr->absolute_name
      exp = '\CLASS=CL_IXML' ).
  ENDMETHOD.

  METHOD is_ddic_type_true2.
    DATA foo TYPE char1.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_typedescr=>describe_by_data( foo )->is_ddic_type( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD is_ddic_type_false.
    DATA foo TYPE c LENGTH 1.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_typedescr=>describe_by_data( foo )->is_ddic_type( )
      exp = abap_false ).
  ENDMETHOD.

  METHOD get_relative_name.
    DATA lv_name TYPE string.
    lv_name = cl_abap_typedescr=>describe_by_name( 'DEVCLASS' )->get_relative_name( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp = 'DEVCLASS' ).
  ENDMETHOD.

  METHOD get_relative_name_timestamp.
    DATA t       TYPE timestamp.
    DATA lv_name TYPE string.
    lv_name = cl_abap_typedescr=>describe_by_data( t )->get_relative_name( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp = 'TIMESTAMP' ).
  ENDMETHOD.

  METHOD get_relative_name_lif.
    DATA data    TYPE lif_test_types=>element.
    DATA lv_name TYPE string.
*    WRITE '@KERNEL console.dir(data);'.
    lv_name = cl_abap_typedescr=>describe_by_data( data )->get_relative_name( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp = 'ELEMENT' ).
  ENDMETHOD.

  METHOD get_relative_name_table.
    DATA data TYPE lif_test_types=>table_structure.
    DATA lv_name TYPE string.
    lv_name = cl_abap_typedescr=>describe_by_data( data )->get_relative_name( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp = 'TABLE_STRUCTURE' ).
  ENDMETHOD.

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
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 6 ). " yes, UTF16 in internal representation
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
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 4 ).
  ENDMETHOD.

  METHOD typekind_xstring.
    DATA data TYPE xstring.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_xstring ).
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 8 ).
  ENDMETHOD.

  METHOD typekind_string.
    DATA data TYPE string.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_string ).
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 8 ).
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
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 16 ).
  ENDMETHOD.

  METHOD typekind_time.
    DATA data TYPE t.
    DATA type TYPE REF TO cl_abap_typedescr.

    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_time ).
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 12 ).
  ENDMETHOD.

  METHOD typekind_hex.
    DATA data TYPE x LENGTH 4.
    DATA type TYPE REF TO cl_abap_typedescr.
    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_hex ).
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 4 ).
  ENDMETHOD.

  METHOD typekind_packed.
    DATA data TYPE p LENGTH 4 DECIMALS 2.
    DATA type TYPE REF TO cl_abap_typedescr.
    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_packed ).
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 4 ).
    cl_abap_unit_assert=>assert_equals(
      act = type->decimals
      exp = 2 ).
  ENDMETHOD.

  METHOD typekind_utclong.
    DATA data TYPE utclong.
    DATA type TYPE REF TO cl_abap_typedescr.
    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_utclong ).
  ENDMETHOD.

  METHOD typekind_float.
    DATA data TYPE f.
    DATA type TYPE REF TO cl_abap_typedescr.
    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_float ).
  ENDMETHOD.

  METHOD typekind_numc.
    DATA data TYPE n LENGTH 4.
    DATA type TYPE REF TO cl_abap_typedescr.
    type = cl_abap_typedescr=>describe_by_data( data ).
    cl_abap_unit_assert=>assert_equals(
      act = type->type_kind
      exp = cl_abap_typedescr=>typekind_num ).
    cl_abap_unit_assert=>assert_equals(
      act = type->length
      exp = 8 ).
  ENDMETHOD.

  METHOD abap_bool_absolute.
    DATA bool TYPE abap_bool.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    lo_type = cl_abap_typedescr=>describe_by_data( bool ).
* this is checked in ajson(which is used by abapGit)
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->absolute_name
      exp = '\TYPE-POOL=ABAP\TYPE=ABAP_BOOL' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->get_relative_name( )
      exp = 'ABAP_BOOL' ).
  ENDMETHOD.

  METHOD abap_true_absolute.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    lo_type = cl_abap_typedescr=>describe_by_data( abap_true ).
* this is checked in ajson(which is used by abapGit)
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->absolute_name
      exp = '\TYPE-POOL=ABAP\TYPE=ABAP_BOOL' ).
  ENDMETHOD.

  METHOD class_type_absolute.
    DATA foo TYPE cl_abap_enumdescr=>member.
    DATA typedescr TYPE REF TO cl_abap_typedescr.
    typedescr = cl_abap_elemdescr=>describe_by_data( foo ).
    cl_abap_unit_assert=>assert_equals(
      act = typedescr->absolute_name
      exp = '\CLASS=CL_ABAP_ENUMDESCR\TYPE=MEMBER' ).
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

  METHOD describe_by_name_t000.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    lo_type = cl_abap_typedescr=>describe_by_name( 'T000' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->kind
      exp = cl_abap_typedescr=>kind_struct ).
  ENDMETHOD.

  METHOD describe_by_name_not_found.
    cl_abap_typedescr=>describe_by_name(
      EXPORTING p_name = 'SDFSDFSDF'
      EXCEPTIONS type_not_found = 16 ).
    cl_abap_unit_assert=>assert_equals(
      act = sy-subrc
      exp = 16 ).
  ENDMETHOD.

  METHOD contant_field_absolute.
    DATA lo_descr TYPE REF TO cl_abap_typedescr.
    lo_descr = cl_abap_typedescr=>describe_by_data( lif_test_types=>c_foo-true ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lo_descr->absolute_name
      exp = '*\TYPE=FOO' ).
  ENDMETHOD.

  METHOD structure_field_absolute.

    TYPES: BEGIN OF ty_data,
         field TYPE lif_test_types=>foo,
       END OF ty_data.

    DATA ls_data TYPE ty_data.
    DATA lo_descr TYPE REF TO cl_abap_typedescr.
    lo_descr = cl_abap_typedescr=>describe_by_data( ls_data-field ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lo_descr->absolute_name
      exp = '*\TYPE=FOO' ).

  ENDMETHOD.

  METHOD unnamed_type.

    DATA lt_tab   TYPE STANDARD TABLE OF char1 WITH DEFAULT KEY.
    DATA lo_descr TYPE REF TO cl_abap_typedescr.

    lo_descr = cl_abap_typedescr=>describe_by_data( lt_tab ).

    cl_abap_unit_assert=>assert_text_matches(
      pattern = '\\TYPE=%_T\d\d\d\d\d\w\d\d\d\d\d\d\d\d\w\d\d\d\d\d\d\d\d\d\d'
      text    = lo_descr->absolute_name ).

  ENDMETHOD.

ENDCLASS.