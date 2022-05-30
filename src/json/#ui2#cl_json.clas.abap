CLASS /ui2/cl_json DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS deserialize
      IMPORTING
        json TYPE string OPTIONAL
      CHANGING
        data TYPE data.
    CLASS-METHODS serialize
      IMPORTING
        data TYPE data
      RETURNING
        VALUE(r_json) TYPE string.
  PRIVATE SECTION.
    CLASS-DATA mo_parsed TYPE REF TO lcl_parser.
    CLASS-METHODS _deserialize
      IMPORTING
        prefix TYPE string
      CHANGING
        data TYPE data.
ENDCLASS.

CLASS /ui2/cl_json IMPLEMENTATION.

  METHOD serialize.
    DATA lo_type       TYPE REF TO cl_abap_typedescr.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA lt_members    TYPE string_table.
    DATA ref TYPE REF TO data.
    DATA lv_member     LIKE LINE OF lt_members.

    FIELD-SYMBOLS <any> TYPE any.

    lo_type = cl_abap_typedescr=>describe_by_data( data ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        r_json = data.
      WHEN cl_abap_typedescr=>kind_table.
        RETURN. " todo
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struct ?= lo_type.
        lt_components = lo_struct->get_components( ).
        r_json = '{'.
        LOOP AT lt_components INTO ls_component.
          ASSIGN COMPONENT ls_component-name OF STRUCTURE data TO <any>.
          ASSERT sy-subrc = 0.
          r_json = r_json && |"{ ls_component-name }":| && serialize( <any> ).
        ENDLOOP.
        r_json = r_json && '}'.
      WHEN OTHERS.
        ASSERT 1 = 'cl_json, unknown kind'.
    ENDCASE.
  ENDMETHOD.

  METHOD deserialize.
    CREATE OBJECT mo_parsed.
    mo_parsed->parse( json ).

    CLEAR data.

    _deserialize(
      EXPORTING
        prefix = ''
      CHANGING
        data   = data ).
  ENDMETHOD.

  METHOD _deserialize.
    DATA lo_type       TYPE REF TO cl_abap_typedescr.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA lt_members    TYPE string_table.
    DATA ref TYPE REF TO data.
    DATA lv_member     LIKE LINE OF lt_members.

    FIELD-SYMBOLS <any> TYPE any.

    lo_type = cl_abap_typedescr=>describe_by_data( data ).
*    WRITE '@KERNEL console.dir(lo_type.get().kind);'.
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        data = mo_parsed->value_string( prefix ).
      WHEN cl_abap_typedescr=>kind_table.
        lt_members = mo_parsed->members( prefix && '/' ).
        LOOP AT lt_members INTO lv_member.
*          WRITE '@KERNEL console.dir(lv_member.get());'.
          CREATE DATA ref LIKE LINE OF data.
          ASSIGN ref->* TO <any>.
          _deserialize(
            EXPORTING
              prefix = prefix && '/' && lv_member
            CHANGING
              data   = <any> ).
*          WRITE '@KERNEL console.dir(fs_row_);'.
          INSERT <any> INTO TABLE data.
        ENDLOOP.
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struct ?= lo_type.
        lt_components = lo_struct->get_components( ).
        LOOP AT lt_components INTO ls_component.
          ASSIGN COMPONENT ls_component-name OF STRUCTURE data TO <any>.
          ASSERT sy-subrc = 0.
          _deserialize(
            EXPORTING
              prefix = prefix && '/' && to_lower( ls_component-name )
            CHANGING
              data   = <any> ).
        ENDLOOP.
      WHEN OTHERS.
        ASSERT 1 = 'cl_json, unknown kind'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.