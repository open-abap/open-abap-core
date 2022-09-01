CLASS cl_abap_typedescr DEFINITION PUBLIC.
* todo, this class should be ABSTRACT
  PUBLIC SECTION.
    CLASS-METHODS
      describe_by_data
        IMPORTING p_data TYPE any
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS
      describe_by_name
        IMPORTING p_name TYPE clike
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS
      describe_by_data_ref
        IMPORTING p_data_ref TYPE REF TO data
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS
      describe_by_object_ref
        IMPORTING p_object_ref TYPE REF TO object
        RETURNING VALUE(p_descr_ref) TYPE REF TO cl_abap_typedescr.
    METHODS get_ddic_header
      RETURNING
        VALUE(p_header) TYPE abap_bool. " hmm, todo
    METHODS
      get_relative_name
        RETURNING
          VALUE(name) TYPE string.
    METHODS
      is_ddic_type
        RETURNING
          VALUE(p_abap_bool) TYPE abap_bool.

    DATA type_kind     TYPE abap_typekind.
    DATA kind          TYPE c LENGTH 1.
    DATA ddic          TYPE abap_bool.
    DATA length        TYPE i.
    DATA decimals      TYPE i.
    DATA absolute_name TYPE string.
    DATA relative_name TYPE string.

    CONSTANTS typekind_any TYPE abap_typekind VALUE '~'.
    CONSTANTS typekind_char TYPE abap_typekind VALUE 'C'.
    CONSTANTS typekind_class TYPE abap_typekind VALUE '*'.
    CONSTANTS typekind_intf TYPE abap_typekind VALUE '+'.
    CONSTANTS typekind_clike TYPE abap_typekind VALUE '&'.
    CONSTANTS typekind_csequence TYPE abap_typekind VALUE '?'.
    CONSTANTS typekind_date TYPE abap_typekind VALUE 'D'.
    CONSTANTS typekind_decfloat TYPE abap_typekind VALUE '/'.
    CONSTANTS typekind_decfloat16 TYPE abap_typekind VALUE 'a'.
    CONSTANTS typekind_decfloat34 TYPE abap_typekind VALUE 'e'.
    CONSTANTS typekind_dref TYPE abap_typekind VALUE 'l'.
    CONSTANTS typekind_enum TYPE abap_typekind VALUE 'k'.
    CONSTANTS typekind_float TYPE abap_typekind VALUE 'F'.
    CONSTANTS typekind_hex TYPE abap_typekind VALUE 'X'.
    CONSTANTS typekind_int TYPE abap_typekind VALUE 'I'.
    CONSTANTS typekind_int1 TYPE abap_typekind VALUE 'b'.
    CONSTANTS typekind_int2 TYPE abap_typekind VALUE 's'.
    CONSTANTS typekind_int8 TYPE abap_typekind VALUE '8'.
    CONSTANTS typekind_num TYPE abap_typekind VALUE 'N'.
    CONSTANTS typekind_numeric TYPE abap_typekind VALUE '%'.
    CONSTANTS typekind_oref TYPE abap_typekind VALUE 'r'.
    CONSTANTS typekind_packed TYPE abap_typekind VALUE 'P'.
    CONSTANTS typekind_string TYPE abap_typekind VALUE 'g'.
    CONSTANTS typekind_struct1 TYPE abap_typekind VALUE 'u'.
    CONSTANTS typekind_struct2 TYPE abap_typekind VALUE 'v'.
    CONSTANTS typekind_table TYPE abap_typekind VALUE 'h'.
    CONSTANTS typekind_time TYPE abap_typekind VALUE 'T'.
    CONSTANTS typekind_utclong TYPE abap_typekind VALUE 'p'.
    CONSTANTS typekind_w TYPE abap_typekind VALUE 'w'.
    CONSTANTS typekind_xstring TYPE abap_typekind VALUE 'y'.

    CONSTANTS kind_elem   TYPE c LENGTH 1 VALUE 'E'.
    CONSTANTS kind_struct TYPE c LENGTH 1 VALUE 'S'.
    CONSTANTS kind_table  TYPE c LENGTH 1 VALUE 'T'.
    CONSTANTS kind_ref    TYPE c LENGTH 1 VALUE 'R'.
    CONSTANTS kind_class  TYPE c LENGTH 1 VALUE 'C'.
    CONSTANTS kind_intf   TYPE c LENGTH 1 VALUE 'I'.
ENDCLASS.

