CLASS lcl_heap DEFINITION.
  PUBLIC SECTION.
    METHODS add
      IMPORTING
        iv_ref TYPE any.
    METHODS serialize
      RETURNING
        VALUE(rv_xml) TYPE string.
ENDCLASS.

CLASS lcl_heap IMPLEMENTATION.
  METHOD serialize.
* todo
  ENDMETHOD.

  METHOD add.
* todo
  ENDMETHOD.
ENDCLASS.

CLASS lcl_data_to_xml DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.

    METHODS run
      IMPORTING
        iv_name       TYPE string
        iv_ref        TYPE REF TO data
      RETURNING
        VALUE(rv_xml) TYPE string.
  PRIVATE SECTION.
    DATA mo_heap TYPE REF TO lcl_heap.
ENDCLASS.

CLASS lcl_data_to_xml IMPLEMENTATION.

  METHOD constructor.
    CREATE OBJECT mo_heap.
  ENDMETHOD.

  METHOD run.
    DATA lo_type  TYPE REF TO cl_abap_typedescr.
    DATA lo_struc TYPE REF TO cl_abap_structdescr.
    DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    DATA ls_compo LIKE LINE OF lt_comps.
    DATA lv_ref   TYPE REF TO data.

    FIELD-SYMBOLS <any>   TYPE any.
    FIELD-SYMBOLS <table> TYPE ANY TABLE.
    FIELD-SYMBOLS <field> TYPE any.

    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).

    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struc ?= lo_type.
        lt_comps = lo_struc->get_components( ).
        ASSIGN iv_ref->* TO <any>.
        rv_xml = rv_xml && |<{ iv_name }>|.
        LOOP AT lt_comps INTO ls_compo.
          ASSIGN COMPONENT ls_compo-name OF STRUCTURE <any> TO <field>.
          GET REFERENCE OF <field> INTO lv_ref.
          rv_xml = rv_xml && run(
            iv_name = to_upper( ls_compo-name )
            iv_ref  = lv_ref ).
        ENDLOOP.
        rv_xml = rv_xml && |</{ iv_name }>|.
      WHEN cl_abap_typedescr=>kind_elem.
        rv_xml = rv_xml &&
          |<{ iv_name }>| &&
          iv_ref->* &&
          |</{ iv_name }>|.
      WHEN cl_abap_typedescr=>kind_table.
        ASSIGN iv_ref->* TO <table>.
        rv_xml = rv_xml && |<{ iv_name }>|.
        LOOP AT <table> ASSIGNING <any>.
          GET REFERENCE OF <any> INTO lv_ref.
          rv_xml = rv_xml && run( iv_name = |item| iv_ref = lv_ref ).
        ENDLOOP.
        rv_xml = rv_xml && |</{ iv_name }>|.
      WHEN cl_abap_typedescr=>kind_ref.
        CASE lo_type->type_kind.
          WHEN cl_abap_typedescr=>typekind_oref.
            IF iv_ref IS INITIAL.
              rv_xml = |<{ iv_name }/>|.
              RETURN.
            ENDIF.
            rv_xml = |<{ iv_name } href="#o34"/>|.
          WHEN OTHERS.
            IF iv_ref->* IS INITIAL.
              rv_xml = |<{ iv_name }/>|.
              RETURN.
            ENDIF.
            ASSERT 1 = 'todo,lcl_data_to_xml'.
        ENDCASE.
      WHEN OTHERS.
        ASSERT 1 = 'todo,lcl_data_to_xml'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.