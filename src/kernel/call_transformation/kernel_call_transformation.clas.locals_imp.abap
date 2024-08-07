CLASS lcl_heap DEFINITION.
  PUBLIC SECTION.
    METHODS add_object
      IMPORTING
        iv_ref       TYPE any
      RETURNING
        VALUE(rv_id) TYPE string.
    METHODS add_data
      IMPORTING
        iv_ref       TYPE any
      RETURNING
        VALUE(rv_id) TYPE string.
    METHODS serialize
      RETURNING
        VALUE(rv_xml) TYPE string.
  PRIVATE SECTION.
    DATA mv_counter TYPE i.
    DATA mv_data    TYPE string.
ENDCLASS.

CLASS lcl_data_to_xml DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        is_options TYPE kernel_call_transformation=>ty_options OPTIONAL
        io_heap    TYPE REF TO lcl_heap OPTIONAL.

    METHODS run
      IMPORTING
        iv_name       TYPE clike
        iv_ref        TYPE REF TO data
      RETURNING
        VALUE(rv_xml) TYPE string.

    METHODS serialize_heap
      RETURNING
        VALUE(rv_xml) TYPE string.
  PRIVATE SECTION.
    DATA mo_heap    TYPE REF TO lcl_heap.
    DATA ms_options TYPE kernel_call_transformation=>ty_options.
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

  METHOD add_data.

    DATA lo_descr       TYPE REF TO cl_abap_datadescr.
    DATA lv_data        TYPE string.
    DATA lv_name        TYPE string.
    DATA lo_data_to_xml TYPE REF TO lcl_data_to_xml.
    DATA lv_counter     LIKE mv_counter.


    mv_counter = mv_counter + 1.
    lv_counter = mv_counter.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( iv_ref ).
    lv_name = lo_descr->relative_name.

    CREATE OBJECT lo_data_to_xml
      EXPORTING
        io_heap = me.

    REPLACE ALL OCCURRENCES OF '=>' IN lv_name WITH '.'.

    lv_data = lv_data &&
      |<prg:{ lv_name } xmlns:prg="http://www.sap.com/abapxml/classes/class-pool/TODO" id="d{ mv_counter }">|.
    lv_data = lv_data && lo_data_to_xml->run(
      iv_name = 'DATAREF'
      iv_ref  = iv_ref ).
    lv_data = lv_data &&
      |</prg:{ lv_name }>|.

    mv_data = mv_data && lv_data.
    rv_id = |{ lv_counter }|.

  ENDMETHOD.

  METHOD add_object.
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
      LOOP AT lo_descr->attributes INTO ls_attribute WHERE is_class = abap_false.
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

    ms_options = is_options.
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

        IF ms_options-initial_components = kernel_call_transformation=>gc_options-suppress AND <any> IS INITIAL.
          rv_xml = rv_xml && |<{ iv_name }/>|.
          RETURN.
        ENDIF.

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
        IF ms_options-initial_components = kernel_call_transformation=>gc_options-suppress AND iv_ref->* IS INITIAL.
          RETURN.
        ENDIF.

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

        IF ms_options-initial_components = kernel_call_transformation=>gc_options-suppress AND <table> IS INITIAL.
          rv_xml = rv_xml && |<{ iv_name }/>|.
          RETURN.
        ENDIF.

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
            ELSE.
              rv_xml = |<{ iv_name } href="#o{ mo_heap->add_object( iv_ref->* ) }"/>|.
            ENDIF.
          WHEN OTHERS.
            IF iv_ref->* IS INITIAL.
              rv_xml = |<{ iv_name }/>|.
            ELSE.
              rv_xml = |<{ iv_name } href="#d{ mo_heap->add_data( iv_ref->* ) }"/>|.
            ENDIF.
        ENDCASE.
      WHEN OTHERS.
        ASSERT 1 = 'todo,lcl_data_to_xml2'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.

********************

CLASS lcl_object_to_sxml DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS run
      IMPORTING
        ii_writer TYPE REF TO if_sxml_writer
        source    TYPE any.

  PRIVATE SECTION.
    CLASS-DATA mi_writer TYPE REF TO if_sxml_writer.

    CLASS-METHODS traverse_write
      IMPORTING
        iv_ref TYPE REF TO data.

    CLASS-METHODS traverse_write_type
      IMPORTING
        iv_ref         TYPE REF TO data
      RETURNING
        VALUE(rv_type) TYPE string.
ENDCLASS.

