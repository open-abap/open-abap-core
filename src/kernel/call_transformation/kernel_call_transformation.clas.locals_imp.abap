CLASS lcl_heap DEFINITION.
  PUBLIC SECTION.
    METHODS add
      IMPORTING
        iv_ref      TYPE any
      RETURNING
        VALUE(rv_id) TYPE string.
    METHODS serialize
      RETURNING
        VALUE(rv_xml) TYPE string.
  PRIVATE SECTION.
    DATA mv_counter TYPE i.
    DATA mv_data TYPE string.
ENDCLASS.

CLASS lcl_data_to_xml DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        io_heap TYPE REF TO lcl_heap OPTIONAL.

    METHODS run
      IMPORTING
        iv_name       TYPE string
        iv_ref        TYPE REF TO data
      RETURNING
        VALUE(rv_xml) TYPE string.

    METHODS serialize_heap
      RETURNING
        VALUE(rv_xml) TYPE string.
  PRIVATE SECTION.
    DATA mo_heap TYPE REF TO lcl_heap.
ENDCLASS.

CLASS lcl_heap IMPLEMENTATION.
  METHOD serialize.
* todo
    IF mv_counter = 0.
      RETURN.
    ENDIF.

    rv_xml = rv_xml && |<asx:heap xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:abap="http://www.sap.com/abapxml/types/built-in" xmlns:cls="http://www.sap.com/abapxml/classes/global" xmlns:dic="http://www.sap.com/abapxml/types/dictionary">|.
    rv_xml = rv_xml && mv_data.
    rv_xml = rv_xml && |</asx:heap>|.
  ENDMETHOD.

  METHOD add.
    DATA lv_name         TYPE string.
    DATA is_serializable TYPE abap_bool.
    DATA lo_descr        TYPE REF TO cl_abap_classdescr.
    DATA ls_interface    TYPE abap_intfdescr.
    DATA ls_attribute    TYPE abap_attrdescr.
    DATA lo_data_to_xml  TYPE REF TO lcl_data_to_xml.
    DATA lv_ref          TYPE REF TO data.
    DATA lv_internal     TYPE string.
    DATA lv_data         TYPE string.
    DATA lv_counter      LIKE mv_counter.

    FIELD-SYMBOLS <any> TYPE REF TO any.

    mv_counter = mv_counter + 1.
    lv_counter = mv_counter.

    lo_descr ?= cl_abap_typedescr=>describe_by_object_ref( iv_ref ).
    lv_name = lo_descr->relative_name.

    LOOP AT lo_descr->interfaces INTO ls_interface.
      IF ls_interface-name = 'IF_SERIALIZABLE_OBJECT'.
        is_serializable = abap_true.
      ENDIF.
    ENDLOOP.

    WRITE '@KERNEL lv_internal.set(iv_ref.get().constructor.INTERNAL_NAME);'.

    IF is_serializable = abap_true.
      CREATE OBJECT lo_data_to_xml
        EXPORTING
          io_heap = me.
      lv_data = lv_data &&
        |<prg:{ lv_name } xmlns:prg="http://www.sap.com/abapxml/classes/class-pool/TODO" id="o{ mv_counter }" internalName="{ lv_internal }">| &&
        |<local.{ lv_name }>|.
      LOOP AT lo_descr->attributes INTO ls_attribute.
        ASSIGN iv_ref->(ls_attribute-name) TO <any>.
        ASSERT sy-subrc = 0.
        REPLACE FIRST OCCURRENCE OF '~' IN ls_attribute-name WITH '.'.
        GET REFERENCE OF <any> INTO lv_ref.
        lv_data = lv_data && lo_data_to_xml->run(
          iv_name = ls_attribute-name
          iv_ref  = lv_ref ).
      ENDLOOP.
      lv_data = lv_data &&
        |</local.{ lv_name }>| &&
        |</prg:{ lv_name }>|.
    ELSE.
      lv_data = lv_data &&
        |<prg:{ lv_name } xmlns:prg="http://www.sap.com/abapxml/classes/class-pool/TODO" id="o{ mv_counter }"/>|.
    ENDIF.

    mv_data = mv_data && lv_data.
    rv_id = |{ lv_counter }|.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_data_to_xml IMPLEMENTATION.

  METHOD constructor.
    IF io_heap IS INITIAL.
      CREATE OBJECT mo_heap.
    ELSE.
      mo_heap = io_heap.
    ENDIF.
  ENDMETHOD.

  METHOD serialize_heap.
    rv_xml = mo_heap->serialize( ).
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
        IF lo_type->type_kind = cl_abap_typedescr=>typekind_string AND iv_ref->* IS INITIAL.
          rv_xml = rv_xml && |<{ iv_name }/>|.
        ELSE.
          rv_xml = rv_xml &&
            |<{ iv_name }>| &&
            iv_ref->* &&
            |</{ iv_name }>|.
        ENDIF.
      WHEN cl_abap_typedescr=>kind_table.
        ASSIGN iv_ref->* TO <table>.
        rv_xml = rv_xml && |<{ iv_name }>|.
        LOOP AT <table> ASSIGNING <any>.
          GET REFERENCE OF <any> INTO lv_ref.
          rv_xml = rv_xml && run(
            iv_name = |item|
            iv_ref = lv_ref ).
        ENDLOOP.
        rv_xml = rv_xml && |</{ iv_name }>|.
      WHEN cl_abap_typedescr=>kind_ref.
        CASE lo_type->type_kind.
          WHEN cl_abap_typedescr=>typekind_oref.
            IF iv_ref->* IS INITIAL.
              rv_xml = |<{ iv_name }/>|.
              RETURN.
            ENDIF.
            rv_xml = |<{ iv_name } href="#o{ mo_heap->add( iv_ref->* ) }"/>|.
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