CLASS cl_abap_typedescr IMPLEMENTATION.

  METHOD describe_by_name.
    DATA ref     TYPE REF TO data.
    DATA objectdescr TYPE REF TO cl_abap_objectdescr.
    DATA oo_type TYPE string.

    WRITE '@KERNEL oo_type.set(abap.Classes[p_name.get().toUpperCase()]?.INTERNAL_TYPE || "");'.

    CASE oo_type.
      WHEN 'INTF'.
        CREATE OBJECT type TYPE cl_abap_intfdescr.
        type->type_kind = typekind_intf.
        type->kind = kind_intf.
        objectdescr ?= type.
        objectdescr->mv_object_name = to_upper( p_name ). " todo, this should give syntax error, as they are not friends
        objectdescr->mv_object_type = oo_type. " todo, this should give syntax error, as they are not friends
      WHEN 'CLAS'.
        CREATE OBJECT type TYPE cl_abap_classdescr.
        type->type_kind = typekind_class.
        type->kind = kind_class.
        objectdescr ?= type.
        objectdescr->mv_object_name = to_upper( p_name ). " todo, this should give syntax error, as they are not friends
        objectdescr->mv_object_type = oo_type. " todo, this should give syntax error, as they are not friends
      WHEN OTHERS.
        CREATE DATA ref TYPE (p_name).
        type = describe_by_data_ref( ref ).
    ENDCASE.
  ENDMETHOD.

  METHOD get_relative_name.
    name = relative_name.
  ENDMETHOD.

  METHOD get_ddic_header.
    ASSERT 1 = 2.
  ENDMETHOD.

  METHOD is_ddic_type.
    p_abap_bool = ddic.
  ENDMETHOD.

  METHOD describe_by_data_ref.
    FIELD-SYMBOLS <ref> TYPE any.
    ASSIGN p_data_ref->* TO <ref>.
    type = describe_by_data( <ref> ).
  ENDMETHOD.

  METHOD describe_by_object_ref.
    CREATE OBJECT p_descr_ref TYPE cl_abap_classdescr.
    p_descr_ref->type_kind = typekind_class.
    p_descr_ref->kind = kind_class.
    p_descr_ref->relative_name = 'CLASS_NAME_TODO'.
    p_descr_ref->absolute_name = 'CLASS_NAME_TODO'.
  ENDMETHOD.

  METHOD describe_by_data.

    DATA lv_name   TYPE string.
    DATA lv_prefix TYPE string.
    DATA lv_length TYPE i.
    DATA lo_elem   TYPE REF TO cl_abap_elemdescr.
    WRITE '@KERNEL lv_name.set(p_data.constructor.name);'.
    WRITE '@KERNEL lv_length.set(p_data.getLength ? p_data.getLength() : 0);'.

* These are the constructor names from the js runtime
    CASE lv_name.
      WHEN 'Integer'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_int.
        type->kind = kind_elem.
        type->length = 4.
        lo_elem ?= type.
        lo_elem->output_length = 11.
      WHEN 'Numc'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_num.
        type->kind = kind_elem.
        type->length = lv_length * 2.
        lo_elem ?= type.
        lo_elem->output_length = lv_length.
      WHEN 'Hex'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_hex.
        type->kind = kind_elem.
        type->length = lv_length.
        lo_elem ?= type.
        lo_elem->output_length = lv_length * 2.
      WHEN 'Date'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_date.
        type->kind = kind_elem.
        type->length = 16.
        lo_elem ?= type.
        lo_elem->output_length = 8.
      WHEN 'Packed'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_packed.
        type->kind = kind_elem.
        type->length = lv_length.
      WHEN 'Time'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_time.
        type->kind = kind_elem.
        type->length = 12.
        lo_elem ?= type.
        lo_elem->output_length = 6.
      WHEN 'Float'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_float.
        type->kind = kind_elem.
      WHEN 'Structure'.
        CREATE OBJECT type TYPE cl_abap_structdescr
          EXPORTING
            data = p_data.
        type->type_kind = typekind_struct2.
        type->kind = kind_struct.
      WHEN 'Table'.
        CREATE OBJECT type TYPE cl_abap_tabledescr
          EXPORTING
            data = p_data.
        type->type_kind = typekind_table.
        type->kind = kind_table.
      WHEN 'XString'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_xstring.
        type->kind = kind_elem.
        type->length = 8.
      WHEN 'String'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_string.
        type->kind = kind_elem.
        type->length = 8.
      WHEN 'Character'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_char.
        type->kind = kind_elem.
        type->length = lv_length * 2.
        lo_elem ?= type.
        lo_elem->output_length = lv_length.
      WHEN 'FieldSymbol'.
        WRITE '@KERNEL lv_name = p_data.getPointer();'.
        type = describe_by_data( lv_name ).
        RETURN.
      WHEN 'ABAPObject'.
        CREATE OBJECT type TYPE cl_abap_refdescr.
        type->type_kind = typekind_oref.
        type->kind = kind_ref.
      WHEN 'UTCLong'.
        CREATE OBJECT type TYPE cl_abap_elemdescr.
        type->type_kind = typekind_utclong.
        type->kind = kind_elem.
      WHEN 'DataReference'.
        CREATE OBJECT type TYPE cl_abap_refdescr.
        type->type_kind = typekind_dref.
        type->kind = kind_ref.
      WHEN OTHERS.
        WRITE / lv_name.
        ASSERT 1 = 'todo_cl_abap_typedescr'.
    ENDCASE.

    WRITE '@KERNEL if(p_data.getQualifiedName && p_data.getQualifiedName() !== undefined) type.get().absolute_name.set(p_data.getQualifiedName());'.

* this is not completely correct, local type names and ddic names might overlap, but will work for now,
    WRITE '@KERNEL if(abap.DDIC[type.get().absolute_name.get().toUpperCase()]) { type.get().ddic.set("X"); }'.

    IF type->absolute_name = 'ABAP_BOOL'.
      type->relative_name = 'ABAP_BOOL'.
      type->absolute_name = '\TYPE-POOL=ABAP\TYPE=ABAP_BOOL'.
    ELSEIF type->absolute_name IS INITIAL.
      type->absolute_name = 'ABSOLUTE_NAME_TODO'.
    ELSEIF type->absolute_name CS '=>'.
      SPLIT type->absolute_name AT '=>' INTO lv_prefix type->absolute_name.
      type->relative_name = type->absolute_name.
      type->absolute_name = '\CLASS=' && lv_prefix && '\TYPE=' && type->absolute_name.
    ELSE.
      type->relative_name = type->absolute_name.
      type->absolute_name = '\TYPE=' && type->absolute_name.
    ENDIF.

    IF type->absolute_name = '\TYPE=sy-langu' OR type->absolute_name CP '*ty_original_language'.
* todo, this is a hack for https://github.com/SAP/abap-file-formats-tools
      lo_elem->edit_mask = '==LANGU'.
    ENDIF.

  ENDMETHOD.

ENDCLASS.