CLASS lcl_object_to_sxml IMPLEMENTATION.

  METHOD run.
    DATA lv_name TYPE string.
    DATA result  TYPE REF TO data.

    mi_writer = ii_writer.

    mi_writer->open_element( name = 'object' ).
    WRITE '@KERNEL for (const name in INPUT.source) {'.
    WRITE '@KERNEL   lv_name.set(name);'.
    WRITE '@KERNEL   if (INPUT.source[name].constructor.name === "FieldSymbol") {'.
    WRITE '@KERNEL     result.assign(INPUT.source[name].getPointer());'.
    WRITE '@KERNEL   } else {'.
    WRITE '@KERNEL     result.assign(INPUT.source[name]);'.
    WRITE '@KERNEL   }'.
    mi_writer->open_element( name = 'str' ).
    mi_writer->write_attribute( name = 'name' value = to_upper( lv_name ) ).
    traverse_write( result ).
    mi_writer->close_element( ).
    WRITE '@KERNEL }'.
    mi_writer->close_element( ).
  ENDMETHOD.

  METHOD traverse_write_type.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
    CASE lo_type->type_kind.
      WHEN cl_abap_typedescr=>typekind_int
          OR cl_abap_typedescr=>typekind_int1
          OR cl_abap_typedescr=>typekind_int2
          OR cl_abap_typedescr=>typekind_int8
          OR cl_abap_typedescr=>typekind_decfloat
          OR cl_abap_typedescr=>typekind_decfloat16
          OR cl_abap_typedescr=>typekind_decfloat34.
        rv_type = 'num'.
      WHEN OTHERS.
        rv_type = 'str'.
    ENDCASE.
  ENDMETHOD.

  METHOD traverse_write.
* TODO: refactor this method

    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA lo_struc TYPE REF TO cl_abap_structdescr.
    DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    DATA ls_compo LIKE LINE OF lt_comps.
    DATA lv_ref TYPE REF TO data.
    FIELD-SYMBOLS <any> TYPE any.
    FIELD-SYMBOLS <table> TYPE ANY TABLE.
    FIELD-SYMBOLS <field> TYPE any.

*     WRITE '@KERNEL console.dir(iv_ref.getPointer());'.
    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
*    WRITE '@KERNEL console.dir(lo_type.get().kind.get());'.
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        mi_writer->open_element( name = 'object' ).

        lo_struc ?= lo_type.
        lt_comps = lo_struc->get_components( ).
        ASSIGN iv_ref->* TO <any>.
        LOOP AT lt_comps INTO ls_compo.
          ASSIGN COMPONENT ls_compo-name OF STRUCTURE <any> TO <field>.
          GET REFERENCE OF <field> INTO lv_ref.
          mi_writer->open_element( name = traverse_write_type( lv_ref ) ).
          mi_writer->write_attribute( name = 'name' value = to_upper( ls_compo-name ) ).
          traverse_write( lv_ref ).
          mi_writer->close_element( ).
        ENDLOOP.

        mi_writer->close_element( ).
      WHEN cl_abap_typedescr=>kind_elem.
        mi_writer->write_value( iv_ref->* ).
      WHEN cl_abap_typedescr=>kind_table.
        mi_writer->open_element( name = 'array' ).

        ASSIGN iv_ref->* TO <table>.
        LOOP AT <table> ASSIGNING <any>.
          GET REFERENCE OF <any> INTO lv_ref.
          IF cl_abap_typedescr=>describe_by_data( lv_ref->* )->kind = cl_abap_typedescr=>kind_elem.
            mi_writer->open_element( name = traverse_write_type( lv_ref ) ).
          ENDIF.
          traverse_write( lv_ref ).
          IF cl_abap_typedescr=>describe_by_data( lv_ref->* )->kind = cl_abap_typedescr=>kind_elem.
            mi_writer->close_element( ).
          ENDIF.
        ENDLOOP.

        mi_writer->close_element( ).
      WHEN OTHERS.
        ASSERT 1 = 'todo_traverse_write'.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

************************************************************************

