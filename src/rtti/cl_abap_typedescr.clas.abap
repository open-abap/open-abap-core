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
        IMPORTING data TYPE REF TO data
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS
      describe_by_object_ref
        IMPORTING data TYPE REF TO object
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.

    METHODS
      get_relative_name
        RETURNING 
          VALUE(name) TYPE string.
    METHODS 
      is_ddic_type
        RETURNING
          VALUE(p_abap_bool) TYPE abap_bool.

    DATA type_kind TYPE c LENGTH 1.
    DATA kind TYPE c LENGTH 1.
    DATA absolute_name TYPE string.

    CONSTANTS typekind_int TYPE c LENGTH 1 VALUE 'I'.
    CONSTANTS typekind_struct1 TYPE c LENGTH 1 VALUE 'u'.
    CONSTANTS typekind_struct2 TYPE c LENGTH 1 VALUE 'v'.
    CONSTANTS typekind_xstring TYPE c LENGTH 1 VALUE 'y'.
    CONSTANTS typekind_string TYPE c LENGTH 1 VALUE 'g'.
    CONSTANTS typekind_char TYPE c LENGTH 1 VALUE 'C'.
    CONSTANTS typekind_hex TYPE c LENGTH 1 VALUE 'X'.
    CONSTANTS typekind_dref TYPE c LENGTH 1 VALUE 'l'.
    CONSTANTS typekind_oref TYPE c LENGTH 1 VALUE 'r'.
    CONSTANTS typekind_table TYPE c LENGTH 1 VALUE 'h'.
    CONSTANTS typekind_date TYPE c LENGTH 1 VALUE 'D'.
    CONSTANTS typekind_num TYPE c LENGTH 1 VALUE 'N'.
    CONSTANTS typekind_time TYPE c LENGTH 1 VALUE 'T'.
    CONSTANTS typekind_class TYPE c LENGTH 1 VALUE '*'.
    CONSTANTS typekind_packed TYPE c LENGTH 1 VALUE 'P'.
    CONSTANTS typekind_float TYPE c LENGTH 1 VALUE 'F'.
    CONSTANTS typekind_int1 TYPE c LENGTH 1 VALUE 'b'.
    CONSTANTS typekind_int2 TYPE c LENGTH 1 VALUE 's'.
    
    CONSTANTS kind_elem TYPE c LENGTH 1 VALUE 'E'.
    CONSTANTS kind_struct TYPE c LENGTH 1 VALUE 'S'.
    CONSTANTS kind_table TYPE c LENGTH 1 VALUE 'T'.
    CONSTANTS kind_ref TYPE c LENGTH 1 VALUE 'R'.
    CONSTANTS kind_class TYPE c LENGTH 1 VALUE 'C'.

ENDCLASS.

CLASS cl_abap_typedescr IMPLEMENTATION.

  METHOD describe_by_name.

    " DATA ref TYPE REF TO data.
    " FIELD-SYMBOLS <ref> TYPE any.
    " CREATE DATA ref TYPE (name).
    " ASSIGN ref->* TO <ref>.

    " and then call DESCRIBE_BY_DATA_REF ?

    ASSERT 1 = 'todo'.

  ENDMETHOD.

  METHOD get_relative_name.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
  
  METHOD is_ddic_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
  
  METHOD describe_by_data_ref.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD describe_by_object_ref.
    CREATE OBJECT type TYPE cl_abap_classdescr.
    type->type_kind = typekind_class.
    type->kind = kind_class.
    type->absolute_name = 'CLASS_NAME_TODO'.
  ENDMETHOD.

  METHOD describe_by_data.

    DATA lv_name TYPE string.

    WRITE '@KERNEL lv_name.set(p_data.constructor.name);'.

* These are the constructor names from the js runtime
    CASE lv_name.
      WHEN 'Integer'.
        CREATE OBJECT type.
        type->type_kind = typekind_int.
        type->kind = kind_elem.
      WHEN 'Numc'.
        CREATE OBJECT type.
        type->type_kind = typekind_num.
        type->kind = kind_elem.
      WHEN 'Hex'.
        CREATE OBJECT type.
        type->type_kind = typekind_hex.
        type->kind = kind_elem.
      WHEN 'Date'.
        CREATE OBJECT type.
        type->type_kind = typekind_date.
        type->kind = kind_elem.
      WHEN 'Time'.
        CREATE OBJECT type.
        type->type_kind = typekind_time.
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
        CREATE OBJECT type.
        type->type_kind = typekind_xstring.
        type->kind = kind_elem.
      WHEN 'String'.
        CREATE OBJECT type.
        type->type_kind = typekind_string.
        type->kind = kind_elem.
      WHEN 'Character'.
        CREATE OBJECT type.
        type->type_kind = typekind_char.
        type->kind = kind_elem.
      WHEN 'FieldSymbol'.
        WRITE '@KERNEL lv_name = p_data.getPointer();'.
        type = describe_by_data( lv_name ).
        RETURN.
      WHEN 'ABAPObject'.
        CREATE OBJECT type TYPE cl_abap_refdescr.
        type->type_kind = typekind_oref.
        type->kind = kind_ref.
      WHEN 'DataReference'.
        CREATE OBJECT type TYPE cl_abap_refdescr.
        type->type_kind = typekind_dref.
        type->kind = kind_ref.
      WHEN OTHERS.
        WRITE / lv_name.
        ASSERT 1 = 'todo_cl_abap_typedescr'.
    ENDCASE.

    WRITE '@KERNEL if(p_data.getQualifiedName && p_data.getQualifiedName() !== undefined) type.get().absolute_name.set(p_data.getQualifiedName());'.
    IF type->absolute_name = 'ABAP_BOOL'.
      type->absolute_name = '\TYPE-POOL=ABAP\TYPE=ABAP_BOOL'.
    ELSEIF type->absolute_name IS INITIAL.
      type->absolute_name = 'ABSOLUTE_NAME_TODO'.
    ELSE.
      type->absolute_name = '\TYPE=' && type->absolute_name.
    ENDIF.

  ENDMETHOD.

ENDCLASS.