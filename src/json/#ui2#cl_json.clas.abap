CLASS /ui2/cl_json DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS deserialize
      IMPORTING
        json TYPE string OPTIONAL
      CHANGING
        data TYPE data.
  PRIVATE SECTION.
    CLASS-DATA mo_parsed TYPE REF TO lcl_parser.
    CLASS-METHODS _deserialize
      IMPORTING
        prefix TYPE string
      CHANGING
        data TYPE data.
ENDCLASS.

CLASS /ui2/cl_json IMPLEMENTATION.
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

    FIELD-SYMBOLS <any> TYPE any.

    lo_type = cl_abap_typedescr=>describe_by_data( data ).
*    WRITE '@KERNEL console.dir(lo_type.get().kind);'.
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        data = mo_parsed->value_string( prefix ).
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