CLASS lcl_object_to_string DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS run
      IMPORTING
        is_options       TYPE kernel_call_transformation=>ty_options
        source           TYPE any
      RETURNING
        VALUE(rv_result) TYPE string.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_object_to_string IMPLEMENTATION.

  METHOD run.

    DATA lv_name        TYPE string.
    DATA lo_data_to_xml TYPE REF TO lcl_data_to_xml.
    DATA result         TYPE REF TO data.

    rv_result = '<?xml version="1.0" encoding="utf-16"?><asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0"><asx:values>'.
    CREATE OBJECT lo_data_to_xml
      EXPORTING
        is_options = is_options.
    WRITE '@KERNEL if (INPUT.source.constructor.name === "Object") {'.
    WRITE '@KERNEL   for (const name in INPUT.source) {'.
    WRITE '@KERNEL     lv_name.set(name);'.
    WRITE '@KERNEL     if (INPUT.source[name].constructor.name === "FieldSymbol") {'.
    WRITE '@KERNEL       result.assign(INPUT.source[name].getPointer());'.
    WRITE '@KERNEL     } else {'.
    WRITE '@KERNEL       result.assign(INPUT.source[name]);'.
    WRITE '@KERNEL     }'.
    rv_result = rv_result && lo_data_to_xml->run(
      iv_name = to_upper( lv_name )
      iv_ref  = result ).
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL } else if (INPUT.source.constructor.name === "Table") {'.
* dynamic input via ABAP_TRANS_SRCBIND_TAB
    WRITE '@KERNEL   for (const row of INPUT.source.array()) {'.
*      WRITE '@KERNEL     console.dir(row);'.
    WRITE '@KERNEL     lv_name.set(row.get().name.get());'.
    WRITE '@KERNEL     result.assign(row.get().value.dereference());'.
    rv_result = rv_result && lo_data_to_xml->run(
      iv_name = to_upper( lv_name )
      iv_ref  = result ).
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL } else {'.
    ASSERT 1 = 'invalid input'.
    WRITE '@KERNEL }'.

    rv_result = rv_result &&
      |</asx:values>{ lo_data_to_xml->serialize_heap( ) }</asx:abap>|.

  ENDMETHOD.

ENDCLASS.

********************

CLASS lcl_object_to_ixml DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS run
      IMPORTING
        ii_doc TYPE REF TO if_ixml_document
        source TYPE any.
  PRIVATE SECTION.
    CLASS-METHODS traverse
      IMPORTING
        ii_parent TYPE REF TO if_ixml_element
        ii_doc    TYPE REF TO if_ixml_document
        iv_ref    TYPE REF TO data.
ENDCLASS.

CLASS lcl_object_to_ixml IMPLEMENTATION.

  METHOD run.
    DATA lv_name    TYPE string.
    DATA result     TYPE REF TO data.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_top     TYPE REF TO if_ixml_element.
    DATA li_sub     TYPE REF TO if_ixml_element.
    DATA lt_stab    TYPE abap_trans_srcbind_tab.
    DATA ls_stab    LIKE LINE OF lt_stab.

*    WRITE '@KERNEL console.dir(INPUT.source);'.
    WRITE '@KERNEL if (INPUT.source.constructor.name === "Table") {'.
    WRITE '@KERNEL   lt_stab = INPUT.source;'.
    WRITE '@KERNEL }'.
    ASSERT lines( lt_stab ) > 0.

    li_top = ii_doc->create_element_ns(
      prefix = 'asx'
      name   = 'abap' ).
    li_top->set_attribute(
      name  = 'xmlns:asx'
      value = 'http://www.sap.com/abapxml' ).
    li_top->set_attribute(
      name  = 'version'
      value = '1.0' ).
    ii_doc->append_child( li_top ).

    li_sub = ii_doc->create_element_ns(
      prefix = 'asx'
      name   = 'values' ).
    li_top->append_child( li_sub ).

    LOOP AT lt_stab INTO ls_stab.
      li_element = ii_doc->create_element( ls_stab-name ).
      traverse(
        ii_parent = li_element
        ii_doc    = ii_doc
        iv_ref    = ls_stab-value ).
      li_sub->append_child( li_element ).
    ENDLOOP.

  ENDMETHOD.

  METHOD traverse.

    DATA lo_type    TYPE REF TO cl_abap_typedescr.
    DATA lo_struc   TYPE REF TO cl_abap_structdescr.
    DATA lt_comps   TYPE cl_abap_structdescr=>component_table.
    DATA ls_compo   LIKE LINE OF lt_comps.
    DATA lv_ref     TYPE REF TO data.
    DATA li_element TYPE REF TO if_ixml_element.
    FIELD-SYMBOLS <any>   TYPE any.
    FIELD-SYMBOLS <table> TYPE ANY TABLE.
    FIELD-SYMBOLS <field> TYPE any.

    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).

    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struc ?= lo_type.
        lt_comps = lo_struc->get_components( ).
        ASSIGN iv_ref->* TO <any>.

        LOOP AT lt_comps INTO ls_compo.
          li_element = ii_doc->create_element( ls_compo-name ).
          ASSIGN COMPONENT ls_compo-name OF STRUCTURE <any> TO <field>.
          GET REFERENCE OF <field> INTO lv_ref.
          traverse(
            ii_parent = li_element
            ii_doc    = ii_doc
            iv_ref    = lv_ref ).
          ii_parent->append_child( li_element ).
        ENDLOOP.
      WHEN cl_abap_typedescr=>kind_elem.
        ii_parent->set_value( |{ iv_ref->* }| ).
      WHEN cl_abap_typedescr=>kind_table.
        ASSIGN iv_ref->* TO <table>.

        LOOP AT <table> ASSIGNING <any>.
          li_element = ii_doc->create_element( 'item' ).
          GET REFERENCE OF <any> INTO lv_ref.
          traverse(
            ii_parent = li_element
            ii_doc    = ii_doc
            iv_ref    = lv_ref ).
          ii_parent->append_child( li_element ).
        ENDLOOP.
      WHEN OTHERS.
        ASSERT 1 = 2.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_string_to_string DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS run
      IMPORTING
        source        TYPE any
        options       TYPE kernel_call_transformation=>ty_options
      RETURNING
        VALUE(result) TYPE string.
ENDCLASS.

CLASS lcl_string_to_string IMPLEMENTATION.
  METHOD run.
* this is not right, but works for the unit test
    WRITE '@KERNEL result.set(INPUT.source.get());'.

    IF options-xml_header = 'no'.
      REPLACE FIRST OCCURRENCE OF REGEX '<?.*?>' IN result WITH ''.
    ENDIF.
  ENDMETHOD.
ENDCLASS.